//***************************************************************************************************************
// Author: Van Le
// vanleatwork@yahoo.com
// Phone: VN: 0396221156, US: 5125841843
//***************************************************************************************************************
class spi_slave_monitor #(type PKT = uvm_sequence_item) extends uvm_monitor;

  `uvm_component_param_utils(spi_slave_monitor #(PKT))
   uvm_analysis_port #(spi_tlm) act_ob_ap;

  //declare virtual interface handle
  virtual interface clk_rst_if clk_rst_slave_vif;
  virtual interface spi_if spi_slave_vif;
  spi_cfg spi_cfg_h;
  //
  // NEW
  //
  function new(string name, uvm_component parent);
    super.new(name,parent);
    act_ob_ap = new("act_ob_ap", this); //create a instance of analysis port
  endfunction

  //
  // CONNECT phase
  //
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    if(!uvm_config_db #(clk_rst_if)::get(this, "", "CLK_RST_VIF", clk_rst_slave_if))
      `uvm_fatal(get_type_name(), "Cannot get clk_rst_if");
    if(!uvm_config_db #(spi_if)::get(this, "", "SPI_SLAVE_VIF", spi_slave_vif))
      'uvm_fatal(get_type_name(), "Cannot get spi_if");
    if(!uvm_config_db #(spi_cfg)::get(this, "", "TB_CONFIG", spi_cfg_h))
      `uvm_fatal(get_type_name(), "Cannot get spi_cfg");
  endfunction
  //
  // RUN phase
  //
  function void run_phase(uvm_phase phase);
    PKT spi_pkt;
    bit [127:0] temp_mosi;
    int i;

    forever begin
      //wait for selecting the slave 0
      wait (ss_pad_o[0] == 0);
      // reset temp_mosi
      temp_mosi = 128'b0;

      // loop to take the data
      for(i = 0; i < spi_cfg_h.char_len ; i++) begin
        if (spi_cfg_h.txneg)  //the loop logic below is the same, but its timing is diff
          @(negedge spi_slave_vif.clk)
        end
        else begin
          @(posedge spi_slave_vif.clk)
        end

        if(spi_cfg_h.lsb) begin
          temp_mosi <= spi_slave_vif.mosi_pad_o;
          end
        else begin
          temp_mosi[char_len - i] <= spi_slave_vif.mosi_pad_o;
          end
      end

    assign spi_pkt.mosi = temp_mosi;
    act_ob_ap.write(spi_pkt);

    //wait for the transaction to end
    wait(ss_pad_o[0] = 1);

    end
  endfunction
endclass
