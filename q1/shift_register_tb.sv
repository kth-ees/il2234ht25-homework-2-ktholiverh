`timescale 1ns/1ns

module shift_register_tb;

localparam N = 4;

logic clk, rst_n, serial_parallel, load_enable, serial_in, serial_out;
logic [N-1:0] parallel_in;
logic [N-1:0] parallel_out;

shift_register #(
    .N(N)
    ) DUT (
        .clk(clk),
        .rst_n(rst_n),
        .serial_parallel(serial_parallel),
        .load_enable(load_enable),
        .serial_in(serial_in),
        .parallel_in(parallel_in),
        .parallel_out(parallel_out),
        .serial_out(serial_out)
);

// clock setup
initial begin
    clk = 0;
    forever #5 clk = ~clk;
end

// simulation setup
initial begin
    // init, serial_out should always be the lsb of parallel_out
    rst_n = 1'b0; serial_parallel = 1'b0; load_enable = 1'b0; serial_in = 1'b0;
    parallel_in = '0;

    // start loading
    #12 rst_n = 1'b1; load_enable = 1'b1; 

    // test serial loading, after N clock cycles, parallel_out should be '1
    serial_in = 1'b1;
    for (int i = 0; i < N-1; i++) begin
        #10;
    end
    serial_in = 1'b0;

    //test reset, parallel_out should be '0
    #10 rst_n = 1'b0;
    #10 rst_n = 1'b1;

    // test parallel loading, parallel_out should be '1
    #10 serial_parallel = 1'b1; parallel_in = '1;

    // test enable, parallel_out should be '1
    #10 load_enable = 1'b0;
    #10 parallel_in = '0;

    // enable again, parallel_out should be '0
    #10 load_enable = 1'b1;
end

// monitor setup
initial begin
    $monitor("Time=%0t | clk=%b rst=%b s_p=%b e=%b s_in=%b p_in=%b p_out=%b s_out=%b",
        $time, clk, rst_n, serial_parallel, load_enable, serial_in, parallel_in, parallel_out, serial_out);
end

endmodule