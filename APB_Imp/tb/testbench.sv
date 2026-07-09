// Code your testbench here
// or browse Examples

`include "apb_pkg.svh"

module tb();
  
  import apb_pkg ::*;
    
  logic clk;
  logic resetn;
  
  apb_if vif(.PCLK(clk) , .PRESETn(resetn));
  
  apb_ram_slave  dut(.vif(vif.slave));
  
  environment env;
  
  always #5 clk = ~clk;
  
  initial begin
    clk = 0;
    resetn = 0;
    env= new(vif,150);
  
    fork
      env.run();
    join_none
    
     #20 resetn = 1;
     
    
    
  end
  
  initial begin
    $dumpfile("dump.vcd");
    $dumpvars(0,tb);
    $dumpvars(0,tb.vif);
    $dumpvars(0,tb.dut);
  end
endmodule

  
  
  
      
      
      
                       
          
          
    
    
      
      
        
        
        
        
      
      
    
    
  