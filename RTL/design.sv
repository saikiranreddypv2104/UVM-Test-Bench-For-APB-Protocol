/////////////////////////////
////////apb slave moduel/////

module apb_slave(
  input pclk,presetn, 
  input psel,pwrite,penable,
  input [4:0] paddr,//we have only 5 registers .so 3 bit address is enough
  input [31:0] pwdata,
  output reg [31:0] prdata,
  output reg pready
);
  reg [31:0] a,b,result;
  reg [3:0] command;
  reg enable;
  /////////////////////////////////////////////////////////////////////////
  /////////////////////////////////////////////////////////////////////////
  always @(posedge pclk) begin  //apb logic
   
    if(!presetn) begin//the slave is in reset state resetn=0
    	pready=0;
      	a=32'b0;
      	b=32'b0;
      	command=3'b000;
      	result=32'b0;
    end//if
    else begin//not in reset state resetn=1 
      case({psel,penable,pwrite})
        3'b100:begin//psel=1  penable=0 pwrite=0 "read mode with enable 0 so don't do anything"
          pready=0;
        end
        3'b110:begin//psel=1  penable=1 pwrite=0 "read mode with enable 1 so read the data"
          pready=1;
         
          case(paddr)
            5'd0:prdata=a;
            5'd4:prdata=b;
            5'd8:prdata=result;
            5'd12:prdata={28'b0,command};
            5'd16:prdata={31'b0,enable};
          endcase 
        end
        3'b101:begin//psel=1  penable=0 pwrite=1 "write with enable 0 so don't do anythin
          pready=0;
        end
        3'b111:begin//psel=1  penable=1 pwrite=1 "write operation wiht enable 1 . do write operation;

          pready=1;
          case(paddr)
            5'd0:a=pwdata;
            5'd4:b=pwdata;
 			//3'b010:result=pwdata;//you cannot change the result register
            5'd12:command = pwdata[3:0];// except lasb 4 bits ignore all other bits
            5'd16:enable=pwdata[0];// except lsb 0 bit ignore all other bits
          endcase 
        end
        default:begin
          pready=0;
          prdata=32'b0;
        end
      endcase
    end
  end
  ///////////////////////////////////////////////////////////////////////
  ///////////////////////////////////////////////////////////////////////
  //////////////////////////alu code
  always @(posedge pclk) begin
    if(enable==1) begin
      case(command)
       	4'b0000:result= a+b;
        4'b0001:result= a-b;
        4'b0010:result= a*b;
        4'b0011:result= a/b;
        4'b0100:result= a**b;
        4'b0101:result= a<b;
        4'b0110:result= a>b;
        4'b0111:result= a<=b;
        4'b1000:result= a>=b;
        4'b1001:result= a==b;
        4'b1010:result= a!=b;
        4'b1011:result= a&&b;
        4'b1100:result= a||b;
        4'b1101:result= a<<b;
        4'b1110:result= a>>b;
        4'b1111:result= a>>>b;
      endcase
     
    end
  end
  ///////////////////////////////////////////////////////////////////////
  ///////////////////////////////////////////////////////////////////////
endmodule

interface apb_if;
  logic pclk;
  logic presetn; 
  logic psel;
  logic pwrite;
  logic penable;
  logic [4:0] paddr;//we have only 5 registers .so 3 bit address is enough
  logic [31:0] pwdata;
  logic [31:0] prdata;
  logic pready;
endinterface

