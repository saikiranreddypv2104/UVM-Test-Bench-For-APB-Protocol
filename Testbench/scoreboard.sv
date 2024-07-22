
// /////////////////////////////////////////////////////
// ////////////scoreboard///////////////////////////////
class sco extends uvm_scoreboard;
  `uvm_component_utils(sco)
  transaction data;
  uvm_analysis_imp #(transaction,sco) recv;
  function new(input string name="SCO",uvm_component parent=null);
    super.new(name,parent);
  endfunction
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    data=transaction::type_id::create("data");
    recv=new("analysis_imp",this);
  endfunction
  
  virtual function void write(transaction data);
    bit [31:0] result;
    case(data.command)
      	4'b0000:result=data.a+data.b;
      	4'b0001:result=data.a-data.b;
      	4'b0010:result= data.a*data.b;
        4'b0011:result= data.a/data.b;
        4'b0100:result= data.a**data.b;
        4'b0101:result= data.a<data.b;
        4'b0110:result= data.a>data.b;
        4'b0111:result= data.a<=data.b;
        4'b1000:result= data.a>=data.b;
        4'b1001:result= data.a==data.b;
        4'b1010:result= data.a!=data.b;
        4'b1011:result= data.a&&data.b;
        4'b1100:result= data.a||data.b;
        4'b1101:result= data.a<<data.b;
        4'b1110:result= data.a>>data.b;
        4'b1111:result= data.a>>>data.b;
      endcase
    if(result==data.result) begin
      `uvm_info("SCO","------------------------------------>Test Passed",UVM_NONE);
      `uvm_info("SCO",$sformatf("a=%0d b=%0d command=%0d expected = %0d  actual = %0d",data.a,data.b,data.command,result,data.result),UVM_NONE);
    end
    else begin 
      `uvm_info("SCO","------------------------------------->Test Failed",UVM_NONE);
      `uvm_error("SCO",$sformatf("a=%0d b=%0d command=%0d expected = %0d actual = %0d",data.a,data.b,result,data.command,data.result));
    end
      $display("---------------------------------------------------");
  endfunction
endclass