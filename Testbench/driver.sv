
////////////////////////////////////////////
/////////////driver/////////////////////////
class driver extends uvm_driver #(bus_transaction);
  `uvm_component_utils(driver)
  bus_transaction data;
  virtual apb_if apbin;
  
  function new(input string path="DRV",uvm_component parent =null);
    super.new(path,parent);
  endfunction
 
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    data=bus_transaction::type_id::create("data");
    uvm_config_db #(virtual apb_if) :: get(this,"*","apbin",apbin);
  endfunction
  //////////////////////////////////////////
  task reset();//reseting the apb slave
       @(negedge apbin.pclk);
    	apbin.presetn=0;
      repeat(2) @(negedge apbin.pclk);//wait for two clock cycles
      	apbin.presetn=1;
  	endtask
  ////////////////////////////////////////////////
  task write(bit [31:0] data, bit [4:0] addr);
    @(negedge apbin.pclk);
    apbin.psel=1; apbin.paddr=addr; apbin.pwrite=1; apbin.pwdata=data;
    @(negedge apbin.pclk);
    apbin.penable=1;
    @(negedge apbin.pclk);
    apbin.penable=0;apbin.psel=0;
  endtask
  ////////////////////////////////////////////
  task read(bit [4:0] addr);
    @(negedge apbin.pclk);
    apbin.psel=1; apbin.paddr=5'd8; apbin.pwrite=0;
    @(negedge apbin.pclk);
    apbin.penable=1;
    
    @(negedge apbin.pclk);
    apbin.penable=0;apbin.psel=0;
    `uvm_info("DRV",$sformatf("the read data is %0d",apbin.prdata),UVM_NONE);
  endtask
  ////////////////////////////////////////////
  virtual task run_phase(uvm_phase phase);
    reset();
    forever begin
      seq_item_port.get_next_item(data);//ask for the data
      data.display("DRV");
      if(data.rd_or_wr==1) begin//read statement
        read(data.addr);
      end
      else begin//write 
        write(data.data,data.addr);
      end
      seq_item_port.item_done();//send the done signal    
    end
  endtask
  
endclass