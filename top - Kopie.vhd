
library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_ARITH.all;
use IEEE.STD_LOGIC_UNSIGNED.all;
library UNISIM;
use UNISIM.VComponents.all;
LIBRARY WORK;
USE WORK.MSBAD_DATA_TYPES.ALL;

entity MSBAD is
	port 
	(
		--==============================================================--
		--                       CLOCK & RESET                    		--
		--==============================================================--
		CLK_IN       	: IN 	STD_LOGIC;
		RESETN       	: IN 	STD_LOGIC;

		--==============================================================--
		--                           I2C                           		--
		--==============================================================--
		I2C_SDA      	: INOUT STD_LOGIC;
		I2C_SCL      	: INOUT STD_LOGIC;
		EEPROM_WP    	: OUT 	STD_LOGIC;

		--==============================================================--
		--                           UART                          		--
		--==============================================================--
		RS422_RX     	: IN 	STD_LOGIC;
		RS422_TX     	: OUT 	STD_LOGIC;

		--==============================================================--
		--                      USER GPIO & LEDS                   		--
		--==============================================================--
		USER_GPIO    	: OUT 	STD_LOGIC_VECTOR(3 DOWNTO 0);
		USER_LEDS    	: OUT 	STD_LOGIC_VECTOR(3 DOWNTO 0);
--		ABONE_MODE_SW   : IN    STD_LOGIC;

		--==============================================================--
		--                 		 PHY INTERFACE                      	--
		--==============================================================--		
		ABONE_D556   	: IN 	STD_LOGIC_VECTOR(4 DOWNTO 0);
        ADDRESS_D556 	: IN 	STD_LOGIC_VECTOR(11 DOWNTO 0);
        FIELD_D556   	: IN 	STD_LOGIC_VECTOR(7 DOWNTO 0);
        DATA_D556    	: INOUT STD_LOGIC_VECTOR(7 DOWNTO 0);
        VB_D556      	: IN 	STD_LOGIC;
        ABS_D556     	: IN 	STD_LOGIC;
        E_D556       	: IN 	STD_LOGIC;
        R_D556       	: IN 	STD_LOGIC;
        F_D556       	: IN 	STD_LOGIC;  
        ED_D556      	: IN 	STD_LOGIC;
        RD_D556      	: IN 	STD_LOGIC;   
        RC_D556      	: IN 	STD_LOGIC;
        DE_D556      	: IN 	STD_LOGIC;  
        DP_D556      	: OUT 	STD_LOGIC;
        QH_D556      	: OUT 	STD_LOGIC;
        QC_D556      	: OUT 	STD_LOGIC;      
        
--        ADDRESS_MAIN     : OUT     STD_LOGIC_VECTOR(11 DOWNTO 0);
--        FIELD_MAIN       : OUT     STD_LOGIC_VECTOR(7 DOWNTO 0);
--        VB_MAIN          : OUT     STD_LOGIC;
--        ABS_MAIN         : OUT     STD_LOGIC;
--        E_MAIN           : OUT     STD_LOGIC;
--        R_MAIN           : OUT     STD_LOGIC;
--        F_MAIN           : OUT     STD_LOGIC;  
--        ED_MAIN          : OUT     STD_LOGIC;
--        RD_MAIN          : OUT     STD_LOGIC;   
--        RC_MAIN          : OUT     STD_LOGIC;
--        DE_MAIN          : OUT     STD_LOGIC;               				
		--==============================================================--
		--                        	DDR3                           		--
		--==============================================================--
		DDR3_SYS_CLK 	: IN 	STD_LOGIC;
		DDR3_ADDR    	: OUT 	STD_LOGIC_VECTOR (14 DOWNTO 0);
		DDR3_BA      	: OUT 	STD_LOGIC_VECTOR (2 DOWNTO 0);
		DDR3_CAS_N   	: OUT 	STD_LOGIC;
		DDR3_CK_N    	: OUT 	STD_LOGIC_VECTOR (0 TO 0);
		DDR3_CK_P    	: OUT 	STD_LOGIC_VECTOR (0 TO 0);
		DDR3_CKE     	: OUT 	STD_LOGIC_VECTOR (0 TO 0);
		DDR3_CS_N    	: OUT 	STD_LOGIC_VECTOR (0 TO 0);
		DDR3_DM      	: OUT 	STD_LOGIC_VECTOR (0 TO 0);
		DDR3_DQ      	: INOUT STD_LOGIC_VECTOR (7 DOWNTO 0);
		DDR3_DQS_N   	: INOUT STD_LOGIC_VECTOR (0 TO 0);
		DDR3_DQS_P   	: INOUT STD_LOGIC_VECTOR (0 TO 0);
		DDR3_ODT     	: OUT 	STD_LOGIC_VECTOR (0 TO 0);
		DDR3_RAS_N   	: OUT 	STD_LOGIC;
		DDR3_RESET_N 	: OUT 	STD_LOGIC;
		DDR3_WE_N    	: OUT 	STD_LOGIC;

		--==============================================================--
		--                        ETHERNET                         		--
		--==============================================================--
		RGMII_TXD    	: OUT 	STD_LOGIC_VECTOR(3 DOWNTO 0);
		RGMII_TX_CTL 	: OUT 	STD_LOGIC;
		RGMII_TXC    	: OUT 	STD_LOGIC;
		RGMII_RXD    	: IN 	STD_LOGIC_VECTOR(3 DOWNTO 0);
		RGMII_RX_CTL 	: IN 	STD_LOGIC;
		RGMII_RXC    	: IN 	STD_LOGIC;
		ETH_RESETN   	: OUT 	STD_LOGIC;
		ETH_MD_IO    	: INOUT STD_LOGIC;
		ETH_MD_MDC   	: OUT 	STD_LOGIC;

		--==============================================================--
		--                       QSPI FLASH                       		--
		--==============================================================--
		FLASH_CS_N   	: INOUT STD_LOGIC_VECTOR (0 TO 0);
		FLASH_D0     	: INOUT STD_LOGIC;
		FLASH_D1     	: INOUT STD_LOGIC;
		FLASH_D2     	: INOUT STD_LOGIC;
		FLASH_D3     	: INOUT STD_LOGIC

	);
