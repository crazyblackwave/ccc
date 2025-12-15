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
* @file aux_func.c
*
* Contains required functions AUX functions for ADAPTOR software
*
* <pre>
* MODIFICATION HISTORY:
*
* Ver   Who  			Date     	Changes
* ----- ----------		-------- 	-----------------------------------------------
* 1.00a B.SEKERLISOY  	01/04/2018 	First release
*
* </pre>
*
*****************************************************************************/

/***************************** Include Files ********************************/
#include "xil_types.h"

/************************** Constant Definitions ****************************/

/**************************** Type Definitions ******************************/

/***************** Macros (Inline Functions) Definitions ********************/

/************************** Variable Definitions ****************************/

/*
 * *************************************************************************
 *  Function 	:
 *  	lSleep
 *
 *  Description	:
 *  	nop loop for sleepCount times
 *
 *  Parameters	:
 *      unsigned int sleepCount
 *      	number of loop
 *
 *  Return value:
 *  	NA
 *************************************************************************
 */
void lSleep(unsigned int sleepCount)
{
	unsigned int i;
	for(i=0;i<sleepCount;i++)
	{

	}
}

/*
 * *************************************************************************
 *  Function 	:
 *  	bcd_to_dec
 *
 *  Description	:
 *  	convert binary coded decimal to decimal
 *
 *  Parameters	:
 *      u8 d
 *      	binary coded decimal value to be converted
 *
 *  Return value:
 *  	u8
 *  		decimal value
 *************************************************************************
 */
u8 bcd_to_dec(u8 d)
{
	return ((d & 0x0F) + (((d & 0xF0) >> 4) * 10));
}

/*
 * *************************************************************************
 *  Function 	:
 *  	dec_to_bcd
 *
 *  Description	:
 *  	convert decimal to binary coded decimal
 *
 *  Parameters	:
 *      u8 d
 *      	decimal value to be converted
 *
 *  Return value:
 *  	u8
 *  		binary coded decimal value
 *************************************************************************
 */
u8 dec_to_bcd(u8 d)
{
	return (((d / 10) << 4) & 0xF0) | ((d % 10) & 0x0F);
}

/*
 * *************************************************************************
 *  Function 	:
 *  	byte2Float
 *
 *  Description	:
 *  	4 bytes are combined and converted to single precision floating
 *  	point number
 *
 *  Parameters	:
 *      float f32
 *      	single precision floating value
 *      u8* ptr
 *      	byte start address
 *
 *  Return value:
 *  	NA
 *************************************************************************
 */
void byte2Float(float* f32, u8* ptr)
{
	u32* f = (u32*)(&(f32[0]));

	f[0] = ptr[3];
	f[0] = f[0]<<8;
	f[0] = f[0] | ptr[2];
	f[0] = f[0]<<8;
	f[0] = f[0] | ptr[1];
	f[0] = f[0]<<8;
	f[0] = f[0] | ptr[0];
}

/*
 * *************************************************************************
 *  Function 	:
 *  	byte2U32
 *
 *  Description	:
 *  	4 bytes are combined and converted to u32
 *
 *  Parameters	:
 *      u32* f32
 *      	u32 value
 *      u8* ptr
 *      	byte start address
 *
 *  Return value:
 *  	NA
 *************************************************************************
 */

void byte2U32(unsigned int* f32, u8* ptr)
{
	u32* f = (u32*)(&(f32[0]));

	f[0] = ptr[3];
	f[0] = f[0]<<8;
	f[0] = f[0] | ptr[2];
	f[0] = f[0]<<8;
	f[0] = f[0] | ptr[1];
	f[0] = f[0]<<8;
	f[0] = f[0] | ptr[0];
}
