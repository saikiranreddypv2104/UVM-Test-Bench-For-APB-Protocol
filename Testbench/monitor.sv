
/////////////////////////////////////////////////////
////////////////monitor//////////////////////////////
class monitor extends uvm_monitor;
  `uvm_component_utils(monitor)

   
  covergroup c;
    option.name="cvr_axi";
    option.per_instance = 1;  
    coverpoint data.command;
    coverpoint apbin.paddr {
      bins a={0};
      bins b={4};
      bins command={8};
      bins enable={12};
    }
    coverpoint apbin.pwrite;
  endgroup
  //c cfg;
  transaction data,prev;
  virtual apb_if apbin;
  uvm_analysis_port #(transaction) send;
  function new(input string path="MON",uvm_component parent=null);
    super.new(path,parent);
    c = new();
  endfunction
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    send=new("analysis_port",this);
    data = transaction::type_id::create("data");
    uvm_config_db #(virtual apb_if)::get(null,"*","apbin",apbin);
    //c = new;
  endfunction
  

  
  
  task run_phase(uvm_phase phase);

    forever begin
      @(negedge apbin.penable);
      
      if(apbin.pwrite==1'b1) begin
        if(apbin.paddr==0) data.a=apbin.pwdata;
        else if(apbin.paddr==4) data.b=apbin.pwdata;
        else if (apbin.paddr==12) data.command=apbin.pwdata;
      end
      else begin
        data.result=apbin.prdata;
        send.write(data);
        `uvm_info("MON",$sformatf("[%0t] a=%0d b=%0d command =%4b result = %0d",$time,data.a,data.b,data.command,data.result),UVM_NONE);
      end
      c.sample();
    end
  endtask
  
  virtual function void report_phase(uvm_phase phase);
    super.report_phase(phase);
    $display("coverage is %0d",c.get_coverage());
  endfunction
  
  
 endclass