module shift_register #(parameter N=4)
                      (input logic clk,
                       input logic rst_n,
                       input logic serial_parallel,
                       input logic load_enable,
                       input logic serial_in,
                       input logic [N-1:0] parallel_in,
                       output logic [N-1:0] parallel_out,
                       output logic serial_out);

//complete here
always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n)
        parallel_out <= '0;
    else if (!serial_parallel && load_enable)
        parallel_out <= {serial_in, parallel_out[N-1:1]}; // Shifts parallel_out one bit to right and puts in serial_in
    else if (serial_parallel && load_enable)
        parallel_out <= parallel_in;
    // Just for clarity. If no enable, do nothing
    //else 
    //    parallel_out <= parallel_out;
end

assign serial_out = parallel_out[0];

endmodule