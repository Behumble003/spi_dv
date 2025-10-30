//***************************************************************************************************************
// Author: Van Le
// vanleatwork@yahoo.com
// Phone: VN: 0396221156, US: 5125841843
//***************************************************************************************************************
class sb #(type REQ = uvm_sequence_item) extends uvm_scoreboard;

	`uvm_component_param_utils(sb #(REQ))
  
  //
  // NEW
  //
  function new(string name, uvm_component parent);
    super.new(name,parent);
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
