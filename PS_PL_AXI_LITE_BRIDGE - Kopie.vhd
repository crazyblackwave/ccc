
library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_ARITH.all;
use IEEE.STD_LOGIC_UNSIGNED.all;
library UNISIM;
use UNISIM.VComponents.all;
LIBRARY WORK;
USE WORK.MSBAD_DATA_TYPES.ALL;


entity PS_PL_AXI_LITE_BRIDGE is
	port 
	(
		CLK                         : IN  	STD_LOGIC;
		RST                         : IN  	STD_LOGIC;
		
        EXT_REG_IF_ADDR             : IN    STD_LOGIC_VECTOR(15 DOWNTO 0);
        EXT_REG_IF_WR_DATA          : IN    STD_LOGIC_VECTOR(31 DOWNTO 0);
        EXT_REG_IF_RD_DATA          : OUT   STD_LOGIC_VECTOR(31 DOWNTO 0);
        EXT_REG_IF_EN               : IN    STD_LOGIC;  
        EXT_REG_IF_WR_EN            : IN    STD_LOGIC_VECTOR(3 DOWNTO 0);
        
        ETH_CIT_REGISTERS           : OUT   STDLV_64_8;
        ETH_CIT_SET                 : OUT   STD_LOGIC;
        
        CTRL_REGS                   : OUT 	CONTROL_REGISTERS;
		STAT_REGS                   : IN  	STAT_REGISTERS
	);
end PS_PL_AXI_LITE_BRIDGE;

architecture Behavioral of PS_PL_AXI_LITE_BRIDGE is

    signal ext_interface_rx_buf_rden    : std_logic;
    signal ext_interface_rx_buf_rden_dl : std_logic;
    signal ext_interface_tx_buf_wren    : std_logic;
    signal ext_interface_tx_buf_wren_dl : std_logic;
        
    signal i_eth_error                  : std_logic_vector(31 downto 0);
    
    signal tester_tx_data_fifo_wr_en    : std_logic;
    signal tester_tx_data_fifo_wr_en_dl : std_logic;
    signal tester_tx_cfg_fifo_wr_en     : std_logic;
    signal tester_tx_cfg_fifo_wr_en_dl  : std_logic;
    
    signal tester_rx_data_fifo_rd_en    : std_logic;
    signal tester_rx_data_fifo_rd_en_dl : std_logic;
    signal tester_rx_cfg_fifo_rd_en     : std_logic;
    signal tester_rx_cfg_fifo_rd_en_dl  : std_logic;
    
    signal emu_fb_49_read_flag          : std_logic := '0';
    signal phy_error                    : std_logic_vector(7 downto 0);
    
    signal i_eth_reg_addr               : std_logic_vector(5 downto 0);
    
