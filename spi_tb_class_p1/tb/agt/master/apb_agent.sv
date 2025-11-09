//***************************************************************************************************************
// Author: Van Le
// vanleatwork@yahoo.com
// Phone: VN: 0396221156, US: 5125841843
//
//***************************************************************************************************************
class apb_agent #(type REQ = uvm_sequence_item, type RSP = uvm_sequence_item) extends uvm_agent;

   `uvm_component_param_utils(apb_agent #(REQ,RSP))
   
   // Declare sequencer and driver
   typedef uvm_sequencer #(REQ,RSP) sequencer_t;
   typedef apb_driver #(REQ,RSP) driver_t;

   sequencer_t   sequencer;
   driver_t       driver;
   

   //
   // NEW
   //
   function new(string name, uvm_component parent);
      super.new(name,parent);
   endfunction
   
   //
   // BUILD phase
   // Create sequencer and driver and ports
   //
   
   //
   // CONNECT phase
   // Connect sequencer and driver and driver ports
   //
   function void connect();
      driver.seq_item_port.connect(sequencer.seq_item_export);
   endfunction

endclass
