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
* @file ext_if.c
*
* Contains required functions for the External Interface Communication of ADAPTOR.
* See the external_interface.h header file for more details on this driver.
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

/***************************** Include Files ********************************/
#include "ext_if.h"
#include "xparameters.h"
#include "xstatus.h"
#include "xintc.h"
#include "xintc_l.h"
#include "xil_exception.h"
#include "stdbool.h"
#include "mb_interface.h"
#include "aux_func.h"
#include "string.h"
#include "i2c_if.h"
#include "logic_reg_if.h"
#include "qspi_if.h"
#include "aux_func.h"

/************************** Constant Definitions ****************************/

/**************************** Type Definitions ******************************/

/***************** Macros (Inline Functions) Definitions ********************/

/************************** Variable Definitions ****************************/
/* External Interface Frame parameters */
u8 extInterfaceRxBuffer[EXT_INTERFACE_RX_MAX_PACKET_SIZE];
u8 extInterfaceRxBufferAux[EXT_INTERFACE_RX_MAX_PACKET_SIZE];
u8 extInterfaceTxBuffer[EXT_INTERFACE_TX_MAX_PACKET_SIZE];
u32 extInterfaceRxCounter;
u8 extInterfaceRxChecksum;
u16 extInterfaceRxCommand;
u32 extInterfaceRxLength;
u16 extInterfaceRxCommandAux;
u32 extInterfaceRxLengthAux;
u8 extInterfaceRxNewFrame;
u8 extInterfaceRxData;
u8* tBufPtr = &(extInterfaceTxBuffer[EXT_INTERFACE_N_OF_BYTES_IN_HEADER]);
u8* rBufPtr = &(extInterfaceRxBufferAux[EXT_INTERFACE_N_OF_BYTES_IN_HEADER]);

ethSettings_struct_s ethSettings;

u32 udpCitCounter = 0;
/************************** Function Prototypes *****************************/

ethSettings_struct_s* getEthSettings(void) { return (ethSettings_struct_s*)(&ethSettings); }

/*
 * *************************************************************************
 *  Function 	:
 *  	processExtInterfaceCommand
 *
 *  Description	:
 *  	Parse External Interface incoming message and process the message
 *
 *  Parameters	:
 *      NA
 *
 *  Return value:
 *  	NA
 *************************************************************************
 */
