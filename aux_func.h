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
* @file aux_func.h
*
* Contains the implementation of the AUX Functions component of ADAPTOR Software.
*
* <pre>
* MODIFICATION HISTORY:
*
* Ver   Who  			Date     	Changes
* ----- ----------		-------- 	-----------------------------------------------
* 1.00a B.SEKERLISOY  	04/01/2018 	First release
*
* </pre>
*
*****************************************************************************/
#ifndef AUX_FUNC_H_
#define AUX_FUNC_H_

void lSleep(unsigned int sleepCount);
unsigned char bcd_to_dec(unsigned char d);
unsigned char dec_to_bcd(unsigned char d);
void byte2Float(float* f32, unsigned char* ptr);
void byte2U32(unsigned int* f32, unsigned char* ptr);

#endif /* AUX_FUNC_H_ */
