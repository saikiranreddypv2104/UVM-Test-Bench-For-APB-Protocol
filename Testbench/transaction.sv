
/////////////////////////////////////////////
//////////////transaction class//////////////
class transaction extends uvm_sequence_item;
  `uvm_object_utils(transaction)
  randc bit [31:0] a,b;
  randc bit [3:0] command;
  bit [31:0] result;
  
  constraint command_range{
    command<16;//command value should be below 16
  }
  constraint a_b_range {
  			a<100;
    		b<100;
  }
  
  function new(input string name="transaction");
    super.new(name);
  endfunction
  
  function void display(string path="NONE");
    `uvm_info(path,$sformatf("a = %0d | b = %0d |command=%0b| result=%0d  ",this.a,this.b,this.command,this.result),UVM_NONE);
  endfunction

endclass