end MSBAD;

architecture Behavioral of MSBAD is

    component mig_7series_0
		port (
			ddr3_dq             : inout std_logic_vector(7 downto 0);
			ddr3_dqs_p          : inout std_logic_vector(0 downto 0);
			ddr3_dqs_n          : inout std_logic_vector(0 downto 0);

			ddr3_addr           : out std_logic_vector(14 downto 0);
			ddr3_ba             : out std_logic_vector(2 downto 0);
			ddr3_ras_n          : out std_logic;
			ddr3_cas_n          : out std_logic;
			ddr3_we_n           : out std_logic;
			ddr3_reset_n        : out std_logic;
			ddr3_ck_p           : out std_logic_vector(0 downto 0);
			ddr3_ck_n           : out std_logic_vector(0 downto 0);
			ddr3_cke            : out std_logic_vector(0 downto 0);
			ddr3_cs_n           : out std_logic_vector(0 downto 0);
			ddr3_dm             : out std_logic_vector(0 downto 0);
			ddr3_odt            : out std_logic_vector(0 downto 0);
			app_addr            : in std_logic_vector(28 downto 0);
			app_cmd             : in std_logic_vector(2 downto 0);
			app_en              : in std_logic;
			app_wdf_data        : in std_logic_vector(63 downto 0);
			app_wdf_end         : in std_logic;
			app_wdf_mask        : in std_logic_vector(7 downto 0);
			app_wdf_wren        : in std_logic;
			app_rd_data         : out std_logic_vector(63 downto 0);
			app_rd_data_end     : out std_logic;
			app_rd_data_valid   : out std_logic;
			app_rdy             : out std_logic;
			app_wdf_rdy         : out std_logic;
			app_sr_req          : in std_logic;
			app_ref_req         : in std_logic;
			app_zq_req          : in std_logic;
			app_sr_active       : out std_logic;
			app_ref_ack         : out std_logic;
			app_zq_ack          : out std_logic;
			ui_clk              : out std_logic;
			ui_clk_sync_rst     : out std_logic;
			init_calib_complete : out std_logic;
			-- System Clock Ports
			sys_clk_i           : in std_logic;
			device_temp_o       : out std_logic_vector(11 downto 0);
			sys_rst             : in std_logic
		);
	end component mig_7series_0;
	
	component clk_wiz_0
		port 
		(
			clk_in1   : in std_logic;
			reset     : in std_logic;
			
			locked    : out std_logic;
			
			clk100    : out std_logic;
			clk125    : out std_logic;
			clk125_90 : out std_logic;
			clk200    : out std_logic
		);
	end component;
	
    --==============================================================--
    --                         CLOCK & RESET                        --
    --==============================================================--
    signal clk100                      : std_logic;
    signal clk125                      : std_logic;
    signal clk125_90                   : std_logic;
    signal clk200                      : std_logic;
    signal clk_locked                  : std_logic;
    signal clock_gen_rst               : std_logic;
    signal i_rst                       : std_logic := '1';
    signal rst_cntr                    : std_logic_vector(31 downto 0);
    signal clk_alive_cntr              : std_logic_vector(31 downto 0);
    signal cpu_interrupt               : std_logic_vector(0 downto 0);
    signal eth_if_rst                  : std_logic;