begin

	write_registers_p : process (clk)
	begin
		if rising_edge(clk) then

			ext_interface_tx_buf_wren <= '0';
            ext_interface_tx_buf_wren_dl <= ext_interface_tx_buf_wren;
            CTRL_REGS.ext_interface_tx_buf_wren <= ext_interface_tx_buf_wren and (not ext_interface_tx_buf_wren_dl);
            
            CTRL_REGS.eth_registers_wr_en <= '0';
            
            tester_tx_data_fifo_wr_en   <= '0';
            tester_tx_data_fifo_wr_en_dl<= tester_tx_data_fifo_wr_en;
            CTRL_REGS.tester_tx_data_fifo_wr_en <= tester_tx_data_fifo_wr_en and (not tester_tx_data_fifo_wr_en_dl);
			tester_tx_cfg_fifo_wr_en    <= '0';   
			tester_tx_cfg_fifo_wr_en_dl <= tester_tx_cfg_fifo_wr_en;
			CTRL_REGS.tester_tx_cfg_fifo_wr_en <= tester_tx_cfg_fifo_wr_en and (not tester_tx_cfg_fifo_wr_en_dl);
			
			ETH_CIT_SET <= '0';
			
			if (EXT_REG_IF_EN = '1' and EXT_REG_IF_WR_EN = "1111") then
				case EXT_REG_IF_ADDR(13 downto 2) is
					when x"000" => CTRL_REGS.user_gpio_out				<= EXT_REG_IF_WR_DATA(CTRL_REGS.user_gpio_out'range);
					-----------------------------------------------
					-- uart control
					-----------------------------------------------
					when x"001" => CTRL_REGS.ext_interface_clk_div_baud	<= EXT_REG_IF_WR_DATA;
					when x"002" => CTRL_REGS.ext_interface_tx_buf_data	<= EXT_REG_IF_WR_DATA(CTRL_REGS.ext_interface_tx_buf_data'range);
					               ext_interface_tx_buf_wren           	<= '1';
					-----------------------------------------------
                    -- ethernet control
                    -----------------------------------------------
					when x"003" => CTRL_REGS.eth_registers_wr_idx       <= EXT_REG_IF_WR_DATA(CTRL_REGS.eth_registers_wr_idx'range);
					when x"004" => CTRL_REGS.eth_registers_wr_data      <= EXT_REG_IF_WR_DATA(CTRL_REGS.eth_registers_wr_data'range);
					               CTRL_REGS.eth_registers_wr_en        <= '1';
					when x"005" => CTRL_REGS.eth_if_rx_fifo_rst         <= EXT_REG_IF_WR_DATA(0);               
					when x"006" => CTRL_REGS.eth_if_tx_fifo_rst         <= EXT_REG_IF_WR_DATA(0);               
					when x"007" => CTRL_REGS.eth_mac_speed              <= EXT_REG_IF_WR_DATA(CTRL_REGS.eth_mac_speed'range);               
					when x"008" => CTRL_REGS.eth_if_rst                 <= EXT_REG_IF_WR_DATA(0);  
					
                    -----------------------------------------------
                    -- eth tester
                    -----------------------------------------------
                    when x"009" => CTRL_REGS.tester_tx_data_fifo_wr_data <= EXT_REG_IF_WR_DATA(CTRL_REGS.tester_tx_data_fifo_wr_data'range);
                                   tester_tx_data_fifo_wr_en   <= '1';
                    when x"00A" => CTRL_REGS.tester_tx_cfg_fifo_wr_data  <= EXT_REG_IF_WR_DATA(CTRL_REGS.tester_tx_cfg_fifo_wr_data'range);
                                   tester_tx_cfg_fifo_wr_en    <= '1';   
                    when x"00B" => CTRL_REGS.eth_tester_enable           <= EXT_REG_IF_WR_DATA(0);                
                    
                    -----------------------------------------------
                    -- emu control
                    -----------------------------------------------
                    when x"00C" => CTRL_REGS.phy_bus_mux_ctrl            <= EXT_REG_IF_WR_DATA(0);
                    when x"00D" => CTRL_REGS.emu_e_wait_counter          <= EXT_REG_IF_WR_DATA(CTRL_REGS.emu_e_wait_counter'range); 
                    when x"00E" => CTRL_REGS.emu_packet_wait_counter     <= EXT_REG_IF_WR_DATA(CTRL_REGS.emu_packet_wait_counter'range); 
                    
                    -----------------------------------------------
                    -- phy control
                    -----------------------------------------------
                    when x"00F" => CTRL_REGS.phy_if_wait_in              <= EXT_REG_IF_WR_DATA(CTRL_REGS.phy_if_wait_in'range);
                    when x"010" => CTRL_REGS.phy_if_debounce             <= EXT_REG_IF_WR_DATA(CTRL_REGS.phy_if_debounce'range);
                    
                    when x"011" => CTRL_REGS.phy_if_r_timeout            <= EXT_REG_IF_WR_DATA(CTRL_REGS.phy_if_r_timeout'range);
                    when x"012" => CTRL_REGS.phy_if_e_response_timeout   <= EXT_REG_IF_WR_DATA(CTRL_REGS.phy_if_e_response_timeout'range);
                    when x"013" => CTRL_REGS.phy_if_e_request_timeout    <= EXT_REG_IF_WR_DATA(CTRL_REGS.phy_if_e_request_timeout'range);
                    when x"014" => CTRL_REGS.phy_if_compensation_count   <= EXT_REG_IF_WR_DATA(CTRL_REGS.phy_if_compensation_count'range);
                    when x"015" => CTRL_REGS.phy_if_data_out_select      <= EXT_REG_IF_WR_DATA(0);
                    
                    when x"016" => CTRL_REGS.phy_if_packet_enable(255 downto 224)       <= EXT_REG_IF_WR_DATA(31 downto 0);
                    when x"017" => CTRL_REGS.phy_if_packet_enable(223 downto 192)       <= EXT_REG_IF_WR_DATA(31 downto 0);
                    when x"018" => CTRL_REGS.phy_if_packet_enable(191 downto 160)       <= EXT_REG_IF_WR_DATA(31 downto 0);
                    when x"019" => CTRL_REGS.phy_if_packet_enable(159 downto 128)       <= EXT_REG_IF_WR_DATA(31 downto 0);
                    when x"01A" => CTRL_REGS.phy_if_packet_enable(127 downto 96)        <= EXT_REG_IF_WR_DATA(31 downto 0);
                    when x"01B" => CTRL_REGS.phy_if_packet_enable(95 downto 64)         <= EXT_REG_IF_WR_DATA(31 downto 0);
                    when x"01C" => CTRL_REGS.phy_if_packet_enable(63 downto 32)         <= EXT_REG_IF_WR_DATA(31 downto 0);
                    when x"01D" => CTRL_REGS.phy_if_packet_enable(31 downto 0)          <= EXT_REG_IF_WR_DATA(31 downto 0);
                    
--                    when x"016" => CTRL_REGS.phy_if_packet_enable        <= EXT_REG_IF_WR_DATA(CTRL_REGS.phy_if_packet_enable(255 downto 224)'range);
--                    when x"017" => CTRL_REGS.phy_if_packet_enable        <= EXT_REG_IF_WR_DATA(CTRL_REGS.phy_if_packet_enable(223 downto 192)'range);
--                    when x"018" => CTRL_REGS.phy_if_packet_enable        <= EXT_REG_IF_WR_DATA(CTRL_REGS.phy_if_packet_enable(191 downto 160)'range);
--                    when x"019" => CTRL_REGS.phy_if_packet_enable        <= EXT_REG_IF_WR_DATA(CTRL_REGS.phy_if_packet_enable(159 downto 128)'range);
--                    when x"020" => CTRL_REGS.phy_if_packet_enable        <= EXT_REG_IF_WR_DATA(CTRL_REGS.phy_if_packet_enable(127 downto 96)'range) ;
--                    when x"021" => CTRL_REGS.phy_if_packet_enable        <= EXT_REG_IF_WR_DATA(CTRL_REGS.phy_if_packet_enable(95 downto 64)'range);
--                    when x"022" => CTRL_REGS.phy_if_packet_enable        <= EXT_REG_IF_WR_DATA(CTRL_REGS.phy_if_packet_enable(63 downto 32)'range);
--                    when x"023" => CTRL_REGS.phy_if_packet_enable        <= EXT_REG_IF_WR_DATA(CTRL_REGS.phy_if_packet_enable(31 downto 0)'range);
                    when x"200" => i_eth_reg_addr <= EXT_REG_IF_WR_DATA(i_eth_reg_addr'range);
                    when x"201" => ETH_CIT_REGISTERS(conv_integer(i_eth_reg_addr+0)) <= EXT_REG_IF_WR_DATA(07 downto 00);
                                   ETH_CIT_REGISTERS(conv_integer(i_eth_reg_addr+1)) <= EXT_REG_IF_WR_DATA(15 downto 08);
                                   ETH_CIT_REGISTERS(conv_integer(i_eth_reg_addr+2)) <= EXT_REG_IF_WR_DATA(23 downto 16);
                                   ETH_CIT_REGISTERS(conv_integer(i_eth_reg_addr+3)) <= EXT_REG_IF_WR_DATA(31 downto 24);
                    when x"202" => ETH_CIT_SET <= '1';

					when others => null;

				end case;
			end if;
		end if;
	end process;

	read_registers_p : process (clk)
	begin
		if rising_edge(clk) then

            ext_interface_rx_buf_rden               <= '0';
            ext_interface_rx_buf_rden_dl            <= ext_interface_rx_buf_rden;
            CTRL_REGS.ext_interface_rx_buf_rden <= ext_interface_rx_buf_rden and (not ext_interface_rx_buf_rden_dl);
            
            for i in STAT_REGS.eth_error'length-1 downto 0 loop
                if(STAT_REGS.eth_error(i)='1') then
                    i_eth_error(i) <= '1';
                end if;
            end loop;
            
            for i in STAT_REGS.phy_if_phy_error'length-1 downto 0 loop
                if(STAT_REGS.phy_if_phy_error(i)='1') then
                    phy_error(i) <= '1';
                end if;
            end loop;
            
            tester_rx_data_fifo_rd_en <= '0';
            tester_rx_data_fifo_rd_en_dl <= tester_rx_data_fifo_rd_en;
            CTRL_REGS.tester_rx_data_fifo_rd_en <= tester_rx_data_fifo_rd_en and (not tester_rx_data_fifo_rd_en_dl);
            tester_rx_cfg_fifo_rd_en <= '0';
            tester_rx_cfg_fifo_rd_en_dl <= tester_rx_cfg_fifo_rd_en;
            CTRL_REGS.tester_rx_cfg_fifo_rd_en  <= tester_rx_cfg_fifo_rd_en and (not tester_rx_cfg_fifo_rd_en_dl);    

			if (EXT_REG_IF_EN = '1' and EXT_REG_IF_WR_EN = "0000") then
				EXT_REG_IF_RD_DATA <= (others => '0');
				case EXT_REG_IF_ADDR(13 downto 2) is
					when x"800" => EXT_REG_IF_RD_DATA	 			<= STAT_REGS.board_status;
					-----------------------------------------------
					-- uart control
					-----------------------------------------------
					when x"801" => EXT_REG_IF_RD_DATA(0) 			<= STAT_REGS.ext_interface_rx_buf_empty;
					when x"802" => EXT_REG_IF_RD_DATA(STAT_REGS.ext_interface_rx_buf_data'range) <= STAT_REGS.ext_interface_rx_buf_data;
                                   ext_interface_rx_buf_rden        <= '1';
					when x"803" => EXT_REG_IF_RD_DATA(0)            <= STAT_REGS.ext_interface_tx_buf_full;
					-----------------------------------------------
                    -- ethernet control
                    -----------------------------------------------
					when x"804" => EXT_REG_IF_RD_DATA               <= i_eth_error;
					               i_eth_error                      <= (others=>'0');
                    -----------------------------------------------
                    -- ddr debug
                    -----------------------------------------------   
                    when x"805" => EXT_REG_IF_RD_DATA(STAT_REGS.ddr_report_word_count'range) <= STAT_REGS.ddr_report_word_count;
                    when x"806" => EXT_REG_IF_RD_DATA(STAT_REGS.ddr_report_error_count'range) <= STAT_REGS.ddr_report_error_count;     
                    when x"807" => EXT_REG_IF_RD_DATA(0)            <= STAT_REGS.init_calib_complete; 
                         
                    -----------------------------------------------
                    -- eth tester
                    -----------------------------------------------
                    when x"808" => EXT_REG_IF_RD_DATA(STAT_REGS.tester_rx_data_fifo_rd_data'range) <= STAT_REGS.tester_rx_data_fifo_rd_data;
                                   tester_rx_data_fifo_rd_en <= '1';
                    when x"809" => EXT_REG_IF_RD_DATA(STAT_REGS.tester_rx_cfg_fifo_rd_data'range)  <= STAT_REGS.tester_rx_cfg_fifo_rd_data;
                                   tester_rx_cfg_fifo_rd_en  <= '1';
                    when x"80A" => EXT_REG_IF_RD_DATA(0)    <= STAT_REGS.tester_rx_data_fifo_empty;
                                   EXT_REG_IF_RD_DATA(1)    <= STAT_REGS.tester_rx_cfg_fifo_empty;
                                   EXT_REG_IF_RD_DATA(2)    <= STAT_REGS.tester_tx_data_fifo_full;
                                   EXT_REG_IF_RD_DATA(3)    <= STAT_REGS.tester_tx_cfg_fifo_full;     
                      
                    -----------------------------------------------
                    -- phy control
                    -----------------------------------------------      
                    when x"80B" => EXT_REG_IF_RD_DATA(STAT_REGS.phy_if_data_bus_out'range) <= STAT_REGS.phy_if_data_bus_out;    
                    
--                    when x"80C" => EXT_REG_IF_RD_DATA(BUFF_REG_IN.data(0)'range) <= BUFF_REG_IN.data(0);
--                    when x"80D" => EXT_REG_IF_RD_DATA(BUFF_REG_IN.data(1)'range) <= BUFF_REG_IN.data(1);
--                    when x"80E" => EXT_REG_IF_RD_DATA(BUFF_REG_IN.data(2)'range) <= BUFF_REG_IN.data(2);
--                    when x"80F" => EXT_REG_IF_RD_DATA(BUFF_REG_IN.data(3)'range) <= BUFF_REG_IN.data(3);
--                    when x"810" => EXT_REG_IF_RD_DATA(BUFF_REG_IN.data(4)'range) <= BUFF_REG_IN.data(4);
                    
                    when x"811" => EXT_REG_IF_RD_DATA(0) <= emu_fb_49_read_flag;   
                                   emu_fb_49_read_flag <= '0';   
                                   
                    when x"812" => EXT_REG_IF_RD_DATA(STAT_REGS.phy_if_phy_error'range) <= phy_error;
                                   phy_error <= (others=>'0');
                                   
                    when x"813" => EXT_REG_IF_RD_DATA(STAT_REGS.phy_if_abone_no'range) <= STAT_REGS.phy_if_abone_no;
                    
                    when x"814" => EXT_REG_IF_RD_DATA(STAT_REGS.phy_if_e_response_time'range) <= STAT_REGS.phy_if_e_response_time;
                                                                                                   
					when others => null;

				end case;
			end if;
			
			if(STAT_REGS.emu_fb_49_newdata_flag = '1') then
                emu_fb_49_read_flag <= '1';
            end if; 
            
		end if;
	end process;

end Behavioral;