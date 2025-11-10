//***************************************************************************************************************
// Author: Van Le
// vanleatwork@yahoo.com
// Phone: VN: 0396221156, US: 5125841843
//***************************************************************************************************************
// Step 3: (30 pts) In file tb/agt/master/apb_driver.sv, create a parameterized APB driver (apb_driver)
//         extending from uvm_driver
//   Declare the following:
//     virtual clk_rst_if clk_rst_vif;
//     virtual apb_if apb_vif;
//     spi_cfg spi_cfg_h;
//   In the connect phase, use uvm_config_db::get to retrieve the following.
//       Handle to the clk_rst_if
//       Handle to the apb_if
//       Handle to spi_cfg (configuration object)
//   In the run phase, perform the following.
//     Loop forever at each clock
//       Use seq_item_port.get_next_item(pkt) to retrieve the next packet (debug message)
//       If the packet is a reset packet (do_reset = 1) perform the reset by caling clk_rst_if.do_reset(5)
//       else if the packet is a wait packet (do_wait = 1) call clk_rst_if.do_wait(5)
//       else if the packet is an APB write, perform the write transaction according to APB protocol
//       else if the packet is an APB read, perform the read transaction according to APB protocol
//         ** Note: - use the interface handle to access the signal
//               - for phase 1, we will not implement read transactions
//               - for write transactions, refer the waveforms in spi_v0.7.pdf, section 4.1
//       Create a response packet rsp_pkt
//       Send response packet by calling item_done(rsp_pkt)
class apb_driver #(type REQ = uvm_sequence_item, type RSP = uvm_sequence_item) extends uvm_driver #(REQ,RSP);

  `uvm_component_param_utils(apb_driver #(REQ,RSP))

  string   my_name;

  virtual interface clk_rst_if clk_rst_vif;
  virtual interface apb_if apb_vif;
  // spi_cfg spi_cfg_h;


  //
  // NEW
  //
  function new(string name, uvm_component parent);
     super.new(name,parent);
  endfunction
  
  //
  // CONNECT phase
  // Retrieve a handle to the apb_if and spi_cfg
  //
  virtual function void connect_phase(uvm_phase phase);
    uvm_object           tmp_obj_hdl;

    super.connect_phase(phase);
    my_name = get_name();
    //
    // Getting the interface handle via get_config_object call
    //
    if( !uvm_config_db #(virtual clk_rst_if)::get(this,"","CLK_RST_VIF",clk_rst_vif) ) begin
       `uvm_error(my_name, "Could not retrieve virtual clk_rst_if");
    end
    if( !uvm_config_db #(virtual apb_if)::get(this,"","APB_VIF",apb_vif) ) begin
       `uvm_error(my_name, "Could not retrieve virtual apb_if");
    end
    // //
    // // Getting the configuration object handle via get_config_object call
    // //
    // if( !uvm_config_db #(spi_cfg)::get(this,"","TB_CONFIG",spi_cfg_h) ) begin
    //    `uvm_error(my_name, "Could not retrieve spi_cfg");
    // end
  endfunction
  //
  // RUN phase
  // Retrieve a transaction packet and act on it:
  //
  virtual task run_phase(uvm_phase phase);
    forever @(posedge apb_vif.clk) begin  
      REQ req_pkt;
      RSP rsp_pkt;
      //
      // seq_item_port object is part of the uvm_driver class
      // get_next_item method is part of the interface api between uvm_driver and uvm_sequencer
      //
      seq_item_port.get_next_item(req_pkt);
      //
      // Check the type of packet and act on it
      //
      if (req_pkt.do_reset) begin
        clk_rst_vif.do_reset(5);
      end
      else if (req_pkt.do_wait) begin
        clk_rst_vif.do_wait(5);
      end
      else if (req_pkt.wr_rd == 1) begin 
        // APB write transaction
        apb_vif.PADDR <= req_pkt.addr[4:0]; 
        apb_vif.PWDATA <= req_pkt.wdata;    
        apb_vif.pwrite <= 1;
        apb_vif.psel   <= 1;
        apb_vif.penable<= 0;
        @(posedge apb_vif.clk); //wait for one cycle and done setup
        apb_vif.penable<= 1;
        @(posedge apb_vif.clk); 
        apb_vif.psel   <= 0;
        apb_vif.penable<= 0;
      end
      //
      // Create response packet and send it back to the sequencer
      //
      rsp_pkt = REQ::type_id::create("rsp_pkt")
      rsp_pkt.copy(req_pkt); // Good practice to copy request to response
      seq_item_port.item_done(rsp_pkt);
    end
  endtask

endclass
  
