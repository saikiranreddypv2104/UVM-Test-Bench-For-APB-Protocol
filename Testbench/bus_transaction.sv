class bus_transaction extends uvm_sequence_item;
  `uvm_object_utils(bus_transaction)
  bit [31:0] addr;
  bit [31:0] data;
  bit rd_or_wr;
  function new(input string name="bus_transaction");
    super.new(name);
  endfunction
  function void display(string tag="Don't Know");
    `uvm_info(tag,$sformatf("addr=%0d data=%0d rd_or_wr=%0d",this.addr,this.data,this.rd_or_wr),UVM_NONE);
  endfunction
endclass