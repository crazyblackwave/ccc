/*
 * user_logic_registers.h
 *
 *  Created on: Oct 31, 2016
 *      Author: Burak
 */

#ifndef USER_LOGIC_REGISTERS_H_
#define USER_LOGIC_REGISTERS_H_

#define USER_LOGIC_REG_IF_BASE_ADDR					XPAR_EXT_REG_IF_S_AXI_BASEADDR
#define USER_LOGIC_WO_BASE_ADDR						XPAR_EXT_REG_IF_S_AXI_BASEADDR
#define USER_LOGIC_RO_BASE_ADDR						XPAR_EXT_REG_IF_S_AXI_BASEADDR + 4*(0x800)

/* write registers */
#define EXT_INTERFACE_USER_GPIO						((u32*) (USER_LOGIC_WO_BASE_ADDR + 4*(0x00)))
#define EXT_INTERFACE_CLK_DIV_BAUD					((u32*) (USER_LOGIC_WO_BASE_ADDR + 4*(0x01)))
#define EXT_INTERFACE_TX_DATA						((u32*) (USER_LOGIC_WO_BASE_ADDR + 4*(0x02)))
#define ETH_REG_WR_IDX								((u32*) (USER_LOGIC_WO_BASE_ADDR + 4*(0x03)))
#define ETH_REG_WR_DATA								((u32*) (USER_LOGIC_WO_BASE_ADDR + 4*(0x04)))
#define ETH_IF_RX_FIFO_RST							((u32*) (USER_LOGIC_WO_BASE_ADDR + 4*(0x05)))
#define ETH_IF_TX_FIFO_RST							((u32*) (USER_LOGIC_WO_BASE_ADDR + 4*(0x06)))
#define ETH_MAC_SPEED								((u32*) (USER_LOGIC_WO_BASE_ADDR + 4*(0x07)))
#define ETH_IF_RST									((u32*) (USER_LOGIC_WO_BASE_ADDR + 4*(0x08)))
#define ETH_TX_DATA_FIFO_WR_DATA					((u32*) (USER_LOGIC_WO_BASE_ADDR + 4*(0x09)))
#define ETH_TX_CFG_FIFO_WR_DATA						((u32*) (USER_LOGIC_WO_BASE_ADDR + 4*(0x0A)))
#define ETH_TESTER_ENABLE							((u32*) (USER_LOGIC_WO_BASE_ADDR + 4*(0x0B)))
#define PHY_BUS_MUX_CTRL							((u32*) (USER_LOGIC_WO_BASE_ADDR + 4*(0x0C)))
#define EMU_E_WAIT_COUNTER							((u32*) (USER_LOGIC_WO_BASE_ADDR + 4*(0x0D)))
#define EMU_PACKET_WAIT_COUNTER						((u32*) (USER_LOGIC_WO_BASE_ADDR + 4*(0x0E)))
#define EXT_INTERFACE_PHY_IF_WAIT_IN				((u32*) (USER_LOGIC_WO_BASE_ADDR + 4*(0x0F)))
#define EXT_INTERFACE_PHY_IF_DEBOUNCE				((u32*) (USER_LOGIC_WO_BASE_ADDR + 4*(0x10)))
#define EXT_INTERFACE_PHY_IF_R_TIMEOUT          	((u32*) (USER_LOGIC_WO_BASE_ADDR + 4*(0x11)))
#define EXT_INTERFACE_PHY_IF_E_RESPONSE_TIMEOUT 	((u32*) (USER_LOGIC_WO_BASE_ADDR + 4*(0x12)))
#define EXT_INTERFACE_PHY_IF_E_REQUEST_TIMEOUT 		((u32*) (USER_LOGIC_WO_BASE_ADDR + 4*(0x13)))
#define EXT_INTERFACE_PHY_IF_COMPENSATION_COUNT 	((u32*) (USER_LOGIC_WO_BASE_ADDR + 4*(0x14)))
#define EXT_INTERFACE_PHY_IF_DATA_OUT_SELECT		((u32*) (USER_LOGIC_WO_BASE_ADDR + 4*(0x15)))
#define EXT_INTERFACE_PHY_IF_PACKET_ENABLE_255_224	((u32*) (USER_LOGIC_WO_BASE_ADDR + 4*(0x16)))
#define EXT_INTERFACE_PHY_IF_PACKET_ENABLE_223_192	((u32*) (USER_LOGIC_WO_BASE_ADDR + 4*(0x17)))
#define EXT_INTERFACE_PHY_IF_PACKET_ENABLE_191_160	((u32*) (USER_LOGIC_WO_BASE_ADDR + 4*(0x18)))
#define EXT_INTERFACE_PHY_IF_PACKET_ENABLE_159_128	((u32*) (USER_LOGIC_WO_BASE_ADDR + 4*(0x19)))
#define EXT_INTERFACE_PHY_IF_PACKET_ENABLE_127_96	((u32*) (USER_LOGIC_WO_BASE_ADDR + 4*(0x1A)))
#define EXT_INTERFACE_PHY_IF_PACKET_ENABLE_95_64	((u32*) (USER_LOGIC_WO_BASE_ADDR + 4*(0x1B)))
#define EXT_INTERFACE_PHY_IF_PACKET_ENABLE_63_32	((u32*) (USER_LOGIC_WO_BASE_ADDR + 4*(0x1C)))
#define EXT_INTERFACE_PHY_IF_PACKET_ENABLE_31_0		((u32*) (USER_LOGIC_WO_BASE_ADDR + 4*(0x1D)))

