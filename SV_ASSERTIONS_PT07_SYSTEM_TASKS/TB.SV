module system_assertion();

logic clk = 0;
always #1 clk ++;

logic req,gnt;
//-------------------------------------------------
// Property Specification Layer
//-------------------------------------------------
property system_prop;
  @ (posedge clk) 
      ($rose(req) && $past(!req,1)) |=> 
         ($rose(gnt) && $past(!gnt,1));
endproperty
//-------------------------------------------------
// Assertion Directive Layer
//-------------------------------------------------
system_assert : assert property (system_prop);
//-------------------------------------------------
// Generate input vectors
//-------------------------------------------------
initial begin
  req <= 0;gnt <= 0;
  repeat(10) @ (posedge clk);
  req <= 1;
  @( posedge clk);
  gnt <= 1;
  req <= 0;
  @( posedge clk);
  // Make the assertion fail now
  req <= 0;gnt <= 0;
  repeat(10) @ (posedge clk);
  req <= 1;
  @( posedge clk);
  req <= 0;
  gnt <= 0;
  // Terminate the sim
  #30 $finish;
end

endmodule

//$rose returns true, when least significant bit changes to 1.
//$fell returns true, when least significant bit changes to 0.
//$stable returns true, if value did not change since last clock event to current clock event.
//$past returns value n clock events before.