void processExtInterfaceCommand(void)
{
	u32 spiFlashAddr;
	unsigned int  sectorCount;
	unsigned int idx = 0;

	/* control if new command is received */
	if(extInterfaceRxNewFrame==1)
	{
		extInterfaceRxNewFrame = 0;

		/* pares message type */
		switch (extInterfaceRxCommandAux)
		{
			/* CIT Request Command */
			case CMD_CIT_REQUEST	:
				run_cit_scenario();
				break;

			/* HW & SW version Info Request Command */
			case CMD_VERSION_READ_REQUEST :
				external_interface_send_version_info();
				break;

			case CMD_FLASH_SECTOR_WRITE_REQUEST :
				byte2U32(&(sectorCount)					, &(rBufPtr[0]));
				spiFlashAddr = (u32)(sectorCount*(65536));

				/* write flash data to flash sector */
				SPIFlashWriteSector(spiFlashAddr, (u8*)(&rBufPtr[4]));

				/* send acknowledge with sector count */
				external_interface_send_flash_write_ack(sectorCount);

				break;

			case CMD_ETH_SETTINGS_WRITE_REQUEST :
				idx = 0;

				getEthSettings()->srcIpAddr[0] = rBufPtr[idx]; idx++;
				getEthSettings()->srcIpAddr[1] = rBufPtr[idx]; idx++;
				getEthSettings()->srcIpAddr[2] = rBufPtr[idx]; idx++;
				getEthSettings()->srcIpAddr[3] = rBufPtr[idx]; idx++;

				getEthSettings()->srcMacAddr[0] = rBufPtr[idx]; idx++;
				getEthSettings()->srcMacAddr[1] = rBufPtr[idx]; idx++;
				getEthSettings()->srcMacAddr[2] = rBufPtr[idx]; idx++;
				getEthSettings()->srcMacAddr[3] = rBufPtr[idx]; idx++;
				getEthSettings()->srcMacAddr[4] = rBufPtr[idx]; idx++;
				getEthSettings()->srcMacAddr[5] = rBufPtr[idx]; idx++;

				getEthSettings()->srcPort[0] = rBufPtr[idx]; idx++;
				getEthSettings()->srcPort[1] = rBufPtr[idx]; idx++;

				getEthSettings()->multicastDestIpAddr[0] = rBufPtr[idx]; idx++;
				getEthSettings()->multicastDestIpAddr[1] = rBufPtr[idx]; idx++;
				getEthSettings()->multicastDestIpAddr[2] = rBufPtr[idx]; idx++;
				getEthSettings()->multicastDestIpAddr[3] = rBufPtr[idx]; idx++;

				getEthSettings()->multicastDestMacAddr[0] = rBufPtr[idx]; idx++;
				getEthSettings()->multicastDestMacAddr[1] = rBufPtr[idx]; idx++;
				getEthSettings()->multicastDestMacAddr[2] = rBufPtr[idx]; idx++;
				getEthSettings()->multicastDestMacAddr[3] = rBufPtr[idx]; idx++;
				getEthSettings()->multicastDestMacAddr[4] = rBufPtr[idx]; idx++;
				getEthSettings()->multicastDestMacAddr[5] = rBufPtr[idx]; idx++;

				getEthSettings()->multicastDestPort[0] = rBufPtr[idx]; idx++;
				getEthSettings()->multicastDestPort[1] = rBufPtr[idx]; idx++;

				if(writeEthSettingsToEeprom() == XST_SUCCESS)
				{
					loadEthSettings();
				}
				else
				{

				}

				external_interface_send_message((u16)CMD_ETH_SETTINGS_WRITE_RESPONSE, idx, rBufPtr);
				break;

			case CMD_ETH_SETTINGS_READ_REQUEST :

				external_interface_send_eth_settings();

				break;

			default :
				break;
		}
	}
}

/*
 * *************************************************************************
 *  Function 	:
 *  	external_interface_rx_handler
 *
 *  Description	:
 *  	RS422 - UART receive interrupt service routine
 *
 *  Parameters	:
 *      NA
 *
 *  Return value:
 *  	NA
 *************************************************************************
 */
