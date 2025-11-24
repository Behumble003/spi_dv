//***************************************************************************************************************
// Author: Van Le
// vanleatwork@yahoo.com
// Phone: VN: 0396221156, US: 5125841843
//
//***************************************************************************************************************
class spi_slave_agent #(type REQ = uvm_sequence_item, type RSP = uvm_sequence_item) extends uvm_agent;

   `uvm_component_param_utils

   uvm_analysis_port #(spi_tlm) act_ob_ap;
   typedef spi_slave_monitor #(spi_tlm) spi_slave_monitor_t;
   spi_slave_monitor_t spi_slave_monitor_h;

   //
   // NEW
   //
   function new(string name, uvm_component parent);
      super.new(name,parent);
      act_ob_ap = new("act_ob_ap", this); //use new() here because we it's fixed we dont want UVM factory to override it
   endfunction
   
   //
   // BUILD phase
   //
   function void build_phase(uvm_phase phase);
      super.new(phase);
      spi_slave_monitor_h = spi_slave_monitor_t::create("slave_monitor", this); //create allow the UVM factory to change it
   endfunction                                                                   //create used for object
   //
   // CONNECT phase
   //
   function void connect_phase(uvm_phase phase);
      super.new(phase);
      spi_slave_monitor_h.act_ob_ap.connect(act_ob_ap); //it connects to the spi_slave_agent.act_ob_ap
endclass
