class generator;
  transaction t;
  mailbox #(transaction) gen2drv;
  int count;
  event nextsco;
  event done;
  
  function new(mailbox #(transaction) gen2drv , int count);
    this.gen2drv = gen2drv;
    this.count = count;
  endfunction
  
  task run();
    t = new();
    repeat(count) begin
      $display("---------------------------------------------------------------------");
      
      assert(t.randomize) else $display("Randomization Failed");
      gen2drv.put(t.copy());
      t.display("GEN");
      @(nextsco);
    end
    ->done;
  endtask
endclass