--==============================================================--
    --                           EMU - PHY MUX INTERFACE            --
    --==============================================================--	
    signal emu_ABONE_D556   	: STD_LOGIC_VECTOR(4 DOWNTO 0);
    signal emu_ADDRESS_D556 	: STD_LOGIC_VECTOR(11 DOWNTO 0);
    signal emu_FIELD_D556   	: STD_LOGIC_VECTOR(7 DOWNTO 0);
    signal emu_DATA_D556_IN    	: STD_LOGIC_VECTOR(7 DOWNTO 0);
    signal emu_DATA_D556_OUT    : STD_LOGIC_VECTOR(7 DOWNTO 0);
    signal emu_VB_D556      	: STD_LOGIC;
    signal emu_ABS_D556     	: STD_LOGIC;
    signal emu_E_D556       	: STD_LOGIC;
    signal emu_R_D556       	: STD_LOGIC;
    signal emu_F_D556       	: STD_LOGIC;  
    signal emu_ED_D556      	: STD_LOGIC;
    signal emu_RD_D556      	: STD_LOGIC;   
    signal emu_RC_D556      	: STD_LOGIC;
    signal emu_DE_D556      	: STD_LOGIC;  
    signal emu_DP_D556      	: STD_LOGIC;
    signal emu_QH_D556      	: STD_LOGIC := '0';
    signal emu_QC_D556      	: STD_LOGIC := '0';
    
    signal phy_if_abone_switch  : std_logic_vector(7 downto 0);
    signal iobuf_t_ctrl         : std_logic;
	
    --==============================================================--
    --                           MUX - PHY INTERFACE                --
    --==============================================================--    
    
    signal phy_ABONE_D556   	: STD_LOGIC_VECTOR(4 DOWNTO 0);
    signal phy_ADDRESS_D556     : STD_LOGIC_VECTOR(11 DOWNTO 0);
    signal phy_FIELD_D556       : STD_LOGIC_VECTOR(7 DOWNTO 0);
    signal phy_DATA_D556_IN     : STD_LOGIC_VECTOR(7 DOWNTO 0);
    signal phy_DATA_D556_OUT    : STD_LOGIC_VECTOR(7 DOWNTO 0);
    signal phy_VB_D556          : STD_LOGIC;
    signal phy_ABS_D556         : STD_LOGIC;
    signal phy_E_D556           : STD_LOGIC;
    signal phy_R_D556           : STD_LOGIC;
    signal phy_F_D556           : STD_LOGIC;  
    signal phy_ED_D556          : STD_LOGIC;
    signal phy_RD_D556          : STD_LOGIC;   
    signal phy_RC_D556          : STD_LOGIC;
    signal phy_DE_D556          : STD_LOGIC;  
    signal phy_DP_D556          : STD_LOGIC;
    signal phy_QH_D556          : STD_LOGIC;
    signal phy_QC_D556          : STD_LOGIC;
    
    --==============================================================--
    --                           IOBUF INTERFACE                    --
    --==============================================================--    
        
    signal iobuf_DATA_D556_IN     : STD_LOGIC_VECTOR(7 DOWNTO 0);
    signal iobuf_DATA_D556_OUT    : STD_LOGIC_VECTOR(7 DOWNTO 0);
	
    --==============================================================--
    --                           REGISTER IF                        --
    --==============================================================--
    signal reg_if_addr                 : std_logic_vector(15 downto 0);
    signal reg_if_wr_data              : std_logic_vector(31 downto 0);
    signal reg_if_rd_data              : std_logic_vector(31 downto 0);
    signal reg_if_clk                  : std_logic;
    signal reg_if_en                   : std_logic;
    signal reg_if_wr_en                : std_logic_vector(3 downto 0);
    signal CTRL_REGS                   : CONTROL_REGISTERS;
    signal STAT_REGS                   : STAT_REGISTERS;

	--==============================================================--
	--                             ETHERNET                         --
	--==============================================================--
    signal eth_if_tx_s_axi_tready       : std_logic;
    signal eth_if_tx_s_axi_tvalid       : std_logic; 
    signal eth_if_tx_s_axi_tlast        : std_logic; 
    signal eth_if_tx_s_axi_tdata        : std_logic_vector(7 downto 0); 
    signal eth_if_rx_s_axi_tvalid       : std_logic;  
    signal eth_if_rx_s_axi_tlast        : std_logic;   
    signal eth_if_rx_s_axi_tdata        : std_logic_vector(7 downto 0);  
    signal eth_if_rx_s_axi_tidx         : std_logic_vector(10 downto 0); 

    signal phy_tx_s_axi_tready          : std_logic;
    signal phy_tx_s_axi_tvalid          : std_logic; 
    signal phy_tx_s_axi_tlast           : std_logic; 
    signal phy_tx_s_axi_tdata           : std_logic_vector(7 downto 0); 
    signal phy_rx_s_axi_tvalid          : std_logic;  
    signal phy_rx_s_axi_tlast           : std_logic;   
    signal phy_rx_s_axi_tdata           : std_logic_vector(7 downto 0);  

    signal tester_tx_s_axi_tready       : std_logic;
    signal tester_tx_s_axi_tvalid       : std_logic; 
    signal tester_tx_s_axi_tlast        : std_logic; 
    signal tester_tx_s_axi_tdata        : std_logic_vector(7 downto 0); 
    signal tester_rx_s_axi_tvalid       : std_logic;  
    signal tester_rx_s_axi_tlast        : std_logic;   
    signal tester_rx_s_axi_tdata        : std_logic_vector(7 downto 0);  
       
    --==============================================================--
    --                               UART                           --
    --==============================================================--
    signal rx_buf_rden                 : std_logic;
    signal tx_buf_wren                 : std_logic;
    signal tx_buf_data                 : std_logic_vector(7 downto 0);
    signal tx_buf_full                 : std_logic;
    signal rx_data_count               : std_logic_vector(10 downto 0);
    signal rx_buf_empty                : std_logic;
    signal rx_buf_data                 : std_logic_vector(7 downto 0);
    signal clk_div_baud                : std_logic_vector(31 downto 0);
    
    --==============================================================--
    --                               DRR3                           --
    --==============================================================--
    --App Signals
    signal app_addr               : std_logic_vector(28 downto 0) := (others => '0');
    signal app_cmd                : std_logic_vector(2 downto 0)  := (others => '0');
    signal app_en                 : std_logic                     := '0';
    signal app_wdf_data           : std_logic_vector(63 downto 0) := (others => '0');
    signal app_wdf_end            : std_logic                     := '0';
    signal app_wdf_mask           : std_logic_vector(7 downto 0)  := (others => '0');
    signal app_wdf_wren           : std_logic                     := '0';
    signal app_rd_data            : std_logic_vector(63 downto 0);
    signal app_rd_data_end        : std_logic;
    signal app_rd_data_valid      : std_logic;
    signal app_rdy                : std_logic;
    signal app_wdf_rdy            : std_logic;
    signal app_sr_req             : std_logic := '0';
    signal app_ref_req            : std_logic := '0';
    signal app_zq_req             : std_logic := '0';
    signal app_sr_active          : std_logic;
    signal app_ref_ack            : std_logic;
    signal app_zq_ack             : std_logic;
    signal ui_clk                 : std_logic;
    signal ui_clk_sync_rst        : std_logic;
    --signal init_calib_complete    : std_logic;
    signal sys_clk_i              : std_logic := '0';
    signal device_temp_o          : std_logic_vector(11 downto 0);
    signal sys_rst                : std_logic := '1';
    
    
    signal ETH_CIT_REGISTERS      : STDLV_64_8;
    signal ETH_CIT_SET            : STD_LOGIC;
    signal PHY_IS_IDLE            : STD_LOGIC;

    ---------------------------------------------------------------------------
    ---------------------------------------------------------------------------
    --Debug Signals