void external_interface_rx_handler(void)
{
	while(!(EXT_INTERFACE_RX_EMPTY[0]))
	{
		extInterfaceRxData = EXT_INTERFACE_RX_DATA[0];
		// EXT_INTERFACE_TX_DATA[0] = extInterfaceRxData;

		if( extInterfaceRxCounter == 0 )
		{
			if( extInterfaceRxData == EXT_INTERFACE_MESSSAGE_SOF_LSB)
			{
				extInterfaceRxBuffer[0] = EXT_INTERFACE_MESSSAGE_SOF_LSB;
				extInterfaceRxChecksum  = EXT_INTERFACE_MESSSAGE_SOF_LSB;
				extInterfaceRxCounter = 1;
			}
		}
		else if( extInterfaceRxCounter == 1 )
		{
			if( extInterfaceRxData == EXT_INTERFACE_MESSSAGE_SOF_MSB)
			{
				extInterfaceRxBuffer[1] = EXT_INTERFACE_MESSSAGE_SOF_MSB;
				extInterfaceRxChecksum += EXT_INTERFACE_MESSSAGE_SOF_MSB;
				extInterfaceRxCounter = 2;
			}
		}
		else if( extInterfaceRxCounter < EXT_INTERFACE_N_OF_BYTES_IN_HEADER )
		{
			extInterfaceRxBuffer[extInterfaceRxCounter] = extInterfaceRxData;
			extInterfaceRxChecksum += extInterfaceRxData;
			extInterfaceRxCounter++;

			/* parse rxCommand and rxlength if header is completely received*/
			if( extInterfaceRxCounter == EXT_INTERFACE_N_OF_BYTES_IN_HEADER )
			{
				extInterfaceRxCommand = (((u16)(extInterfaceRxBuffer[2])) <<  8) |
										  ((u16)(extInterfaceRxBuffer[3]));
				extInterfaceRxLength  = (((u32)(extInterfaceRxBuffer[4])) << 24) |
										 (((u32)(extInterfaceRxBuffer[5])) << 16) |
										 (((u32)(extInterfaceRxBuffer[6])) <<  8) |
										  ((u32)(extInterfaceRxBuffer[7]));
				/* check length and command type */
				if( (extInterfaceRxLength < sizeof(extInterfaceRxBuffer)) && (extInterfaceRxCommand <= CMD_REQUEST_MAX) )
				{

				}
				else
				{
					memset(extInterfaceRxBuffer, 0x00, sizeof(extInterfaceRxBuffer));
					extInterfaceRxChecksum = 0;
					extInterfaceRxCounter = 0;
				}
			}
		}
		else if( (extInterfaceRxCounter < sizeof(extInterfaceRxBuffer)) )
		{
			extInterfaceRxBuffer[extInterfaceRxCounter] = extInterfaceRxData;
			extInterfaceRxCounter++;

			if( extInterfaceRxCounter > (extInterfaceRxLength + EXT_INTERFACE_N_OF_BYTES_IN_HEADER + 1) )
			{
				memset(extInterfaceRxBuffer, 0x00, sizeof(extInterfaceRxBuffer));
				extInterfaceRxCounter = 0;
			}
			else if( extInterfaceRxCounter == (extInterfaceRxLength + EXT_INTERFACE_N_OF_BYTES_IN_HEADER + 1) )
			{
				/* checksum check */
				if( extInterfaceRxChecksum == extInterfaceRxData )
				{
					/* process message */
					memcpy(extInterfaceRxBufferAux, extInterfaceRxBuffer, sizeof(extInterfaceRxBuffer));
					extInterfaceRxCommandAux = extInterfaceRxCommand;
					extInterfaceRxLengthAux = extInterfaceRxLength;
					extInterfaceRxNewFrame = 1;
				}
				/* reset rx buffer */
				memset(extInterfaceRxBuffer, 0x00, sizeof(extInterfaceRxBuffer));
				extInterfaceRxChecksum = 0;
				extInterfaceRxCounter = 0;
			}
			else
			{
				extInterfaceRxChecksum += extInterfaceRxData;
			}
		}
		else
		{
			memset(extInterfaceRxBuffer, 0x00, sizeof(extInterfaceRxBuffer));
			extInterfaceRxChecksum = 0;
			extInterfaceRxCounter = 0;
		}
	}
	XIntc_AckIntr(XPAR_INTC_0_BASEADDR, XPAR_SYSTEM_CPU_INTERRUPT_MASK);
}

/*
 * *************************************************************************
 *  Function 	:
 *  	external_interface_send_message
 *
 *  Description	:
 *  	External Interface Message Frame generation and Transmission
 *
 *  Parameters	:
 *      u16 msType
 *      	message type
 *     	unsigned int
 *      	message length
 *      u8* msPtr
 *      	message pointer for data payload
 *
 *  Return value:
 *  	NA
 *************************************************************************
 */
void external_interface_send_message(u16 msType, unsigned int msSize, u8* msPtr)
{
	unsigned int i;
	u8 header[EXT_INTERFACE_N_OF_BYTES_IN_HEADER];
	u8 checksum = 0;

	header[0] = 0x55;
	header[1] = 0xAA;
	header[2] = (msType >> 8) & 0xFF;
	header[3] = msType & 0xFF;
	header[4] = (msSize >> 24) & 0xFF;
	header[5] = (msSize >> 16) & 0xFF;
	header[6] = (msSize >> 8) & 0xFF;
	header[7] = msSize & 0xFF;

	for(i=0;i<EXT_INTERFACE_N_OF_BYTES_IN_HEADER;i++)
	{
		checksum += header[i];
		while(EXT_INTERFACE_TX_FULL[0]==1){}
		EXT_INTERFACE_TX_DATA[0] = header[i];
	}

	for(i=0;i<msSize;i++)
	{
		checksum += msPtr[i];
		while(EXT_INTERFACE_TX_FULL[0]==1){}
		EXT_INTERFACE_TX_DATA[0] = msPtr[i];
	}

	while(EXT_INTERFACE_TX_FULL[0]==1){}
	EXT_INTERFACE_TX_DATA[0] = checksum;
}

