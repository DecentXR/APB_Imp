class driver;
  virtual apb_if vif;
  mailbox #(transaction) gen2drv;
  
  function new(mailbox #(transaction) gen2drv , virtual apb_if vif);
    this.gen2drv = gen2drv;
    this.vif = vif;
  endfunction
  
  
  
  
  
  task run();
    vif.PSEL<=1'b0;
    vif.PENABLE<=1'b0;
    vif.PWRITE<=1'b0;
    vif.PADDR<=1'b0;
    vif.PWDATA<=1'b0;
    
    wait(vif.PRESETn ==1'b1);
    forever begin
      transaction t;
      gen2drv.get(t);
      @(vif.cb);
        //setup phase 
        vif.cb.PSEL <=1'b1;
        vif.cb.PENABLE <=1'b0;
        vif.cb.PWRITE <=t.pwrite;
        vif.cb.PADDR <= t.paddr;
      if(t.pwrite) vif.cb.PWDATA <=t.pwdata;
        
        //access phase
      @(vif.cb);
          vif.cb.PENABLE <= 1'b1;
        
      @(vif.cb);
      while (vif.cb.PREADY == 1'b0) begin
        @(vif.cb);
      end
      
     
      vif.cb.PSEL <= 1'b0;
      vif.cb.PENABLE <= 1'b0;
    end
  endtask
endclass
