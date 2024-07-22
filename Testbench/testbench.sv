
`include "uvm_macros.svh"
import uvm_pkg::*;
`include "package.sv"
//////////////////////////////////////////////////////
////////////////test//////////////////////////////////
class test extends uvm_test;
  `uvm_component_utils(test)
  env e;
  generator gen;
  sco s;
  function new(input string path="test",uvm_component parent =null);
    super.new(path,parent);
  endfunction
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    e=env::type_id::create("env",this);
    gen=generator::type_id::create("GEN",this);
    s=sco::type_id::create("SCO",this);
  endfunction
  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    e.a.m.send.connect(s.recv);
  endfunction
  virtual task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    gen.start(e.a.seq);
    #60;
    phase.drop_objection(this);
  endtask
  virtual function void end_of_elaboration_phase(uvm_phase phase);
    super.end_of_elaboration_phase(phase);
    uvm_top.print_topology();
  endfunction
  
endclass
//////////////////////////////////////////////////////////////////////////////
////////////////////////tb////////////////////////////////////////////////////
module tb;
  apb_if apbin();
  

  apb_slave dut ( 
    
    			 .pclk(apbin.pclk),
                 .presetn(apbin.presetn),
                 .psel(apbin.psel),
                 .pwrite(apbin.pwrite),
                 .penable(apbin.penable),
                 .paddr(apbin.paddr),
                 .pwdata(apbin.pwdata),
                 .prdata(apbin.prdata),
                 .pready(apbin.pready)
                );
    initial begin
      apbin.pclk=0;
      apbin.presetn=1;
  	end
	always #5 apbin.pclk = ~apbin.pclk;//clock creation
  
    initial begin
    $dumpfile("dump.vcd"); $dumpvars;
  	end
  
  	initial begin
      uvm_config_db #(virtual apb_if)::set(null, "*", "apbin", apbin);
      run_test("test");//uvm test
  	end
//   initial begin
//     #500 $finish;
//   end

 
endmodule