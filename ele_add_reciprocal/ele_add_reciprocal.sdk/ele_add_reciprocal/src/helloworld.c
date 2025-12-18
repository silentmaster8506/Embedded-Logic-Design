#include <stdio.h>
#include <complex.h>
#include <stdlib.h>
#include <math.h>

#include "platform.h"
#include "xil_printf.h"
#include "xil_cache.h"
#include "xtime_l.h"

#include "xparameters.h"
#include "xaxidma.h"

#ifndef XPAR_AXI_DMA_0_DEVICE_ID
#define XPAR_AXI_DMA_0_DEVICE_ID XPAR_AXIDMA_0_DEVICE_ID
#endif

#define N 8    // ------------------------ 8 POINT FFT ---------------------

// =======================================================================
// BUFFERS (Aligned to 64 bytes for DMA Cache Safety)
// =======================================================================
static float complex FFT_input[N] __attribute__ ((aligned (64))) = {
    11+23*I, 32+10*I, 91+94*I, 15+69*I,
    47+96*I, 44+12*I, 96+17*I, 49+58*I
};

static float complex FFT_output_sw[N] __attribute__ ((aligned (64)));
static float complex FFT_output_hw[N] __attribute__ ((aligned (64)));
static float complex FFT_rev_sw[N]    __attribute__ ((aligned (64)));

// ---------------- BIT REVERSE TABLE (8-POINT) ----------------
static const int rev8[N] = {
    0, 4, 2, 6,
    1, 5, 3, 7
};

// ---------------- TWIDDLE FACTORS ----------------------------
// W[k] = exp(-j * 2 * pi * k / 8)
static const float complex W[4] = {
    1.00000000 - 0.00000000*I,  // W^0
    0.70710678 - 0.70710678*I,  // W^1
    0.00000000 - 1.00000000*I,  // W^2
   -0.70710678 - 0.70710678*I   // W^3
};

// ---------------- SOFTWARE FFT IMPLEMENTATION ----------------
void bitreverse(float complex in[N], float complex out[N])
{
    for (int i = 0; i < N; i++)
        out[i] = in[rev8[i]];
}

// Fixed 8-Point FFT function
void FFT_stages(float complex in[N], float complex out[N])
{
    // Intermediate buffers
    float complex t1[N];
    float complex t2[N];

    // --- STAGE 1 (2-point butterflies) ---
    // Reads from 'in', writes to 't1'
    for (int i = 0; i < N; i += 2) {
        t1[i]   = in[i] + in[i+1];
        t1[i+1] = in[i] - in[i+1];
    }

    // --- STAGE 2 (4-point butterflies) ---
    // Reads from 't1', writes to 't2'
    for (int i = 0; i < N; i += 4) {
        // Butterfly 0 (uses W^0)
        t2[i]   = t1[i] + W[0] * t1[i+2];
        t2[i+2] = t1[i] - W[0] * t1[i+2];

        // Butterfly 1 (uses W^2)
        t2[i+1] = t1[i+1] + W[2] * t1[i+3];
        t2[i+3] = t1[i+1] - W[2] * t1[i+3];
    }

    // --- STAGE 3 (8-point butterflies) ---
    // Reads from 't2', writes to 'out'
    // This is the loop you were concerned about.
    // By ensuring t2 is filled in Stage 2, this will now work.
    for (int i = 0; i < 4; i++) {
        out[i]   = t2[i] + W[i] * t2[i+4];
        out[i+4] = t2[i] - W[i] * t2[i+4];
    }
}

// ---------------- DMA INITIALIZATION ----------------
int DMA_Init(XAxiDma *AxiDma, u16 DeviceId)
{
    XAxiDma_Config *CfgPtr;
    CfgPtr = XAxiDma_LookupConfig(DeviceId);
    if (!CfgPtr) {
        xil_printf("No config found for %d\r\n", DeviceId);
        return XST_FAILURE;
    }

    int Status = XAxiDma_CfgInitialize(AxiDma, CfgPtr);
    if (Status != XST_SUCCESS) {
        xil_printf("DMA CfgInit failed\r\n");
        return XST_FAILURE;
    }

    if(XAxiDma_HasSg(AxiDma)){
        xil_printf("Device configured as SG mode\r\n");
        return XST_FAILURE;
    }

    // Disable interrupts, we use polling
    XAxiDma_IntrDisable(AxiDma, XAXIDMA_IRQ_ALL_MASK, XAXIDMA_DEVICE_TO_DMA);
    XAxiDma_IntrDisable(AxiDma, XAXIDMA_IRQ_ALL_MASK, XAXIDMA_DMA_TO_DEVICE);

    return XST_SUCCESS;
}

