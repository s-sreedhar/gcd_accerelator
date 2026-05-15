module HCF_datapath(
    output gt,
    output lt,
    output eq,
    input ldB,
    input ldA,
    input sel1,
    input sel2,
    input sel_in,
    input clk,
    input [15:0] data_in
);
    wire [15:0] aOut, bOut, x, y, bus, subOut;

    PIPO A (
        .data_out(aOut),
        .data_in(bus),
        .load(ldA),
        .clk(clk)
    );

    PIPO B (
        .data_out(bOut),
        .data_in(bus),
        .load(ldB),
        .clk(clk)
    );

    compare comp (
        .lt(lt),
        .gt(gt),
        .eq(eq),
        .data1(aOut),
        .data2(bOut)
    );

    mux mux_in1 (
        .out(x),
        .in1(aOut),
        .in0(bOut),
        .sel(sel1)
    );

    mux mux_in2 (
        .out(y),
        .in1(aOut),
        .in0(bOut),
        .sel(sel2)
    );

    mux mux_load (
        .out(bus),
        .in1(subOut),
        .in0(data_in),
        .sel(sel_in)
    );

    sub sb (
        .subout(subOut),
        .in1(x),
        .in2(y)
    );
endmodule