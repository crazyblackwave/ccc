/******************************************************************************
*
* (c) Copyright MELSiS Inc & ASELSAN. All rights reserved.
*
* THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS PART OF THIS FILE
* AT ALL TIMES.
*
******************************************************************************/

/****************************************************************************/
/**
*
* @file ext_if.h
*
* Contains the implementation of the  External Interface Communication component
* of ADAPTOR.
*
* <pre>
* MODIFICATION HISTORY:
*
* Ver   Who  			Date     	Changes
* ----- ----------		-------- 	-----------------------------------------------
* 1.00a B.SEKERLISOY  	13/01/2018 	First release
*
* </pre>
*
*****************************************************************************/

#ifndef EXT_IF_H_ /* prevent circular inclusions */
#define EXT_IF_H_ /* by using protection macros */

/***************************** Include Files ********************************/
#include "xil_types.h"
#include "scenarios.h"

/************************** Constant Definitions ****************************/
/* Frame related parameters */
#define EXT_INTERFACE_RX_MAX_PACKET_SIZE			66000
#define EXT_INTERFACE_TX_MAX_PACKET_SIZE			8192
#define EXT_INTERFACE_N_OF_BYTES_IN_HEADER			8
#define EXT_INTERFACE_MESSSAGE_SOF_MSB				0xAA
#define EXT_INTERFACE_MESSSAGE_SOF_LSB				0x55

#define CIT_MSG_CODE								0x80
#define VER_MSG_CODE								0x81

/* Message Processing Parameters */
#define CMD_RESPONSE_OFFSET							256

#define CMD_CIT_REQUEST								1
#define CMD_CIT_RESPONSE							CMD_RESPONSE_OFFSET + CMD_CIT_REQUEST

#define CMD_VERSION_READ_REQUEST					2
#define CMD_VERSION_READ_RESPONSE					CMD_RESPONSE_OFFSET + CMD_VERSION_READ_REQUEST

#define CMD_FLASH_SECTOR_WRITE_REQUEST				3
#define CMD_FLASH_SECTOR_WRITE_RESPONSE				CMD_RESPONSE_OFFSET + CMD_FLASH_SECTOR_WRITE_REQUEST

#define EMU_FB_49_READ_REQUEST						4
#define EMU_FB_49_READ_RESPONSE						CMD_RESPONSE_OFFSET + EMU_FB_49_READ_REQUEST

#define CMD_ETH_SETTINGS_WRITE_REQUEST				5
#define CMD_ETH_SETTINGS_WRITE_RESPONSE				CMD_RESPONSE_OFFSET + CMD_ETH_SETTINGS_WRITE_REQUEST

#define CMD_ETH_SETTINGS_READ_REQUEST				6
#define CMD_ETH_SETTINGS_READ_RESPONSE				CMD_RESPONSE_OFFSET + CMD_ETH_SETTINGS_READ_REQUEST

#define CMD_REQUEST_MAX								CMD_ETH_SETTINGS_READ_REQUEST
/**************************** Type Definitions ******************************/
typedef struct ethSettings_struct
{
	u8 srcMacAddr[6];
	u8 srcIpAddr[4];
	u8 srcPort[2];
	u8 multicastDestMacAddr[6];
	u8 multicastDestIpAddr[4];
	u8 multicastDestPort[2];
}ethSettings_struct_s;

/***************** Macros (Inline Functions) Definitions ********************/

/************************** Function Prototypes *****************************/
ethSettings_struct_s* getEthSettings(void);
/* interrupt related functions */
void external_interface_rx_handler(void);
/* frame transmit functions */
void external_interface_send_message(u16 msType, unsigned int msSize, u8* msPtr);
void external_interface_send_CIT_report(CITReport_s* CITReportPtr);
void external_interface_send_FB_49_data_report(EMUFB49_s* EMUFB49Ptr);
void external_interface_send_version_info(void);
void external_interface_send_flash_write_ack(u32 secNo);
void external_interface_send_eth_settings(void);

/* frame receive functions */
void processExtInterfaceCommand(void);

XStatus writeEthSettingsToEeprom(void);
XStatus readEthSettingsFromEeprom(void);
#endif /* EXT_IF_H_ */
