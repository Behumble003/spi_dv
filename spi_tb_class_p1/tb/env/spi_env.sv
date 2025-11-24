//***************************************************************************************************************
// Author: Van Le
// vanleatwork@yahoo.com
// Phone: VN: 0396221156, US: 5125841843
//***************************************************************************************************************
class spi_env #(type REQ = uvm_sequence_item, type RSP = uvm_sequence_item) extends uvm_env;

   `uvm_component_param_utils(spi_env #(REQ,RSP))
   typedef spi_slave_agent #(spi_tlm, spi_tlm) spi_slave_agent_t;
   spi_slave_agent_t spi_slave_agent_h;
   typedef sb #(spi_tlm) sb_t;
   sb_t sb_h;
   
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
      spi_slave_agent_h = spi_slave_agent_t::type_id::create("spi_slave_agent_h", this);
      sb_h = sb_t::type_id::create("sb_h", this);
   endfunction

   //connect phase
   function void connect_phase(uvm_phase phase);
      apb_agent_h.ref_ob_ap.connect(sb_h.ref_ob_imp);
      spi_slave_agent_h.act_ob_ap.connect(sb.act_ob_imp);
   endfunction
endclass
