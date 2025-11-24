//***************************************************************************************************************
// Author: Van Le
// vanleatwork@yahoo.com
// Phone: VN: 0396221156, US: 5125841843
//***************************************************************************************************************
class sb #(type REQ = uvm_sequence_item) extends uvm_scoreboard;
	`uvm_component_param_utils(sb #(REQ))
	// tell UVM to create the ports definitions (type)
    `uvm_component_imp_decl(_ref_ob_imp)
    `uvm_component_imp_decl(_ac_ob_imp)
    //declare the port using the these new classes
    uvm_analysis_imp_ref_ob_imp #(spi_tlm, sb) ref_ob_imp;
    uvm_analysis_imp_ac_ob_imp #(spi_tlm, sb) ac_ob_imp;

    //declare reference package
    REG ref_ob_pkt
    //a counter of transactions (max 4)
    int cnt = 0;


  //
  // NEW
  //
  function new(string name, uvm_component parent);
    super.new(name,parent);
    ref_ob_pkt = REG::create("ref_ob_pkt", this);
    ref_ob_imp = new("ref_ob_imp", this);
    ac_ob_imp = new("ab_ob_imp", this)
  endfunction
		
  function void write_ref_ob_imp(REG pkt); //the controller has 4Tx regs that can be written
    if (cnt == 0)
      ref_ob_pkt.mosi[31:0] = pkt.wdata;
    else if(cnt == 1)
      ref_ob_pkt.mosi[63:32] = pkt.wdata;
    else if (cnt == 2)
      ref_ob_pkt.mosi[95:64] = pkt.wdata;
    else
      ref_ob_pkt.mosi[127:96] = pkt.wdata;

    if (cnt == 3)
      cnt = 0;
    else
      cnt++;
  endfunction

  function void write_act_ob_imp(REQ act_ob_pkt) //called auctomatically when the act pkt arrived
    if (act_ob_pkt.mosi ==  ref_ob_pkt.mosi) //compare the data
      `uvm_info(get_type_name(), $sformatf ("Data matched: %0h", act_ob_pkt.mosi), UVM_NONE);
    else
      `uvm_error(get_type_name(), $sformatf ("Data unmachted, Expected: %0h, Got: %0h,", ref_ob_pkt, act_ob_pkt), UVM_NONE);
  endfunction

  //
  // BUILD phase
  //

  //
  // CONNECT phase
  //

  //
  //
  // RUN phase
  //

endclass