--    signal ddr_report_word_count  : std_logic_vector(31 downto 0) := (others => '0');
--    signal ddr_report_error_count : std_logic_vector(31 downto 0) := (others => '0');
    ---------------------------------------------------------------------------
    
--	attribute MARK_DEBUG : string;
----    attribute MARK_DEBUG of CTRL_REGS               :  signal is "TRUE"; 
--    attribute MARK_DEBUG of STAT_REGS               :  signal is "TRUE";
--    attribute MARK_DEBUG of eth_if_tx_s_axi_tready  :  signal is "TRUE";   
--    attribute MARK_DEBUG of eth_if_tx_s_axi_tvalid  :  signal is "TRUE";   
--    attribute MARK_DEBUG of eth_if_tx_s_axi_tlast   :  signal is "TRUE";   
--    attribute MARK_DEBUG of eth_if_tx_s_axi_tdata   :  signal is "TRUE";   
--    attribute MARK_DEBUG of eth_if_rx_s_axi_tvalid  :  signal is "TRUE";   
--    attribute MARK_DEBUG of eth_if_rx_s_axi_tlast   :  signal is "TRUE";   
--    attribute MARK_DEBUG of eth_if_rx_s_axi_tdata   :  signal is "TRUE";   
--    attribute MARK_DEBUG of eth_if_rx_s_axi_tidx    :  signal is "TRUE";
--    attribute MARK_DEBUG of phy_ABONE_D556          :  signal is "TRUE"; 
--    attribute MARK_DEBUG of phy_DATA_D556_IN        :  signal is "TRUE"; 
--    attribute MARK_DEBUG of phy_DATA_D556_OUT       :  signal is "TRUE"; 
    
