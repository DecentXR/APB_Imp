module apb_ram_slave #(parameter int WAIT_STATES = 3)(apb_if.slave vif);
  logic [31:0] mem [255:0];
  logic [7:0] wait_cnt;
  
  assign vif.PSLVERR = (vif.PSEL && ((vif.PADDR>=32'd1024) || (vif.PADDR[1:0] != 2'b00))) ? 1'b1:1'b0;
  
  always_ff @(posedge vif.PCLK or negedge vif.PRESETn) begin
    if(!vif.PRESETn) begin
      wait_cnt <=8'd0;
    end
    else begin
      if(vif.PSEL && vif.PENABLE &&!vif.PREADY)
        wait_cnt <= wait_cnt + 1'd1;
      else if(!vif.PENABLE) wait_cnt <=8'd0;
    end
  end
  
  assign vif.PREADY = (wait_cnt == WAIT_STATES);
  
  always_ff @(posedge vif.PCLK) begin
    if(vif.PSEL && vif.PENABLE && vif.PWRITE && vif.PREADY && !vif.PSLVERR) begin
      mem[vif.PADDR[9:2]] <= vif.PWDATA;
    end
  end
  
  assign vif.PRDATA = (vif.PSEL && !vif.PWRITE && !vif.PSLVERR) ? mem[vif.PADDR[9:2]]:32'h00000000;
endmodule
  
interface apb_if( input PCLK , input PRESETn);
  logic PSEL;
  logic PENABLE;
  logic PWRITE;
  logic [31:0] PADDR;
  logic [31:0] PWDATA;
  logic [31:0] PRDATA;
  logic PREADY;
  logic PSLVERR;
  
  modport slave( input PSEL,PENABLE,PWRITE, PADDR,PWDATA,PCLK,PRESETn,
                output PRDATA,PREADY,PSLVERR);
  
  clocking cb@(posedge PCLK);
    default input #1step output #1ns;
    output PSEL,PENABLE,PWRITE,PADDR,PWDATA;
    input PRDATA,PREADY,PSLVERR;
  endclocking
  
  clocking mon_cb @(posedge PCLK);
    default input #1step;
    input PSEL, PENABLE, PWRITE, PADDR, PWDATA, PRDATA, PREADY, PSLVERR;
  endclocking
endinterface
                
        
        
      
                          
                       
                        
   
                        
  