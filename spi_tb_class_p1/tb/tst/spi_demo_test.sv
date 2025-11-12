//***************************************************************************************************************
// Author: Van Le
// vanleatwork@yahoo.com
// Phone: VN: 0396221156, US: 5125841843
//***************************************************************************************************************
//***************************************************************************************************************
// A demo test case.
//***************************************************************************************************************
class spi_demo_test extends uvm_test;

	`uvm_component_utils(spi_demo_test)
  
  typedef spi_env #(spi_tlm, spi_tlm)   spi_env_t;
  spi_env_t       spi_env_h;

	spi_cfg         spi_cfg_h;
  apb_demo_seq#(spi_tlm, spi_tlm) apb_demo_seq_h;
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
    spi_env_h = spi_env_t::type_id::create("spi_env_h", this);

    // Create and set the spi_cfg configuration object
    spi_cfg_h = spi_cfg::type_id::create("spi_cfg_h", this);

    
    // Set the configuration object in the uvm_config_db
    uvm_config_db #(spi_cfg)::set(this, "spi_env_h.apb_agent_h.sequencer", "TB_CONFIG", spi_cfg_h);

    apb_demo_seq_h = apb_demo_seq#(spi_tlm, spi_tlm)::type_id::create("apb_demo_seq_h", this);
  endfunction
  //
  // RUN phase
  //
	task run_phase(uvm_phase phase);

    phase.raise_objection(this,"Objection raised by spi_demo_test");
    apb_demo_seq_h.start(spi_env_h.apb_agent_h.sequencer);
    phase.drop_objection(this,"Objection dropped by spi_demo_test");
	endtask
	
endclass
   