begin

    EEPROM_WP <= '0';

	--=============================================================
	-->>>                  CLOCK GENERATION                   <<<--
	--=============================================================
	U0_clock_generation : clk_wiz_0
	port map(
		clk_in1   => CLK_IN			,
	
		clk100    => clk100			,	
		clk125    => clk125			,
		clk125_90 => clk125_90		,
		clk200    => clk200			,

		reset     => clock_gen_rst	,
		locked    => clk_locked
	);
	clock_gen_rst <= not RESETN;

	clk_alive_p : process (clk_locked, clk100)
	begin
		if (clk_locked = '0') then
			clk_alive_cntr <= (others => '0');
		elsif (rising_edge(clk100)) then
			clk_alive_cntr <= clk_alive_cntr + 1;
		end if;
	end process;
	
	USER_LEDS(0) <= clk_locked;
	USER_LEDS(1) <= i_rst;
	USER_LEDS(2) <= clk_alive_cntr(25);
	USER_LEDS(3) <= STAT_REGS.init_calib_complete;
	
	--=============================================================
	-->>>              LOGIC RESET GENERATION                 <<<--
	--=============================================================
	i_rst_gen_p : process (clk_locked, clk100)
	begin
		if (clk_locked = '0') then
			rst_cntr <= (others => '0');
			i_rst    <= '1';
		elsif (rising_edge(clk100)) then
			if (rst_cntr < 100000) then
				rst_cntr <= rst_cntr + 1;
				i_rst    <= '1';
			else
				i_rst <= '0';
			end if;
		end if;
	end process;
	ETH_RESETN <= not i_rst;

	--=============================================================
	-->>>                      CPU                            <<<--
	--=============================================================
	U1_cpu : entity work.msbad_cpu_wrapper
		port map
		(
			--==============================================================--
			--                    CLOCK & RESET & INTERRUPT                 --
			--==============================================================--
			CLK100                  => clk100				,
			RST                     => i_rst				,
			CLK_LOCKED              => clk_locked			,
			
			cpu_interrupt			=> cpu_interrupt		,
			
			--==============================================================--
			--                                I2C                           --
			--==============================================================--
			I2C_IF_scl_io           => I2C_SCL				,
			I2C_IF_sda_io           => I2C_SDA				,
			
			--==============================================================--
			--                               QSPI                           --
			--==============================================================--
			QSPI_FLASH_IF_io0_io    => FLASH_D0				,
			QSPI_FLASH_IF_io1_io    => FLASH_D1				,
			QSPI_FLASH_IF_io2_io    => FLASH_D2				,
			QSPI_FLASH_IF_io3_io    => FLASH_D3				,
			QSPI_FLASH_IF_ss_io     => FLASH_CS_N			,
			
			--==============================================================--
			--                         REGISTER INTERFACE                   --
			--==============================================================--
			REG_IF_addr             => reg_if_addr			,
			REG_IF_clk              => reg_if_clk			,
			REG_IF_din              => reg_if_wr_data		,
			REG_IF_dout             => reg_if_rd_data		,
			REG_IF_en               => reg_if_en			,
			REG_IF_rst              => open					,
			REG_IF_we               => reg_if_wr_en
		);

	--=============================================================
	-->>>                USER LOGIC INTERFACE                 <<<--
	--=============================================================
	U2_axi_reg_if : entity work.ps_pl_axi_lite_bridge
		port map
		(
			clk                         => clk100			,
			rst                         => i_rst			,

			ext_reg_if_addr             => reg_if_addr		,
			ext_reg_if_wr_data          => reg_if_wr_data	,
			ext_reg_if_rd_data          => reg_if_rd_data	,
			ext_reg_if_en               => reg_if_en		,
			ext_reg_if_wr_en            => reg_if_wr_en		,
			
			ETH_CIT_REGISTERS           => ETH_CIT_REGISTERS,    
            ETH_CIT_SET                 => ETH_CIT_SET      ,    


			CTRL_REGS               	=> CTRL_REGS     	,
			STAT_REGS               	=> STAT_REGS        
		);

	--==============================================================--
	-->>>                            UART                        <<<--
	--==============================================================--
	U3_ext_interface_uart_trx : entity work.uart_trx 
		port map
		(
			clk             => clk100                                    ,
			rst             => eth_if_rst                                ,
			
			clk_div_baud    => CTRL_REGS.ext_interface_clk_div_baud      ,
			
			ser_tx          => RS422_TX                                  ,
			ser_rx          => RS422_RX                                  ,
			
			rx_buf_empty    => STAT_REGS.ext_interface_rx_buf_empty      ,
			rx_buf_rden     => CTRL_REGS.ext_interface_rx_buf_rden       ,
			rx_buf_data     => STAT_REGS.ext_interface_rx_buf_data       ,
				
			tx_buf_full     => STAT_REGS.ext_interface_tx_buf_full       ,
			tx_buf_wren     => CTRL_REGS.ext_interface_tx_buf_wren       ,
			tx_buf_data     => CTRL_REGS.ext_interface_tx_buf_data
		);
    cpu_interrupt(0) <= not STAT_REGS.ext_interface_rx_buf_empty;

	--=============================================================
	-->>>                       ETHERNET                      <<<--
	--=============================================================
    U4_eth_if : entity work.eth_if
       port map
	   (    
            --==============================================================--
            -- 						    CLOCK & RESET						--
            --==============================================================--
            clk100                  => clk100                           ,
            clk125                  => clk125                           ,
            clk125_90               => clk125_90                        ,
            clk200                  => clk200                           ,
            dcm_locked              => clk_locked                       ,
            rst                     => eth_if_rst                       ,
            rx_fifo_rst             => CTRL_REGS.eth_if_rx_fifo_rst     ,
            tx_fifo_rst             => CTRL_REGS.eth_if_tx_fifo_rst     ,
            eth_mac_speed           => CTRL_REGS.eth_mac_speed          ,
            
            --==============================================================--
            -- 						    RGMII INTERFACE						--
            --==============================================================--
            rgmii_txd               => RGMII_TXD                        ,
            rgmii_tx_ctl            => RGMII_TX_CTL                     ,
            rgmii_txc               => RGMII_TXC                        ,
            rgmii_rxd               => RGMII_RXD                        ,
            rgmii_rx_ctl            => RGMII_RX_CTL                     ,
            rgmii_rxc               => RGMII_RXC                        ,
            phy_resetn              => open                             ,
    
            --==============================================================--
            -- 						   USER INTERFACE				        --
            --==============================================================--
            TX_S_AXI_TREADY         => eth_if_tx_s_axi_tready           ,
            TX_S_AXI_TVALID         => eth_if_tx_s_axi_tvalid           ,
            TX_S_AXI_TLAST          => eth_if_tx_s_axi_tlast            ,
            TX_S_AXI_TDATA          => eth_if_tx_s_axi_tdata            ,
                                                                        
            RX_S_AXI_TVALID         => eth_if_rx_s_axi_tvalid           ,
            RX_S_AXI_TLAST          => eth_if_rx_s_axi_tlast            ,
            RX_S_AXI_TDATA          => eth_if_rx_s_axi_tdata            ,
            RX_S_AXI_TIDX           => eth_if_rx_s_axi_tidx             ,
            --==============================================================--
            -- 						   CPU INTERFACE				        --
            --==============================================================--
            -- CPU TO ETHERNET HEADER FIELD WRITE PATH
            ETH_REGISTERS_WR_EN		=> CTRL_REGS.eth_registers_wr_en    ,
            ETH_REGISTERS_WR_IDX	=> CTRL_REGS.eth_registers_wr_idx   ,
            ETH_REGISTERS_WR_DATA	=> CTRL_REGS.eth_registers_wr_data  ,
            
            ETH_CIT_REGISTERS       => ETH_CIT_REGISTERS                ,    
            ETH_CIT_SET             => ETH_CIT_SET                      ,  
            PHY_IS_IDLE             => PHY_IS_IDLE                      ,  
                            
            ERROR                   => STAT_REGS.eth_error 
        );       
    eth_if_rst <= i_rst or CTRL_REGS.eth_if_rst;

    --=============================================================
	-->>>                       MIG                           <<<--
	--=============================================================
    U5_ddr3_ctrl : mig_7series_0
	   port map
	   (
            -- Memory interface ports
            ddr3_addr           => ddr3_addr,
            ddr3_ba             => ddr3_ba,
            ddr3_cas_n          => ddr3_cas_n,
            ddr3_ck_n           => ddr3_ck_n,
            ddr3_ck_p           => ddr3_ck_p,
            ddr3_cke            => ddr3_cke,
            ddr3_ras_n          => ddr3_ras_n,
            ddr3_reset_n        => ddr3_reset_n,
            ddr3_we_n           => ddr3_we_n,
            ddr3_dq             => ddr3_dq,
            ddr3_dqs_n          => ddr3_dqs_n,
            ddr3_dqs_p          => ddr3_dqs_p,
    
            ddr3_cs_n           => ddr3_cs_n,
            ddr3_dm             => ddr3_dm,
            ddr3_odt            => ddr3_odt,
            -- Application interface ports
            app_addr            => app_addr,
            app_cmd             => app_cmd,
            app_en              => app_en,
            app_wdf_data        => app_wdf_data,
            app_wdf_end         => app_wdf_end,
            app_wdf_mask        => app_wdf_mask,
            app_wdf_wren        => app_wdf_wren,
            app_rd_data         => app_rd_data,
            app_rd_data_end     => app_rd_data_end,
            app_rd_data_valid   => app_rd_data_valid,
            app_rdy             => app_rdy,
            app_wdf_rdy         => app_wdf_rdy,
            app_sr_req          => app_sr_req,
            app_ref_req         => app_ref_req,
            app_zq_req          => app_zq_req,
            app_sr_active       => app_sr_active,
            app_ref_ack         => app_ref_ack,
            app_zq_ack          => app_zq_ack,
            ui_clk              => ui_clk,
            ui_clk_sync_rst     => ui_clk_sync_rst,
            init_calib_complete => STAT_REGS.init_calib_complete,
            -- System Clock Ports
            sys_clk_i           => ddr3_sys_clk,
            device_temp_o       => device_temp_o,
            sys_rst             => sys_rst
        );
    sys_rst <= clk_locked;

	process (ui_clk)
		variable State     : natural range 0 to 5 := 0;
		variable addr      : std_logic_vector(app_addr'range);
		variable wait_cntr : natural range 0 to 1023 := 0;
	begin
		if rising_edge(ui_clk) then
			app_en       <= '0';
			app_wdf_wren <= '0';
			app_wdf_end  <= '0';
			case State is
				when 0 =>
					wait_cntr := 0;
					addr      := (others => '0');
					State     := 1;
				when 1 =>
					app_wdf_wren <= '1';
					app_wdf_end  <= '1';
					app_wdf_data <= X"BABA0123DEDE4567";
					app_addr     <= addr;
					if app_wdf_wren = '1' and app_wdf_rdy = '1' then
						app_wdf_wren <= '0';
						State := 2;
					end if;
				when 2 =>
					app_en  <= '1';
					app_cmd <= "000"; -- write
					if app_en = '1' and app_rdy = '1' then
						app_en <= '0';
						State := 3;
					end if;
				when 3 =>
					wait_cntr := wait_cntr + 1;
					if wait_cntr = 1023 then
						State := 4;
					end if;
				when 4 =>
					app_en  <= '1';
					app_cmd <= "001"; -- read
					if app_en = '1' and app_rdy = '1' then
						app_en <= '0';
						addr  := addr + 8;
						State := 5;
					end if;
				when 5 =>
					if app_rd_data_valid = '1' then
						STAT_REGS.DDR_report_word_count <= STAT_REGS.DDR_report_word_count + '1';
						if app_rd_data /= app_wdf_data then
							STAT_REGS.DDR_report_error_count <= STAT_REGS.DDR_report_error_count + '1';
						end if;
						app_addr <= addr;
						State := 1;
					end if;
				when others =>
			end case;

			if ui_clk_sync_rst = '1' or STAT_REGS.init_calib_complete = '0' then
				STAT_REGS.DDR_report_word_count  <= (others  => '0');
				STAT_REGS.DDR_report_error_count <= (others => '0');
				state := 0;
			end if;
		end if;
	end process;
	
    --==============================================================--
    --                          ETH IF MUX                          --
    --==============================================================--	
	process(CTRL_REGS.eth_tester_enable)
	begin
        if(CTRL_REGS.eth_tester_enable='1') then
            eth_if_tx_s_axi_tvalid  <= tester_tx_s_axi_tvalid;
            eth_if_tx_s_axi_tlast   <= tester_tx_s_axi_tlast ;
            eth_if_tx_s_axi_tdata   <= tester_tx_s_axi_tdata ;
        else
            eth_if_tx_s_axi_tvalid  <= phy_tx_s_axi_tvalid;
            eth_if_tx_s_axi_tlast   <= phy_tx_s_axi_tlast ;
            eth_if_tx_s_axi_tdata   <= phy_tx_s_axi_tdata ;
        end if;
	end process;
    tester_tx_s_axi_tready  <= eth_if_tx_s_axi_tready;
    tester_rx_s_axi_tdata   <= eth_if_rx_s_axi_tdata;
    tester_rx_s_axi_tvalid  <= eth_if_rx_s_axi_tvalid;
    tester_rx_s_axi_tlast   <= eth_if_rx_s_axi_tlast; 
    phy_tx_s_axi_tready     <= eth_if_tx_s_axi_tready; 
    phy_rx_s_axi_tdata      <= eth_if_rx_s_axi_tdata;
    phy_rx_s_axi_tvalid     <= eth_if_rx_s_axi_tvalid;
    phy_rx_s_axi_tlast      <= eth_if_rx_s_axi_tlast;   
		                        
    --==============================================================--
    --                           PHY INTERFACE                      --
    --==============================================================--
    generate_iobufs : for i in 0 to 7 generate
    IOBUF_i : IOBUF
    generic map (
        DRIVE => 12,
        IOSTANDARD => "DEFAULT",
        SLEW => "SLOW")
    port map (
        O  => iobuf_DATA_D556_OUT(i),     -- Buffer output
        IO => DATA_D556(i),   -- Buffer inout port (connect directly to top-level port)
        I  => iobuf_DATA_D556_IN(i),     -- Buffer input
        T  => iobuf_t_ctrl      -- 3-state enable input, high=input, low=output 
    );
    end generate;
    
    
    U6_phy_if : entity work.phy_module
    port map(      
        AXI_ACLK                 => clk100,
        M_AXI_TDATA              => phy_tx_s_axi_tdata,
        M_AXI_TVALID             => phy_tx_s_axi_tvalid,
        M_AXI_TLAST              => phy_tx_s_axi_tlast,
        M_AXI_TREADY             => phy_tx_s_axi_tready,
        
        S_AXI_TDATA              => phy_rx_s_axi_tdata,
        S_AXI_TVALID             => phy_rx_s_axi_tvalid,
        S_AXI_TREADY             => open,
        S_AXI_TLAST              => phy_rx_s_axi_tlast,
        
        PHY_IS_IDLE              => PHY_IS_IDLE,
        
        CLK                      => clk100,
        RST                      => i_rst,
        
        WAIT_IN                  => CTRL_REGS.phy_if_wait_in,
        DEBOUNCE                 => CTRL_REGS.phy_if_debounce,
        COMPENSATION_COUNT       => CTRL_REGS.phy_if_compensation_count,   
        EMU_FB_49_NEWDATA_FLAG   => STAT_REGS.emu_fb_49_newdata_flag,        
        ERROR                    => STAT_REGS.phy_if_phy_error,               
        R_TIMEOUT                => CTRL_REGS.phy_if_r_timeout,
        E_RESPONSE_TIMEOUT       => CTRL_REGS.phy_if_e_response_timeout,
        E_REQUEST_TIMEOUT        => CTRL_REGS.phy_if_e_request_timeout,        
        E_RESPONSE_TIME          => STAT_REGS.phy_if_e_response_time,   
        DATA_OUT_SELECT          => CTRL_REGS.phy_if_data_out_select,
        ENABLED_PACKETS          => CTRL_REGS.phy_if_packet_enable,
        
        ADDRESS_BUS              => phy_ADDRESS_D556,
        FIELD_BUS                => phy_FIELD_D556,
        DATA_BUS_IN              => phy_DATA_D556_IN,
        DATA_BUS_OUT             => phy_DATA_D556_OUT,
        IOBUF_T_CTRL             => iobuf_t_ctrl,
        VB                       => phy_VB_D556,
        ABS_S                    => phy_ABS_D556,
        E                        => phy_E_D556,
        R                        => phy_R_D556,
        F                        => phy_F_D556,
        ED                       => phy_ED_D556,
        RD                       => phy_RD_D556,
        RC                       => phy_RC_D556,
        DE                       => phy_DE_D556,
        DP                       => phy_DP_D556,
        QH                       => phy_QH_D556,
        QC                       => phy_QC_D556
        
    );
    
    U7_phy_if_emulator : entity work.phy_emulator
    port map(
        CLK          => clk100,
        RST          => i_rst,
                     
        ADDRESS_BUS  => emu_ADDRESS_D556,
        FIELD_BUS    => emu_FIELD_D556,
        DATA_BUS_IN  => emu_DATA_D556_IN,
        DATA_BUS_OUT => emu_DATA_D556_OUT,
        EMU_E_WAIT_COUNTER => CTRL_REGS.emu_e_wait_counter,
        EMU_PACKET_WAIT_COUNTER => CTRL_REGS.emu_packet_wait_counter,   
        VB           => emu_VB_D556,
        ABS_S        => emu_ABS_D556,
        E            => emu_E_D556,
        R            => emu_R_D556,
        F            => emu_F_D556,
        ED           => emu_ED_D556,
        RD           => emu_RD_D556,
        RC           => emu_RC_D556,
        DE           => emu_DE_D556    
    );

    process(clk100)
    begin
        if rising_edge(clk100) then
            phy_ABONE_D556 <= ABONE_D556;
        end if;
    end process;
    STAT_REGS.phy_if_abone_no <= phy_ABONE_D556;
    
    STAT_REGS.phy_if_data_bus_out <= phy_DATA_D556_OUT;
--    phy_ABONE_D556      <= ABONE_D556   when  CTRL_REGS.phy_bus_mux_ctrl = '1' else emu_ABONE_D556;
    phy_ADDRESS_D556    <= ADDRESS_D556 when  CTRL_REGS.phy_bus_mux_ctrl = '1' else emu_ADDRESS_D556;
    phy_FIELD_D556      <= FIELD_D556   when  CTRL_REGS.phy_bus_mux_ctrl = '1' else emu_FIELD_D556;
    phy_VB_D556         <= VB_D556      when  CTRL_REGS.phy_bus_mux_ctrl = '1' else emu_VB_D556;
    phy_ABS_D556        <= ABS_D556     when  CTRL_REGS.phy_bus_mux_ctrl = '1' else emu_ABS_D556;
    phy_E_D556          <= E_D556       when  CTRL_REGS.phy_bus_mux_ctrl = '1' else emu_E_D556;
    phy_R_D556          <= R_D556       when  CTRL_REGS.phy_bus_mux_ctrl = '1' else emu_R_D556;
    phy_F_D556          <= F_D556       when  CTRL_REGS.phy_bus_mux_ctrl = '1' else emu_F_D556;
    phy_ED_D556         <= ED_D556      when  CTRL_REGS.phy_bus_mux_ctrl = '1' else emu_ED_D556;
    phy_RD_D556         <= RD_D556      when  CTRL_REGS.phy_bus_mux_ctrl = '1' else emu_RD_D556;
    phy_RC_D556         <= RC_D556      when  CTRL_REGS.phy_bus_mux_ctrl = '1' else emu_RC_D556;
    phy_DE_D556         <= DE_D556      when  CTRL_REGS.phy_bus_mux_ctrl = '1' else emu_DE_D556;
    DP_D556             <= phy_DP_D556;
    QH_D556             <= phy_QH_D556;
    QC_D556             <= phy_QC_D556;

    phy_DATA_D556_IN <= iobuf_DATA_D556_OUT when CTRL_REGS.phy_bus_mux_ctrl = '1' else emu_DATA_D556_OUT;
    iobuf_DATA_D556_IN <= phy_DATA_D556_OUT;
    emu_DATA_D556_IN <= phy_DATA_D556_OUT;  
        
    U8_eth_tester_i : entity work.eth_tester 
        port map
        (
            CLK                     => clk100                       ,
            RST                     => eth_if_rst                           ,
            RX_FIFO_RST             => eth_if_rst                           ,
            TX_FIFO_RST             => eth_if_rst                           ,
                        
            TX_S_AXI_TREADY         => tester_tx_s_axi_tready               ,
            TX_S_AXI_TVALID         => tester_tx_s_axi_tvalid               ,
            TX_S_AXI_TLAST          => tester_tx_s_axi_tlast                ,
            TX_S_AXI_TDATA          => tester_tx_s_axi_tdata                ,
                    
            RX_S_AXI_TVALID         => tester_rx_s_axi_tvalid               ,
            RX_S_AXI_TLAST          => tester_rx_s_axi_tlast                ,
            RX_S_AXI_TDATA          => tester_rx_s_axi_tdata                ,
            
            RX_DATA_FIFO_RD_EN      => CTRL_REGS.tester_rx_data_fifo_rd_en  ,
            RX_DATA_FIFO_RD_DATA    => STAT_REGS.tester_rx_data_fifo_rd_data,
            RX_DATA_FIFO_EMPTY      => STAT_REGS.tester_rx_data_fifo_empty  ,
            RX_CFG_FIFO_RD_EN       => CTRL_REGS.tester_rx_cfg_fifo_rd_en   ,
            RX_CFG_FIFO_RD_DATA     => STAT_REGS.tester_rx_cfg_fifo_rd_data ,
            RX_CFG_FIFO_EMPTY       => STAT_REGS.tester_rx_cfg_fifo_empty   ,
                                                                 
            TX_DATA_FIFO_WR_EN      => CTRL_REGS.tester_tx_data_fifo_wr_en  ,
            TX_DATA_FIFO_WR_DATA    => CTRL_REGS.tester_tx_data_fifo_wr_data,
            TX_DATA_FIFO_FULL       => STAT_REGS.tester_tx_data_fifo_full   ,
            TX_CFG_FIFO_WR_EN       => CTRL_REGS.tester_tx_cfg_fifo_wr_en   ,
            TX_CFG_FIFO_WR_DATA     => CTRL_REGS.tester_tx_cfg_fifo_wr_data ,
            TX_CFG_FIFO_FULL        => STAT_REGS.tester_tx_cfg_fifo_full        
        );

end Behavioral;