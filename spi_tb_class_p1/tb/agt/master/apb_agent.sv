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
   
   //declare a ref port name
   uvm_analysis_port #(spi_tlm) ref_ob_ap;


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
   function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      sequencer = sequencer_t::type_id::create("sequencer", this);
      driver    = driver_t::type_id::create("driver", this);
   endfunction
   
   //
   // CONNECT phase
   // Connect sequencer and driver and driver ports
   //
   function void connect_phase(uvm_phase phase);
      super.connect_phase(phase);
      driver.seq_item_port.connect(sequencer.seq_item_export);
      //connect the analysis port of the agent to the analysis port of the driver
      driver.ref_ob_ap.connect( ref_ob_ap );
   endfunction

endclass