/*
 * *************************************************************************
 *  Function 	:
 *  	external_interface_send_CIT_report
 *
 *  Description	:
 *		send CIT Report through external interface
 *
 *  Parameters	:
 *      CITReport_s* CITReportPtr
 *      	pointer of CITReport structure
 *
 *  Return value:
 *  	NA
 *************************************************************************
 */
void external_interface_send_CIT_report(CITReport_s* CITReportPtr)
{
	unsigned int i;
	u8* ptr = (u8*)(&extInterfaceTxBuffer[0]);
	unsigned int msSize = 0;
	unsigned int uidx = 0;

	memcpy(ptr, &(CITReportPtr->temparature), sizeof(float));		ptr += sizeof(float);	msSize += sizeof(float);
	for(i=0; i<8; i++)
	{
		memcpy(ptr, &(CITReportPtr->voltages[i]), sizeof(int));		ptr += sizeof(int);		msSize += sizeof(int);
	}
	memcpy(ptr, &(CITReportPtr->etcValue), sizeof(u32));			ptr += sizeof(u32);		msSize += sizeof(u32);
	memcpy(ptr, &(CITReportPtr->status), sizeof(u32));				ptr += sizeof(u32);		msSize += sizeof(u32);
	memcpy(ptr, &(CITReportPtr->phy_error), sizeof(u32));			ptr += sizeof(u32);		msSize += sizeof(u32);
	memcpy(ptr, &(CITReportPtr->phy_abone_no), sizeof(u32));		ptr += sizeof(u32);		msSize += sizeof(u32);
	memcpy(ptr, &(CITReportPtr->e_response_time), sizeof(u32));		ptr += sizeof(u32);		msSize += sizeof(u32);

	/* send CMD_CIT_RESPONSE tx frame through RS422 */
	external_interface_send_message((u16)CMD_CIT_RESPONSE, msSize, &extInterfaceTxBuffer[0]);

	/* send ethernet cit frame through ethernet-udp */
	ETH_CIT_REG_ADDR[0] = uidx; 	ETH_CIT_REG_DATA[0] = CIT_MSG_CODE; 	uidx += 1; // message code
	ETH_CIT_REG_ADDR[0] = uidx; 	ETH_CIT_REG_DATA[0] = udpCitCounter; 	uidx += 4; // id counter
	ETH_CIT_REG_ADDR[0] = uidx; 	ETH_CIT_REG_DATA[0] = 58; 				uidx += 1; // message data length

	ETH_CIT_REG_ADDR[0] = uidx; 	ETH_CIT_REG_DATA_F32[0] = CITReportPtr->temparature; 	uidx += 4;
	for(i=0; i<8; i++)
	{
		ETH_CIT_REG_ADDR[0] = uidx; 	ETH_CIT_REG_DATA[0] = CITReportPtr->voltages[i]; 	uidx += 4;
	}
	ETH_CIT_REG_ADDR[0] = uidx; 	ETH_CIT_REG_DATA[0] = CITReportPtr->etcValue; 			uidx += 4;
	ETH_CIT_REG_ADDR[0] = uidx; 	ETH_CIT_REG_DATA[0] = CITReportPtr->status; 			uidx += 4;
	ETH_CIT_REG_ADDR[0] = uidx; 	ETH_CIT_REG_DATA[0] = CITReportPtr->phy_error; 			uidx += 4;
	ETH_CIT_REG_ADDR[0] = uidx; 	ETH_CIT_REG_DATA[0] = CITReportPtr->phy_abone_no; 		uidx += 4;
	ETH_CIT_REG_ADDR[0] = uidx; 	ETH_CIT_REG_DATA[0] = CITReportPtr->e_response_time; 	uidx += 4;
	ETH_CIT_SET[0] = 1;

	udpCitCounter++;
}

void external_interface_send_FB_49_data_report(EMUFB49_s* EMUFB49Ptr)
{
	unsigned int i;
	u8* ptr = (u8*)(&extInterfaceTxBuffer[0]);
	unsigned int msSize = 0;

	*ptr = EMUFB49Ptr->field_bus; 		ptr ++;		msSize ++;
	for(i=0; i<4; i++)
	{
		*ptr = EMUFB49Ptr->data[i];		ptr ++;		msSize ++;
	}

	/* send CMD_CIT_RESPONSE tx frame */
	external_interface_send_message((u16)EMU_FB_49_READ_RESPONSE, msSize, &extInterfaceTxBuffer[0]);
}

