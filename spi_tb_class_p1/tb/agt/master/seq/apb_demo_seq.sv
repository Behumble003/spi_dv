//***************************************************************************************************************
// Author: Van Le
// vanleatwork@yahoo.com
// Phone: VN: 0396221156, US: 5125841843
//***************************************************************************************************************
/***************************************************************************************************************
 * Author: Van Le
 * vanleatwork@yahoo.com
 * Phone: VN: 0396221156, US: 5125841843
 ***************************************************************************************************************/
class apb_demo_seq #(type REQ = uvm_sequence_item, type RSP = uvm_sequence_item) extends uvm_sequence #(REQ,RSP);

  `uvm_object_param_utils(apb_demo_seq #(REQ,RSP))
  
  //declare spi configuration handle 
  spi_cfg spi_cfg_h;
  //
  // NEW
  //
  function new(string name = "apb_demo_seq");
    super.new(name);
  endfunction

  //
	// BODY
  //
  virtual task body();
    // The request and response packets must be of the type REQ and RSP
    REQ req_pkt;
    RSP rsp_pkt;

    // Retrieve the configuration object from the uvm_config_db
    // The context for the get call is the sequencer this sequence is running on.
    if( !uvm_config_db #(spi_cfg)::get(m_sequencer, "", "TB_CONFIG", spi_cfg_h) ) begin
       `uvm_fatal("NO_CFG", "Could not retrieve spi_cfg handle from config_db")
    end

    // Randomize the configuration object to get a random char_len
    `uvm_info(get_type_name(), "Randomizing spi_cfg_h...", UVM_LOW)
    if (!spi_cfg_h.randomize()) begin
      `uvm_fatal(get_type_name(), "Failed to randomize spi_cfg_h")
    end

    // Set the mask based on the randomized char_len
    spi_cfg_h.set_mask();

    // 1. Send a reset transaction
    `uvm_info(get_type_name(), "Sending reset transaction...", UVM_LOW)
    req_pkt = REQ::type_id::create("req_pkt_reset");
    start_item(req_pkt);
    assert(req_pkt.randomize() with {do_reset == 1;}); //randomize() ensures other fields are randomized
    finish_item(req_pkt);
    get_response(rsp_pkt);

    // 2. Send a wait transaction
    `uvm_info(get_type_name(), "Sending wait transaction...", UVM_LOW)
    req_pkt = REQ::type_id::create("req_pkt_wait");
    start_item(req_pkt);
    assert(req_pkt.randomize() with {do_wait == 1;});
    finish_item(req_pkt);
    get_response(rsp_pkt);

    // 3. Send 4 APB write transactions to Tx registers
    `uvm_info(get_type_name(), "Sending APB writes to Tx registers...", UVM_LOW)
    req_pkt = REQ::type_id::create("req_pkt_tx0");
    start_item(req_pkt);
    assert(req_pkt.randomize() with {wr_rd == 1; addr == 32'h00; wdata == 32'haaaaaaaa;});
    finish_item(req_pkt);
    get_response(rsp_pkt);

    req_pkt = REQ::type_id::create("req_pkt_tx1");
    start_item(req_pkt);
    assert(req_pkt.randomize() with {wr_rd == 1; addr == 32'h04; wdata == 32'hbbbbbbbb;});
    finish_item(req_pkt);
    get_response(rsp_pkt);

    req_pkt = REQ::type_id::create("req_pkt_tx2");
    start_item(req_pkt);
    assert(req_pkt.randomize() with {wr_rd == 1; addr == 32'h08; wdata == 32'hcccccccc;});
    finish_item(req_pkt);
    get_response(rsp_pkt);

    req_pkt = REQ::type_id::create("req_pkt_tx3");
    start_item(req_pkt);
    assert(req_pkt.randomize() with {wr_rd == 1; addr == 32'h0c; wdata == 32'hdddddddd;});
    finish_item(req_pkt);
    get_response(rsp_pkt);

    // 4. Send a transaction to the control register to start the transfer
    `uvm_info(get_type_name(), "Sending APB write to control register...", UVM_LOW)
    req_pkt = REQ::type_id::create("req_pkt_ctrl");
    start_item(req_pkt);
    assert(req_pkt.randomize() with {
      wr_rd == 1;
      addr  == 32'h10;
      wdata == {
          18'b0,              // Unused bits
          spi_cfg_h.ass,      // [13]
          spi_cfg_h.ie,       // [12]
          spi_cfg_h.lsb,      // [11]
          spi_cfg_h.txneg,    // [10]
          spi_cfg_h.rxneg,    // [9]
          1'b1,               // [8] GO_BSY
          1'b0,               // [7] Unused
          spi_cfg_h.char_len  // [6:0]
      };
    });
    finish_item(req_pkt);
    get_response(rsp_pkt);

  endtask

endclass
