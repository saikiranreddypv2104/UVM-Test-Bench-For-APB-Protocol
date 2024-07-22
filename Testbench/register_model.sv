///////////////////////////////////////////
///////////////////////////////////////////class a_reg
class a_reg extends uvm_reg;
  `uvm_object_utils(a_reg)
  
  rand uvm_reg_field data;
 
  function new(string name="a_reg");
    super.new(name,32,build_coverage(UVM_NO_COVERAGE));
  endfunction
  
  virtual function void build();
    data=uvm_reg_field::type_id::create("data");
    data.configure(this,32,0,"RW",0,0,1,1,0);
  endfunction
endclass
////////////////////////////////////////
///////////////////////////////////////class b_reg

class b_reg extends uvm_reg;
  `uvm_object_utils(b_reg)
  
  rand uvm_reg_field data;
 
  function new(string name="b_reg");
    super.new(name,32,build_coverage(UVM_NO_COVERAGE));
  endfunction
  
  virtual function void build();
    data=uvm_reg_field::type_id::create("data");
    data.configure(this,32,0,"RW",0,0,1,1,0);
  endfunction
endclass
///////////////////////////////////////
//////////////////////////////////////class result_reg
class result_reg extends uvm_reg;
  `uvm_object_utils(result_reg)
  
  rand uvm_reg_field data;
 
  function new(string name="result_reg");
    super.new(name,32,build_coverage(UVM_NO_COVERAGE));
  endfunction
  
  virtual function void build();
    data=uvm_reg_field::type_id::create("data");
    data.configure(this,32,0,"RO",0,0,1,1,0);
  endfunction
endclass
/////////////////////////////////////////////
////////////////////////////////////////////command_reg
class command_reg extends uvm_reg;
  `uvm_object_utils(command_reg)
  uvm_reg_field data;
  
  function new(input string name="command_reg");
    super.new(name,4,build_coverage(UVM_NO_COVERAGE));
  endfunction
  
  virtual function void build();
    data=uvm_reg_field::type_id::create("data");
    data.configure(this,4,0,"RW",0,0,1,1,0);
  endfunction
  
endclass
/////////////////////////////////////////////////
/////////////////////////////////////////////////enable reg

class enable_reg extends uvm_reg;
  `uvm_object_utils(enable_reg)
  uvm_reg_field data;
  function new(input string name="enable_reg");
    super.new(name,1,build_coverage(UVM_NO_COVERAGE));
  endfunction
  
  virtual function void build();
    data=uvm_reg_field::type_id::create("data");
    data.configure(this,1,0,"RW",0,0,1,1,0);
  endfunction
endclass
///////////////////////////////////////////////////////
//////////////////////////////////////////////////////reg block
class module_reg extends uvm_reg_block;
  rand a_reg a;
  rand b_reg b;
  rand result_reg result;
  rand command_reg command;
  rand enable_reg enable;
  
  `uvm_object_utils(module_reg)
  
  function new(string name="module_reg");
    super.new(name);
  endfunction
  
  virtual function void build();
    a=a_reg::type_id::create("a");
    a.configure(this,null);
    a.build();
    
    b=b_reg::type_id::create("b");
    b.configure(this,null);
    b.build();
    
    result=result_reg::type_id::create("result");
    result.configure(this,null);
    result.build();
    
    command=command_reg::type_id::create("command");
    command.configure(this,null);
    command.build();
    
    enable=enable_reg::type_id::create("enable");
    enable.configure(this,null);
    enable.build();
    
    default_map=create_map("",`UVM_REG_ADDR_WIDTH 'h0, 4,UVM_LITTLE_ENDIAN,1);
    this.default_map.add_reg(a,`UVM_REG_ADDR_WIDTH 'd0,"RW");
    this.default_map.add_reg(b,`UVM_REG_ADDR_WIDTH 'd4,"RW");
    this.default_map.add_reg(result,`UVM_REG_ADDR_WIDTH 'd8,"RW");
    this.default_map.add_reg(command,`UVM_REG_ADDR_WIDTH 'd12,"RW");
    this.default_map.add_reg(enable,`UVM_REG_ADDR_WIDTH 'd16,"RW");
  endfunction
endclass

///////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////Top level class RegModel
class RegModel extends uvm_reg_block;
  rand module_reg mod_reg;
  uvm_reg_map apb_map;
  `uvm_object_utils(RegModel)
  
  function new(input string name="RegModel");
    super.new(name,.has_coverage(UVM_NO_COVERAGE));
  endfunction
  virtual function void build();
    default_map=create_map("apb_map",'h0,4,UVM_LITTLE_ENDIAN,0);
    mod_reg=module_reg::type_id::create("mod_reg");
    mod_reg.configure(this);
    mod_reg.build();
    default_map.add_submap(this.mod_reg.default_map,0);
  endfunction
endclass

