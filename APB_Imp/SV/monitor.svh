class monitor;
  virtual apb_if vif;
  mailbox #(transaction) mon2sco;
  mailbox #(transaction) mon2cov;
  
  function new(virtual apb_if vif , mailbox #(transaction) mon2sco, mailbox #(transaction) mon2cov);
    this.vif = vif;
    this.mon2sco = mon2sco;
    this.mon2cov = mon2cov;
  endfunction
  
  task run();
    forever begin
      @(vif.mon_cb);
      if (vif.mon_cb.PSEL && vif.mon_cb.PREADY && vif.mon_cb.PENABLE) begin
        transaction t = new();
        t.paddr = vif.mon_cb.PADDR;
        t.pwdata = vif.mon_cb.PWDATA;
        t.pwrite = vif.mon_cb.PWRITE;
        t.prdata = vif.mon_cb.PRDATA;
        t.pslverr = vif.mon_cb.PSLVERR;
        
        
        t.display("MON");
        mon2sco.put(t);
        mon2cov.put(t);
      end
    end
  endtask
endclass