#define ETH_CIT_REG_ADDR							((u32*) (USER_LOGIC_WO_BASE_ADDR + 4*(0x200)))
#define ETH_CIT_REG_DATA							((u32*) (USER_LOGIC_WO_BASE_ADDR + 4*(0x201)))
#define ETH_CIT_REG_DATA_F32						((float*) (USER_LOGIC_WO_BASE_ADDR + 4*(0x201)))
#define ETH_CIT_SET									((u32*) (USER_LOGIC_WO_BASE_ADDR + 4*(0x202)))

/* read registers */
#define BOARD_STATUS							((u32*) (USER_LOGIC_RO_BASE_ADDR + 4*(0x00)))
#define EXT_INTERFACE_RX_EMPTY					((u32*) (USER_LOGIC_RO_BASE_ADDR + 4*(0x01)))
#define EXT_INTERFACE_RX_DATA					((u32*) (USER_LOGIC_RO_BASE_ADDR + 4*(0x02)))
#define EXT_INTERFACE_TX_FULL					((u32*) (USER_LOGIC_RO_BASE_ADDR + 4*(0x03)))
#define ETH_ERROR								((u32*) (USER_LOGIC_RO_BASE_ADDR + 4*(0x04)))
#define DDR_REPORT_WORD_COUNT					((u32*) (USER_LOGIC_RO_BASE_ADDR + 4*(0x05)))
#define DDR_REPORT_ERROR_COUNT					((u32*) (USER_LOGIC_RO_BASE_ADDR + 4*(0x06)))
#define INIT_CALIB_COMPLETE						((u32*) (USER_LOGIC_RO_BASE_ADDR + 4*(0x07)))
#define ETH_RX_DATA_FIFO_RD_DATA				((u32*) (USER_LOGIC_RO_BASE_ADDR + 4*(0x08)))
#define ETH_RX_CFG_FIFO_RD_DATA					((u32*) (USER_LOGIC_RO_BASE_ADDR + 4*(0x09)))
#define ETH_FIFO_STATUS							((u32*) (USER_LOGIC_RO_BASE_ADDR + 4*(0x0A)))
#define EXT_INTERFACE_DATA_BUS_OUT				((u32*) (USER_LOGIC_RO_BASE_ADDR + 4*(0x0B)))
#define EMU_FB_49_READ_FLAG						((u32*) (USER_LOGIC_RO_BASE_ADDR + 4*(0x11)))
#define EXT_INTERFACE_PHY_ERROR_FLAGS			((u32*) (USER_LOGIC_RO_BASE_ADDR + 4*(0x12)))
#define EXT_INTERFACE_ABONE_NO					((u32*) (USER_LOGIC_RO_BASE_ADDR + 4*(0x13)))
#define EXT_INTERFACE_E_RESPONSE_TIME			((u32*) (USER_LOGIC_RO_BASE_ADDR + 4*(0x14)))


