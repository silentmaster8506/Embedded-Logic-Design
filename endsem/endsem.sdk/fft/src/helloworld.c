/******************************************************************************
*
* Copyright (C) 2009 - 2014 Xilinx, Inc.  All rights reserved.
*
* ... (License Header remains same) ...
******************************************************************************/

/*
 * helloworld.c: simple test application
 *
 * This application configures UART 16550 to baud rate 9600.
 * PS7 UART (Zynq) is not initialized by this application, since
 * bootrom/bsp configures it to baud rate 115200
 */

#include <stdio.h>
#include <complex.h>
#include <stdlib.h>
#include <math.h>       // Added for logf and cabsf
#include "platform.h"
#include "xil_printf.h"
#include <xtime_l.h>
#include "xparameters.h"
#include "xaxidma.h"
#include "dma_init.h"

#define N 8

/* 8-point bit reverse table */
const int rev16[N] = {0, 4, 2, 6, 1, 5, 3, 7};

/* Twiddle factors for 8-point FFT */
const float complex W[N / 2] = {
    1.00000000 - 0.00000000 * I,
    0.70710678 - 0.70710678 * I,
    0.00000000 - 1.00000000 * I,
    -0.70710678 - 0.70710678 * I
};

void bitreverse(const float complex dataIn[N], float complex dataOut[N]) {
    for (int i = 0; i < N; i++) {
        dataOut[i] = dataIn[rev16[i]];
    }
}

/* 8-point FFT uses only 3 stages */
void FFT_stages(float complex FFT_input[N], float complex FFT_output[N]) {
    float complex temp1[N], temp2[N];

    // Stage 1
    stage1:
    for (int i = 0; i < N; i += 2) {
        temp1[i]     = FFT_input[i] + FFT_input[i + 1];
        temp1[i + 1] = FFT_input[i] - FFT_input[i + 1];
    }

    // Stage 2
    stage2:
    for (int i = 0; i < N; i += 4) {
        temp2[i]     = temp1[i]     + W[0] * temp1[i + 2];
        temp2[i + 2] = temp1[i]     - W[0] * temp1[i + 2];

        temp2[i + 1] = temp1[i + 1] + W[2] * temp1[i + 3];
        temp2[i + 3] = temp1[i + 1] - W[2] * temp1[i + 3];
    }

    // Stage 3
    stage3:
    for (int i = 0; i < N / 2; i++) {
        FFT_output[i]     = temp2[i]     + W[i] * temp2[i + 4];
        FFT_output[i + 4] = temp2[i]     - W[i] * temp2[i + 4];
    }
}

int main() {
    init_platform();

    XTime PL_start_time, PL_end_time;
    XTime PS_start_time, PS_end_time;

    const float complex FFT_input[N] = {
        11 + 23 * I, 32 + 10 * I, 91 + 94 * I, 15 + 69 * I,
        47 + 96 * I, 44 + 12 * I, 96 + 17 * I, 49 + 58 * I
    };

    float complex FFT_output_sw[N], FFT_output_hw[N];
    float complex FFT_rev_sw[N];

    // --------------------------------------------------------
    // Software Calculation
    // --------------------------------------------------------
    XTime_SetTime(0);
    XTime_GetTime(&PS_start_time);

    // 1. Perform FFT
    bitreverse(FFT_input, FFT_rev_sw);
    FFT_stages(FFT_rev_sw, FFT_output_sw);

    // 2. Perform Log Magnitude: y = log(|fft(x)|)
    for(int i = 0; i < N; i++){
        // Calculate Magnitude (Absolute value of complex number)
        float magnitude = cabsf(FFT_output_sw[i]);

        // Calculate Natural Logarithm
        // Use log10f(magnitude) if you want Log Base 10
        // Added check to prevent log(0) which is -inf
        float log_val = (magnitude > 0.0f) ? logf(magnitude) : 0.0f;

        // Store result
        // Since magnitude and log are real numbers, Imaginary part is 0
        FFT_output_sw[i] = log_val + 0.0f * I;
    }

    XTime_GetTime(&PS_end_time);

    // --------------------------------------------------------
    // Hardware Calculation (DMA)
    // --------------------------------------------------------
    int status;
    XAxiDma AxiDMA;

    status = DMA_Init(&AxiDMA, XPAR_AXI_DMA_0_DEVICE_ID);
    if (status)
        return 1;

    XTime_SetTime(0);
    XTime_GetTime(&PL_start_time);

    // NOTE: For the data mismatch check to pass, your PL (FPGA) logic
    // must also implement the FFT + Log Magnitude logic.
    // If the PL only does FFT, the comparison below will fail.

    status = XAxiDma_SimpleTransfer(
        &AxiDMA,
        (UINTPTR)FFT_output_hw,
        (sizeof(float complex) * N),
        XAXIDMA_DEVICE_TO_DMA
    );

    status = XAxiDma_SimpleTransfer(
        &AxiDMA,
        (UINTPTR)FFT_input,
        (sizeof(float complex) * N),
        XAXIDMA_DMA_TO_DEVICE
    );

     while (XAxiDma_Busy(&AxiDMA, XAXIDMA_DMA_TO_DEVICE));
     while (XAxiDma_Busy(&AxiDMA, XAXIDMA_DEVICE_TO_DMA));

    XTime_GetTime(&PL_end_time);

    // --------------------------------------------------------
    // Comparison
    // --------------------------------------------------------
    for (int i = 0; i < N; i++) {
        printf(
            "\n\rPS Output- %f+%fI, PL Output- %f+%fI",
            crealf(FFT_output_sw[i]), cimagf(FFT_output_sw[i]),
            crealf(FFT_output_hw[i]), cimagf(FFT_output_hw[i])
        );

        float diff1 = fabs(crealf(FFT_output_sw[i]) - crealf(FFT_output_hw[i]));
        float diff2 = fabs(cimagf(FFT_output_sw[i]) - cimagf(FFT_output_hw[i]));

        // Increased tolerance slightly for float log operations
        if (diff1 >= 0.0001 && diff2 >= 0.0001) {
            printf("\n\rData Mismatch found at index %d !", i);
            // break; // Commented out break to see all values
        } else {
            printf(" DMA Transfer Successful!");
        }
    }

    printf("\n\r------- Execution Time Comparison --------");

    float time;
    time = (float)(PS_end_time - PS_start_time) / (COUNTS_PER_SECOND / 1000000);
    printf("\n\rExecution time for PS in Micro-seconds: %f", time);

    time = (float)(PL_end_time - PL_start_time) / (COUNTS_PER_SECOND / 1000000);
    printf("\n\rExecution time for PL in Micro-seconds: %f", time);

    return 0;
}
