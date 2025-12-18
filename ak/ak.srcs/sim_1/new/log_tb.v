`timescale 1ns / 1ps

module log_tb;

  reg Clock;
  reg [31:0] s_data_x, s_data_y, s_data_c;  
  reg s_valid_x, s_valid_y;
  wire s_ready_x, s_ready_y;
  wire [31:0] z_data;
  wire z_valid;
  reg z_ready;

  log_top t1(
    .clk(Clock),
    .x(s_data_x),
    .x_val(s_valid_x),
    .x_ready(s_ready_x),
    .y(s_data_y),
    .y_val(s_valid_y),
    .y_ready(s_ready_y),
    .c(s_data_c),    
    .z_data(z_data),
    .z_valid(z_valid),
    .z_ready(z_ready)
  );

  initial
  begin
      Clock = 0;
  end

  always
  begin
      #5 Clock = ~Clock;
  end

  initial
  begin
      s_valid_x = 0;
      s_valid_y = 0;
      s_data_x = 0;
      s_data_y = 0;
      s_data_c = 32'b00111111110000000000000000000000; // 1.5 in IEEE 754
      z_ready = 1;

      #50;
      // First case: x = 15.0, y = 0.5
      s_data_x = 32'b01000001011100000000000000000000; // 15.0 in IEEE 754
      s_data_y = 32'b00111111000000000000000000000000; // 0.5 in IEEE 754
      s_valid_x = 1;
      s_valid_y = 1;
      
      @(posedge Clock);
      while (!(s_ready_x && s_ready_y)) begin
          @(posedge Clock);
      end
      
      s_valid_x = 0;
      s_valid_y = 0;

      @(posedge z_valid);
      $display("z_data = %b", z_data); // Display result when z_valid is high

      // Wait for z_valid to go low before moving to the next case
      @(negedge z_valid);
      
      #50;
      // Second case: x = 4.0, y = e
      s_data_x = 32'b01000000100000000000000000000000; // 4.0 in IEEE 754
      s_data_y = 32'b01000000001011011100001010001111; // e in IEEE 754
      s_valid_x = 1;
      s_valid_y = 1;
      
      @(posedge Clock);
      while (!(s_ready_x && s_ready_y)) begin
          @(posedge Clock);
      end

      s_valid_x = 0;
      s_valid_y = 0;

      @(posedge z_valid);
      $display("z_data = %b", z_data); // Display result when z_valid is high

      // Wait for z_valid to go low before moving to the next case
      @(negedge z_valid);
      
      #50;
      // Third case: x = 25.0, y = 1.0
      s_data_x = 32'b01000001110010000000000000000000; // 25.0 in IEEE 754
      s_data_y = 32'b00111111100000000000000000000000; // 1.0 in IEEE 754
      s_valid_x = 1;
      s_valid_y = 1;
      
      @(posedge Clock);
      while (!(s_ready_x && s_ready_y)) begin
          @(posedge Clock);
      end

      s_valid_x = 0;
      s_valid_y = 0;

      @(posedge z_valid);
      $display("z_data = %b", z_data); // Display result when z_valid is high

      // Wait for z_valid to go low before stopping the simulation
      @(negedge z_valid);

      #20 $stop;
  end

endmodule