// =======================================================================
// MAIN
// =======================================================================
int main()
{
    init_platform();

    XAxiDma AxiDMA;
    int status;

    // Timer variables
    XTime ps_start, ps_end;
    XTime pl_start, pl_end;

    xil_printf("\n--- Starting 8-point FFT + 1/(1.5 + FFT(x)) Test ---\n");

    // =============================================================
    // PART A: SOFTWARE (PS)
    // =============================================================
    XTime_GetTime(&ps_start);

    // 1. Bit Reverse the input
    bitreverse(FFT_input, FFT_rev_sw);

    // 2. Compute FFT
    FFT_stages(FFT_rev_sw, FFT_output_sw);

    // 3. Post-Processing (MATCHING HARDWARE LOGIC)
    // The hardware calculates 1/(Real+1.5) and 1/(Imag+1.5) separately.
    for(int i = 0; i < N; i++) {
        float r = crealf(FFT_output_sw[i]);
        float im = cimagf(FFT_output_sw[i]);

        float r_new = 1.0f / (r + 1.5f);
        float im_new = 1.0f / (im + 1.5f);

        FFT_output_sw[i] = r_new + im_new * I;
    }

    XTime_GetTime(&ps_end);

    // =============================================================
    // PART B: HARDWARE (PL)
    // =============================================================
    status = DMA_Init(&AxiDMA, XPAR_AXI_DMA_0_DEVICE_ID);
    if (status != XST_SUCCESS) {
        xil_printf("DMA init failed!\n");
        cleanup_platform();
        return -1;
    }

    // Flush Input to DRAM so DMA can see it
    Xil_DCacheFlushRange((UINTPTR)FFT_input, sizeof(FFT_input));
    // Flush Output buffer to ensure we don't read stale cache later
    Xil_DCacheFlushRange((UINTPTR)FFT_output_hw, sizeof(FFT_output_hw));

    XTime_GetTime(&pl_start);

    // 1. Start RX (PL -> PS)
    status = XAxiDma_SimpleTransfer(
        &AxiDMA,
        (UINTPTR)FFT_output_hw,
        sizeof(FFT_output_hw),
        XAXIDMA_DEVICE_TO_DMA
    );
    if (status != XST_SUCCESS) {
        xil_printf("RX Transfer Failed\r\n");
        return -1;
    }

    // 2. Start TX (PS -> PL)
    status = XAxiDma_SimpleTransfer(
        &AxiDMA,
        (UINTPTR)FFT_input,
        sizeof(FFT_input),
        XAXIDMA_DMA_TO_DEVICE
    );
    if (status != XST_SUCCESS) {
        xil_printf("TX Transfer Failed\r\n");
        return -1;
    }

    // 3. Wait for DMA to finish
    while (XAxiDma_Busy(&AxiDMA, XAXIDMA_DMA_TO_DEVICE));
    while (XAxiDma_Busy(&AxiDMA, XAXIDMA_DEVICE_TO_DMA));

    XTime_GetTime(&pl_end);

    // Invalidate Output cache to read fresh data from DRAM
    Xil_DCacheInvalidateRange((UINTPTR)FFT_output_hw, sizeof(FFT_output_hw));

    // =============================================================
    // PART C: VERIFICATION & TIMING
    // =============================================================
    printf("\nComparing PS vs PL:\n");
    int error_count = 0;

    for (int i = 0; i < N; i++) {
        // Compare Real and Imag parts separately
        float diff_r = fabs(crealf(FFT_output_sw[i]) - crealf(FFT_output_hw[i]));
        float diff_i = fabs(cimagf(FFT_output_sw[i]) - cimagf(FFT_output_hw[i]));

        // Print format: Index | PS Value | PL Value
        printf("Idx %d | PS %.4f%+.4fi | PL %.4f%+.4fi",
               i,
               crealf(FFT_output_sw[i]), cimagf(FFT_output_sw[i]),
               crealf(FFT_output_hw[i]), cimagf(FFT_output_hw[i]));

        if (diff_r > 0.001 || diff_i > 0.001) {
            printf(" -> MISMATCH\n");
            error_count++;
        } else {
            printf(" -> MATCH\n");
        }
    }

    printf("\n--------------------------------------------\n");
    printf("FINAL RESULT: %s\n", (error_count == 0) ? "SUCCESS" : "FAIL");
    printf("--------------------------------------------\n");

    // Calculate Timing (microseconds)
    double ps_time_us = 1000000.0 * (double)(ps_end - ps_start) / (double)COUNTS_PER_SECOND;
    double pl_time_us = 1000000.0 * (double)(pl_end - pl_start) / (double)COUNTS_PER_SECOND;

    printf("Execution Time Summary:\n");
    printf("PS (Software) Time : %.2f us\n", ps_time_us);
    printf("PL (Hardware) Time : %.2f us\n", pl_time_us);
    printf("--------------------------------------------\n");

    cleanup_platform();
    return 0;
}
