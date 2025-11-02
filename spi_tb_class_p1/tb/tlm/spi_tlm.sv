//***************************************************************************************************************
// Author: Van Le
// vanleatwork@yahoo.com
// Phone: VN: 0396221156, US: 5125841843
//***************************************************************************************************************
class spi_tlm extends uvm_sequence_item;

  // Transaction data fields
  rand bit [31:0] addr;    // APB address (32 bits)
  rand bit [31:0] wdata;   // APB write data (32 bits)
  rand bit        wr_rd;   // command (1 = write, 0 = read)
  bit             do_reset;// (1 = reset, 0 = no action)
  bit             do_wait; // (1 = wait a number of clocks specified in the driver, 0 = no action)

 `uvm_object_utils(spi_tlm)
 
  //
  // NEW
  //
  function new(string name = "spi_tlm"); 
    super.new(name);
  endfunction
  
endclass
