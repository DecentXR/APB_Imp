class transaction;
  randc bit pwrite;
  rand bit [31:0] paddr;
  rand bit [31:0] pwdata;
  bit[31:0] prdata;
  bit pready;
  bit pslverr;
  
  constraint c_addr {paddr dist {[0:1020] :/80,
                                 [1024:2048] :/20}; 
                     paddr[1:0]==2'b0;}
  
  function void display(input string tag);
    $display("[%0t] [%s] : %s ADDR : 0x%08h , DATA : 0x%08h , ERR = %0b", $time,tag,(pwrite ? "WRITE":"READ"),paddr,(pwrite ? pwdata:prdata),pslverr);
  endfunction
  
  function transaction copy();
    copy = new();
    copy.pwrite=this.pwrite;
    copy.paddr=this.paddr;
    copy.pwdata=this.pwdata;
    copy.prdata=this.prdata;
    copy.pready=this.pready;
    copy.pslverr=this.pslverr;
  endfunction
     
endclass