/* FIFO_STATUS_MASKS */
#define RX_DATA_FIFO_EMPTY_MASK					0x1
#define RX_CFG_FIFO_EMPTY_MASK					0x2
#define TX_DATA_FIFO_FULL_MASK					0x4
#define TX_CFG_FIFO_FULL_MASK					0x8

#define CLK_FREQ								100000000
#define UART_BAUD_RATE							921600

/*phy if default parameter */
#define PHY_IF_WAIT_IN							0x0000000C
#define PHY_IF_DEBOUNCE							0x0000000C

#define PHY_IF_R_TIMEOUT          				1000
#define PHY_IF_E_RESPONSE_TIMEOUT      			500000
#define PHY_IF_E_REQUEST_TIMEOUT				200
#define PHY_IF_COMPENSATION_COUNT				3
//#define PHY_IF_SIB_WAIT_COUNTER					10

/*emulator if default parameter */
#define	EMU_E_WAIT_COUNTER_REG					0
#define	EMU_PACKET_WAIT_COUNTER_REG				14

/*mode select default parameter */
#define EMU_MODE								0
#define RADAR_MODE								1

/*data out select default parameter */
#define ADDRESS_MODE							0
#define NORMAL_MODE								1



/* ethernet tx packet defaults*/
#define DEFAULT_ETH_SRC_MAC_ADDR_5_MSB		0x1A
#define DEFAULT_ETH_SRC_MAC_ADDR_4			0x1B
#define DEFAULT_ETH_SRC_MAC_ADDR_3			0x1C
#define DEFAULT_ETH_SRC_MAC_ADDR_2			0x1D
#define DEFAULT_ETH_SRC_MAC_ADDR_1			0x1E
#define DEFAULT_ETH_SRC_MAC_ADDR_0_LSB		0x1F

#define DEFAULT_ETH_DEST_MAC_ADDR_5_MSB		0x01
#define DEFAULT_ETH_DEST_MAC_ADDR_4			0x00
#define DEFAULT_ETH_DEST_MAC_ADDR_3			0x5E
#define DEFAULT_ETH_DEST_MAC_ADDR_2			0x00
#define DEFAULT_ETH_DEST_MAC_ADDR_1			0x1E
#define DEFAULT_ETH_DEST_MAC_ADDR_0_LSB		0x01

#define DEFAULT_ETH_TYPE_MSB				0x08
#define DEFAULT_ETH_TYPE_LSB				0x00
#define DEFAULT_IP_VERSION					0x04
#define DEFAULT_IP_HEADER_LENGTH			0x05
#define DEFAULT_IP_SERVICE					0x00
#define DEFAULT_IP_LENGTH_MSB				0x00
#define DEFAULT_IP_LENGTH_LSB				28
#define DEFAULT_IP_DATAGRAM_ID_MSB			0x00
#define DEFAULT_IP_DATAGRAM_ID_LSB			0x00
#define DEFAULT_IP_FLAGS					0x00
#define DEFAULT_IP_FRAGMENT_OFFSET_MSB		0x00
#define DEFAULT_IP_FRAGMENT_OFFSET_LSB		0x00
#define DEFAULT_IP_TIMETOLIVE				0x80
#define DEFAULT_IP_PROTOCOL					0x11
#define DEFAULT_IP_HEADER_CHECKSUM_MSB		0x00
#define DEFAULT_IP_HEADER_CHECKSUM_LSB		0x00
#define DEFAULT_IP_SRC_IP_ADDR_3_MSB		192
#define DEFAULT_IP_SRC_IP_ADDR_2			168
#define DEFAULT_IP_SRC_IP_ADDR_1			1
#define DEFAULT_IP_SRC_IP_ADDR_0_LSB		201

