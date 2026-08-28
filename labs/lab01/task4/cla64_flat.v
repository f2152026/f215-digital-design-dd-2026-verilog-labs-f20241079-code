module cla64_flat(
    input [63:0] a,
    input [63:0] b,
    input cin,
    output [63:0] sum,
    output cout
);
    wire [63:0] p, g;
    wire [64:1] c;

    genvar i;
    generate
        for (i = 0; i < 64; i = i + 1) begin : gen_pg
            xor #(2) (p[i], a[i], b[i]);
            and #(2) (g[i], a[i], b[i]);
        end
    endgenerate

    genvar j, m;
    generate
        for (j = 1; j <= 64; j = j + 1) begin : gen_c
            wire [j:0] term;
            assign term[0] = &p[j-1:0] & cin;
            for (m = 1; m < j; m = m + 1) begin : gen_terms
                assign term[m] = &p[j-1:m] & g[m-1];
            end
            assign term[j] = g[j-1];
            assign #(2) c[j] = |term;
        end
    endgenerate

    assign cout = c[64];
    assign #(2) sum = p ^ {c[63:1], cin};

endmodule