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

  // Control register fields
  rand bit        ass;
  rand bit        ie;
  rand bit        lsb;
  rand bit        txneg;
  rand bit        rxneg;
  rand bit [6:0]  char_len;

  // Mask for data checking
  bit [127:0] mask;

  // Constraints for control register fields
  constraint phase1_c {
    ass   == 1;
    ie    == 1;
    lsb   == 1;
    txneg == 1;
    rxneg == 0;
  }

  function new(string name = "spi_cfg");
    super.new(name);
  endfunction

  // set_mask function to create a mask based on char_len
  function void set_mask();
    if (char_len == 0) begin
      mask = '1; // All 1s for 128 bits
    end else begin
      mask = '0;
      mask = (128'b1 << char_len) - 1;
    end
  endfunction

endclass
