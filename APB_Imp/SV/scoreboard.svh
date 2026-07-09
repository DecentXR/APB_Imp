class scoreboard;
  event nextsco;
  
  mailbox #(transaction) mon2sco;
  
  bit [31:0] ref_mem [bit[31:0]];
  int pass_count =0;
  int fail_count =0;
  
  function new(mailbox #(transaction) mon2sco);
    this.mon2sco = mon2sco;
  endfunction
  
  task run();
    transaction t;
    forever begin
      mon2sco.get(t);
      t.display("SCO");
      
      if(!t.pslverr) begin
        if(t.pwrite) begin
          ref_mem[t.paddr] = t.pwdata;
          $display("[SCO] : DATA STORED DATA : 0x%08h ADDR : 0x%08h",t.pwdata,t.paddr);
        end
        else begin
          if (ref_mem.exists(t.paddr)) begin
            if(ref_mem[t.paddr] == t.prdata) begin
              $display("[PASS] Addr: 0x%08h | Expected: 0x%08h, Got: 0x%08h", t.paddr, ref_mem[t.paddr], t.prdata);
              pass_count ++;
            end
            else begin
              $error("[FAIL] Addr: 0x%08h | Expected: 0x%08h, Got: 0x%08h", t.paddr, ref_mem[t.paddr], t.prdata);
              fail_count++;
            end
          end
        end
      end
        else begin
          $display("[SCO] : SLAVE ERROR DETECTED");
        end
      ->nextsco;
      end
  endtask
    function void print_summary();
    $display("\n=================================================");
    $display("               SCOREBOARD SUMMARY                ");
    $display("=================================================");
    $display(" Total Passed : %0d", pass_count);
    $display(" Total Failed : %0d", fail_count);
    $display("=================================================");
    if(fail_count == 0)
      $display(" Status       : ** ALL TESTS PASSED **");
    else
      $display(" Status       : ** SIMULATION FAILED **");
    $display("=================================================\n");
  endfunction
  
endclass
