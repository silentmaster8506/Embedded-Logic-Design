module top(input Clk_100M,INPUT_2_VALID,INPUT_1_VALID,OUTPUT_READY,
output INPUT_1_READY,INPUT_2_READY,OUTPUT_VALID,input[31:0]INPUT_1_DATA,INPUT_2_DATA,
output[31:0]OUTPUT_DATA);
    wire root_ready,add_0_ready,root_valid,recip_valid,recip_ready,add_0_valid,log_ready;
    wire log_valid,const_ready;
    wire[31:0]add_0_data,recip_logy,rootx,logy;
    
    
    floating_point_3 sqrt(.aclk(Clk_100M),.s_axis_a_tvalid(INPUT_1_VALID),
    .s_axis_a_tready(INPUT_1_READY),
    .s_axis_a_tdata(INPUT_1_DATA),.m_axis_result_tvalid(root_valid),
    .m_axis_result_tready(root_ready),.m_axis_result_tdata(rootx));
    
    floating_point_4 log(.aclk(Clk_100M),.s_axis_a_tvalid(INPUT_2_VALID),.s_axis_a_tready(INPUT_2_READY),
    .s_axis_a_tdata(INPUT_2_DATA),.m_axis_result_tvalid(log_valid),
    .m_axis_result_tready(log_ready),.m_axis_result_tdata(logy));
    
    
    floating_point_2 recip(.aclk(Clk_100M),.s_axis_a_tvalid(log_valid),
    .s_axis_a_tready(log_ready),.s_axis_a_tdata(logy),.m_axis_result_tvalid(recip_valid),
    .m_axis_result_tready(recip_ready),.m_axis_result_tdata(recip_logy));
    
    
    floating_point_0 add_0(.aclk(Clk_100M),.s_axis_a_tvalid(root_valid),
    .s_axis_a_tready(root_ready),.s_axis_a_tdata(rootx),.s_axis_b_tvalid(1),
    .s_axis_b_tready(const_ready),.s_axis_b_tdata(32'b00111111110000000000000000000000),
    .m_axis_result_tdata(add_0_data),.m_axis_result_tvalid(add_0_valid),
    .m_axis_result_tready(add_0_ready));
    
    
    floating_point_1 add_1(.aclk(Clk_100M),.s_axis_a_tvalid(add_0_valid),
    .s_axis_a_tready(add_0_ready),.s_axis_a_tdata(add_0_data),
    .s_axis_b_tvalid(recip_valid),.s_axis_b_tready(recip_ready),.s_axis_b_tdata(recip_logy),
    .m_axis_result_tvalid(OUTPUT_VALID),.m_axis_result_tready(OUTPUT_READY),.m_axis_result_tdata(OUTPUT_DATA));
endmodule