#define DEFAULT_IP_DEST_IP_ADDR_3_MSB		239
#define DEFAULT_IP_DEST_IP_ADDR_2			0
#define DEFAULT_IP_DEST_IP_ADDR_1			30
#define DEFAULT_IP_DEST_IP_ADDR_0_LSB		1

#define DEFAULT_UDP_SRC_PORT_MSB			0x04
#define DEFAULT_UDP_SRC_PORT_LSB			0xA0
#define DEFAULT_UDP_DEST_PORT_MSB			0x0F
#define DEFAULT_UDP_DEST_PORT_LSB			0xA0
#define DEFAULT_UDP_LENGTH_MSB				0
#define DEFAULT_UDP_LENGTH_LSB				60
#define DEFAULT_UDP_CHECKSUM_MSB			0
#define DEFAULT_UDP_CHECKSUM_LSB			0

#define UDP_HEADER_SIZE_IN_BYTES			8
#define IP_HEADER_SIZE_IN_BYTES				20

#define ETH_SRC_MAC_ADDR_5_MSB_IDX			0
#define ETH_SRC_MAC_ADDR_4_IDX				1
#define ETH_SRC_MAC_ADDR_3_IDX				2
#define ETH_SRC_MAC_ADDR_2_IDX				3
#define ETH_SRC_MAC_ADDR_1_IDX				4
#define ETH_SRC_MAC_ADDR_0_LSB_IDX			5
#define ETH_DEST_MAC_ADDR_5_MSB_IDX			6
#define ETH_DEST_MAC_ADDR_4_IDX				7
#define ETH_DEST_MAC_ADDR_3_IDX				8
#define ETH_DEST_MAC_ADDR_2_IDX				9
#define ETH_DEST_MAC_ADDR_1_IDX				10
#define ETH_DEST_MAC_ADDR_0_LSB_IDX			11
#define ETH_TYPE_MSB_IDX					12
#define ETH_TYPE_LSB_IDX					13
#define IP_VERSION_IDX						14
#define IP_HEADER_LENGTH_IDX				15
#define IP_SERVICE_IDX						16
#define IP_LENGTH_MSB_IDX					17
#define IP_LENGTH_LSB_IDX					18
#define IP_DATAGRAM_ID_MSB_IDX				19
#define IP_DATAGRAM_ID_LSB_IDX				20
#define IP_FLAGS_IDX						21
#define IP_FRAGMENT_OFFSET_MSB_IDX			22
#define IP_FRAGMENT_OFFSET_LSB_IDX			23
#define IP_TIMETOLIVE_IDX					24
#define IP_PROTOCOL_IDX						25
#define IP_HEADER_CHECKSUM_MSB_IDX			26
#define IP_HEADER_CHECKSUM_LSB_IDX			27
#define IP_SRC_IP_ADDR_3_MSB_IDX			28
#define IP_SRC_IP_ADDR_2_IDX				29
#define IP_SRC_IP_ADDR_1_IDX				30
#define IP_SRC_IP_ADDR_0_LSB_IDX			31
#define IP_DEST_IP_ADDR_3_MSB_IDX			32
#define IP_DEST_IP_ADDR_2_IDX				33
#define IP_DEST_IP_ADDR_1_IDX				34
#define IP_DEST_IP_ADDR_0_LSB_IDX			35
#define UDP_SRC_PORT_MSB_IDX				36
#define UDP_SRC_PORT_LSB_IDX				37
#define UDP_DEST_PORT_MSB_IDX				38
#define UDP_DEST_PORT_LSB_IDX				39
#define UDP_LENGTH_MSB_IDX					40
#define UDP_LENGTH_LSB_IDX					41
#define UDP_CHECKSUM_MSB_IDX				42
#define UDP_CHECKSUM_LSB_IDX				43

void read_user_register(unsigned int registerAddr, unsigned int* registerValue);
unsigned int read_fpga_register(unsigned int regAddr);
void write_user_register(unsigned int registerAddr, unsigned int registerValue);
void init_user_registers(void);
void set_cfar_registers(void);
void loadEthFactoryDefaults(void);
void loadEthSettings(void);

#endif /* USER_LOGIC_REGISTERS_H_ */

