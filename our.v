module our (
  input clk,
  input finish
);
  always @(posedge clk) begin
	if (finish) begin 
	  $display("simulation finish");
	  $finish;
	end
    else begin
      $display("Hello World"); 
    end
  end

  initial begin
	if ($test$plusargs("trace") != 0) begin
	  $display("[%0t] Tracing to logs/vlt_dump.vcd..\n", $time);
	  $dumpfile("logs/vlt_dump.vcd");
	  $dumpvars();
	end
	$display("[%0t] Model running...\n", $time);
  end
endmodule
