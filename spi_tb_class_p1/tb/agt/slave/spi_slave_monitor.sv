//***************************************************************************************************************
// Author: Van Le
// vanleatwork@yahoo.com
// Phone: VN: 0396221156, US: 5125841843
//***************************************************************************************************************
class spi_slave_monitor #(type PKT = uvm_sequence_item) extends uvm_monitor;

  `uvm_component_param_utils(spi_slave_monitor #(PKT))
  
  //
  // NEW
  //
  function new(string name, uvm_component parent);
    super.new(name,parent);
  endfunction
  
  //
  // CONNECT phase
  //
  
  //
  // RUN phase
  //
   
endclass
