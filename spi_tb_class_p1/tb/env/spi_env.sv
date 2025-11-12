//***************************************************************************************************************
// Author: Van Le
// vanleatwork@yahoo.com
// Phone: VN: 0396221156, US: 5125841843
//***************************************************************************************************************
class spi_env #(type REQ = uvm_sequence_item, type RSP = uvm_sequence_item) extends uvm_env;

   `uvm_component_param_utils(spi_env #(REQ,RSP))
   
   typedef apb_agent #(REQ,RSP)        apb_agent_t;
   apb_agent_t      apb_agent_h;
   //
   // NEW
   //
   function new(string name, uvm_component parent);
      super.new(name,parent);
   endfunction
   
   //
   // BUILD phase
   // 
   function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      apb_agent_h = apb_agent_t::type_id::create("apb_agent_h", this);
   endfunction
endclass
