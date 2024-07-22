/////////////////////////////////////////////////////
/////////////environment/////////////////////////////
class env extends uvm_env;
  `uvm_component_utils(env)
  agent a;
  reg_apb_adapter adapter;
  RegModel regmodel;
  function new(input string path="env",uvm_component parent=null);
    super.new(path,parent);
  endfunction
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    a=agent::type_id::create("AGENT",this);
    adapter=reg_apb_adapter::type_id::create("adapter");
    regmodel=RegModel::type_id::create("regmodel");
    regmodel.build();
    regmodel.reset();
    regmodel.lock_model();
    regmodel.print();
    uvm_config_db #(RegModel)::set(null,"*","regmodel",regmodel);
  endfunction
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    regmodel.default_map.set_sequencer( .sequencer(a.seq), .adapter(adapter) );
    regmodel.default_map.set_base_addr('h0);        
    //regmodel.add_hdl_path("tb_top.DUT");
  endfunction
endclass