/*
 * *************************************************************************
 *  Function 	:
 *  	external_interface_send_eth_settings
 *
 *  Description	:
 *		send ethernet settings through external interface
 *
 *  Parameters	:
 *      NA
 *
 *  Return value:
 *  	NA
 *************************************************************************
 */
void external_interface_send_eth_settings(void)
{
	unsigned int i;
	u8* ptr = (u8*)(&extInterfaceTxBuffer[0]);
	unsigned int msSize = 0;

	for(i=0; i<4; i++)
	{
		*ptr = getEthSettings()->srcIpAddr[i];					ptr ++;		msSize ++;
	}
	for(i=0; i<6; i++)
	{
		*ptr = getEthSettings()->srcMacAddr[i];					ptr ++;		msSize ++;
	}
	for(i=0; i<2; i++)
	{
		*ptr = getEthSettings()->srcPort[i];					ptr ++;		msSize ++;
	}

	for(i=0; i<4; i++)
	{
		*ptr = getEthSettings()->multicastDestIpAddr[i];		ptr ++;		msSize ++;
	}
	for(i=0; i<6; i++)
	{
		*ptr = getEthSettings()->multicastDestMacAddr[i];		ptr ++;		msSize ++;
	}
	for(i=0; i<2; i++)
	{
		*ptr = getEthSettings()->multicastDestPort[i];			ptr ++;		msSize ++;
	}

	external_interface_send_message((u16)CMD_ETH_SETTINGS_READ_RESPONSE, msSize, &extInterfaceTxBuffer[0]);
}

/*
 * *************************************************************************
 *  Function 	:
 *  	external_interface_send_version_info
 *
 *  Description	:
 *		send hw & sw version through external interface
 *
 *  Parameters	:
 *      NA
 *
 *  Return value:
 *  	NA
 *************************************************************************
 */
void external_interface_send_version_info(void)
{
	u8* ptr = (u8*)(&extInterfaceTxBuffer[0]);
	unsigned int msSize = 0;

	*ptr = HW_VER;									ptr ++;	msSize ++;
	*ptr = EMBEDDED_SW_VER;							ptr ++;	msSize ++;
	*ptr = TEST_SW_VER;								ptr ++;	msSize ++;

	/* send CMD_TARGET_REPORT_RESPONSE tx frame */
	external_interface_send_message((u16)CMD_VERSION_READ_RESPONSE, msSize, &extInterfaceTxBuffer[0]);

	unsigned int uidx = 0;
	ETH_CIT_REG_ADDR[0] = uidx; 	ETH_CIT_REG_DATA[0] = VER_MSG_CODE; 	uidx += 1; // message code
	ETH_CIT_REG_ADDR[0] = uidx; 	ETH_CIT_REG_DATA[0] = 0; 				uidx += 1;
	ETH_CIT_REG_ADDR[0] = uidx; 	ETH_CIT_REG_DATA[0] = 0; 				uidx += 1;
	ETH_CIT_REG_ADDR[0] = uidx; 	ETH_CIT_REG_DATA[0] = 0; 				uidx += 1;
	ETH_CIT_REG_ADDR[0] = uidx; 	ETH_CIT_REG_DATA[0] = 0; 				uidx += 1;
	ETH_CIT_REG_ADDR[0] = uidx; 	ETH_CIT_REG_DATA[0] = 58; 				uidx += 1;
	ETH_CIT_REG_ADDR[0] = uidx; 	ETH_CIT_REG_DATA[0] = HW_VER; 			uidx += 1;
	ETH_CIT_REG_ADDR[0] = uidx; 	ETH_CIT_REG_DATA[0] = EMBEDDED_SW_VER; 	uidx += 1;
	ETH_CIT_REG_ADDR[0] = uidx; 	ETH_CIT_REG_DATA[0] = TEST_SW_VER; 		uidx += 1;
	ETH_CIT_REG_ADDR[0] = uidx; 	ETH_CIT_REG_DATA[0] = 0; 				uidx += 1;
	ETH_CIT_SET[0] = 1;
}

