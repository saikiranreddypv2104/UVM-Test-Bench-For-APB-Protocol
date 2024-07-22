
//////////////agent//////////////////////////////////

class agent extends  uvm_agent;
  `uvm_component_utils(agent)
  driver d;
  monitor m;
  uvm_sequencer #(bus_transaction) seq;
  function new(input string path="agent",uvm_component parent =null);
    super.new(path,parent);
  endfunction
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    d=driver::type_id::create("DRV",this);
    m=monitor::type_id::create("MON",this);
    seq = uvm_sequencer #(bus_transaction)::type_id::create("SEQ",this);
  endfunction
  
  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    d.seq_item_port.connect(seq.seq_item_export);
  endfunction
  
endclass