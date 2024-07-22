class coverage extends uvm_component;
  
  virtual apb_if apbin;
  
  covergroup c @(posedge apbin.penable);
    option.name="cvr_axi";
    option.per_instance = 1;  
    //coverpoint data.command;
    coverpoint apbin.paddr {
      bins a={0};
      bins b={4};
      bins command={8};
      bins enable={12};
    }
  endgroup
  
  function new(input string name="coverage",uvm_component parent=null);
    super.new(name,parent);
  endfunction
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    uvm_config_db #(virtual apb_if)::get(null,"*","apbin",apbin);
  endfunction
  
  
  
  task run_phase(uvm_phase phase);
    forever begin
      @(posedge apbin.penable);
       c.sample();
    end
  endtask
  
endclass