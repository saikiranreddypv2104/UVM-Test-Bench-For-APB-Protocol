
////////////////////////////////////////////
////////////generator///////////////////////
class generator extends uvm_sequence #(transaction);
  `uvm_object_utils(generator)
  transaction t;
  bus_transaction bus_item;
  RegModel regmodel;
  uvm_status_e   status;
  uvm_reg_data_t read_data;
  
  function new(input string path="GEN");
    super.new(path);
  endfunction
  
  virtual task body();
    t=transaction::type_id::create("t");
    bus_item=bus_transaction::type_id::create("bus_item");
    
    if(!uvm_config_db#(RegModel) :: get(null, "*", "regmodel", regmodel))
      `uvm_fatal("GEN", "reg_model is not set at top level");
    repeat(16) begin
      t.randomize();
      t.display("GEN");
      regmodel.mod_reg.a.write(status,t.a);
      regmodel.mod_reg.b.write(status,t.b);
      regmodel.mod_reg.command.write(status,t.command);
      
      regmodel.mod_reg.enable.write(status,32'b1);
      regmodel.mod_reg.enable.write(status,32'b0);
      
      regmodel.mod_reg.result.read(status,read_data);
//     start_item(t);
//     t.randomize();
//     t.display("GEN");
//     finish_item(t);
    end
  endtask
  
endclass