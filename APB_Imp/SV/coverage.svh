class apb_coverage;
  
  mailbox #(transaction) mon2cov;
  
  covergroup slave_ram_cov_grp with function sample(transaction tx);
  	option.per_instance = 1;
  	option.name = "APB_FUNCTIONAL_COVERAGE";
    
    cov_op_mode : coverpoint tx.pwrite{
      bins op_read ={1'b0};
      bins op_write = {1'b1};
    }
    
    cov_memory_map : coverpoint tx.paddr{
      bins lower_half = {[0:508]};
      bins upper_half = {[512:1020]};
      bins illegal_boundary = {[1024:2048]};
    }
    
    cov_slave_err : coverpoint tx.pslverr {
      bins no_error = {1'b0};
      bins error_asserted = {1'b1};
    }
    
    cross_op_x_err : cross cov_op_mode, cov_slave_err;
  endgroup
  
  
  function new(mailbox #(transaction) mon2cov);
    this.mon2cov = mon2cov;
    slave_ram_cov_grp = new();
  endfunction
  
  task run();
    transaction tx;
    forever begin
      mon2cov.get(tx);
      slave_ram_cov_grp.sample(tx);
    end
  endtask
endclass
