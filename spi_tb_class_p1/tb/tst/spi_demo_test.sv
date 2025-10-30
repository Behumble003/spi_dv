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
  // RUN phase
  //
	task run_phase(uvm_phase phase);

    phase.raise_objection(this,"Objection raised by spi_demo_test");
    
    phase.drop_objection(this,"Objection dropped by spi_demo_test");
	endtask
	
endclass
   
