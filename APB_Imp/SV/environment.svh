class environment;
  generator gen;
  driver drv;
  monitor mon;
  scoreboard sco;
  apb_coverage cov;
  
  event nextsco;
  
  mailbox #(transaction) gen2drv;
  mailbox #(transaction) mon2sco;
  mailbox #(transaction) mon2cov;
  virtual apb_if vif;
  
  function new(virtual apb_if vif , int count);
    this.vif=vif;
    gen2drv = new();
    mon2sco = new();
    mon2cov = new();
    
    gen = new(gen2drv , count);
    drv = new(gen2drv , vif);
    mon = new(vif , mon2sco,mon2cov);
    sco = new(mon2sco);
    cov = new(mon2cov);
    
    gen.nextsco = this.nextsco;
    sco.nextsco = this.nextsco;
    
  endfunction
  
  
  
  task test();
    fork
      gen.run();
      drv.run();
      mon.run();
      sco.run();
      cov.run();
    join_any
  endtask
  
  
  task run();
    test();
    wait(gen.done.triggered);
    #50; // time for final transaction to propagrate
    disable fork;
    $display("=================================================");
    $display("               TESTBENCH COMPLETE                ");
    $display("=================================================");
      sco.print_summary();
    $stop;
  endtask
endclass
