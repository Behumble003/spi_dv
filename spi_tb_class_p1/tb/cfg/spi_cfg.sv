//***************************************************************************************************************
// Author: Van Le
// vanleatwork@yahoo.com
// Phone: VN: 0396221156, US: 5125841843
//***************************************************************************************************************
//***************************************************************************************************************
// Author: Van Le
// vanleatwork@yahoo.com
// Phone: VN: 0396221156, US: 5125841843
//***************************************************************************************************************
class spi_cfg extends uvm_object;

  `uvm_object_utils(spi_cfg)

  // declare virtual interface handles here
  virtual apb_if apb_vif;
  virtual spi_if spi_vif;

  // declare other configuration properties here
  bit has_tx_fifo;
  bit has_rx_fifo;
  bit has_dma;
  int tx_fifo_depth = 8;
  int rx_fifo_depth = 8;
  int data_width = 8;
  
  //
  // NEW
  //
  function new(string name = "");
    super.new(name);
  endfunction

  
endclass