/*
 * *************************************************************************
 *  Function 	:
 *  	external_interface_send_flash_write_ack
 *
 *  Description	:
 *		send ack after writing sector to QSPI flash
 *
 *  Parameters	:
 *      u32 secNo
 *      	sector number to be ack'ed
 *
 *  Return value:
 *  	NA
 *************************************************************************
 */
void external_interface_send_flash_write_ack(u32 secNo)
{
	u8* ptr = (u8*)(&extInterfaceTxBuffer[0]);
	unsigned int msSize = 0;

	/* put parameters into tx data buffer */
	memcpy(ptr, &secNo, sizeof(u32)); 			ptr += sizeof(u32);

	/* calculate message length */
	msSize = sizeof(u32);

	/* send CMD_FREQ_HOP_CONTROL_RESPONSE tx frame */
	external_interface_send_message((u16)CMD_FLASH_SECTOR_WRITE_RESPONSE, msSize, &extInterfaceTxBuffer[0]);
}

/*
 ***************************************************************************
 *  Function 	:
 *  	calculateSwParamsReportChecksum
 *
 *  Description	:
 *  	checksum for ethernet settings is calculated by adding all the bytes
 *  	in the ethSettings structure
 *
 *  Parameters	:
 *      NA
 *
 *  Return value:
 *		u8
 *			calculated checksum value;
 *************************************************************************
 */
u8 calculateEthSettingsChecksum(void)
{
	u8 cs = 0;
	u8* tPtr;
	unsigned int i;

	tPtr = (u8*)(&ethSettings);
	for(i=0; i<sizeof(ethSettings_struct_s); i++)
	{
		cs += *tPtr;
		tPtr++;
	}

	return cs;
}

/*
 ***************************************************************************
 *  Function 	:
 *  	writeEthSettingsToEeprom
 *
 *  Description	:
 *  	write ethernet settings structure to eeprom
 *
 *  Parameters	:
 *      NA
 *
 *  Return value:
 *		XStatus
 *			XST_SUCCESS	: eeprom report write successful
 *			XST_FAILURE	: eeprom report write failed
 *************************************************************************
 */
XStatus writeEthSettingsToEeprom(void)
{
	XStatus st;
	u8 cs;

	/* calculate checksum for report */
	cs = calculateEthSettingsChecksum();

	/* write report */
	st = eepromWrite(EEPROM_ETH_SETTINGS_ADDR, (u8*)(&ethSettings), sizeof(ethSettings_struct_s));
	if(st!=XST_SUCCESS)
	{
		return XST_FAILURE;
	}

	/* write report checksum */
	st = eepromWrite(EEPROM_ETH_SETTINGS_CS_ADDR, (u8*)(&cs), 1);
	if(st!=XST_SUCCESS)
	{
		return XST_FAILURE;
	}

	return XST_SUCCESS;
}

/*
 ***************************************************************************
 *  Function 	:
 *  	readEthSettingsFromEeprom
 *
 *  Description	:
 *  	read ethernet settings structure from eeprom
 *
 *  Parameters	:
 *      NA
 *
 *  Return value:
 *		XStatus
 *			XST_SUCCESS	: eeprom report read successful, checksum is OK
 *			XST_FAILURE	: eeprom report read failed (eeprom/chekcsum)
 *************************************************************************
 */
XStatus readEthSettingsFromEeprom(void)
{
	XStatus st;
	u8 cs_calculated;
	u8 cs_eeprom;

	/* read report */
	st = eepromRead(EEPROM_ETH_SETTINGS_ADDR, (u8*)(&ethSettings), sizeof(ethSettings_struct_s));
	if(st!=XST_SUCCESS)
	{
		return XST_FAILURE;
	}

	/* read report checksum from eeprom */
	st = eepromRead(EEPROM_ETH_SETTINGS_CS_ADDR, (u8*)(&cs_eeprom), 1);
	if(st!=XST_SUCCESS)
	{
		return XST_FAILURE;
	}

	/* calculate checksum for report */
	cs_calculated = calculateEthSettingsChecksum();

	/* checksum control */
	if(cs_calculated != cs_eeprom)
	{
		return XST_FAILURE;
	}

	return XST_SUCCESS;
}
