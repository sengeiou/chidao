#ifndef _CARDTOOL_H
#define _CARDTOOL_H

#define  U08  unsigned char
#define  U32  int
#define  U16  int
void DeliverKey(unsigned char* pRootKey, unsigned char* pDeliverFactor, unsigned char* pProcessKey);
void lf_line_desmac(unsigned char* key,unsigned char* sjs,unsigned char* datain,unsigned char in_len,unsigned char* dataout,unsigned char* out_len);
void lf_line_mac(unsigned char* key,unsigned char* sjs,unsigned char* datain,unsigned char in_len,unsigned char* dataout);
void f_getmac(unsigned char *chushi,unsigned char *key,unsigned char *buff,unsigned char *mac,int count);
void f_getmac_single(unsigned char *chushi,unsigned char *key,unsigned char *buff,unsigned char *mac,int count);
void f_buff_xor(unsigned char *buf1,unsigned char *buf2,int i_len);
void des_en1(unsigned char *key,unsigned char *mingwen,int m_len,unsigned char *miwen);
void des_de1(unsigned char *key,unsigned char *miwen,int m_len,unsigned char *mingwen);
void des_en3(unsigned char *key,unsigned char *mingwen,int m_len,unsigned char *miwen);
void des_de3(unsigned char *key,unsigned char *miwen,int m_len,unsigned char *mingwen);
void TradeMac1(unsigned char *key,unsigned char *inData,unsigned char inLen,unsigned char *termSerialNum,unsigned char *tradeSerialNum,unsigned char*outData);
void lf_line_desmac2(unsigned char* key,unsigned char* sjs,unsigned char* datain,unsigned char in_len,unsigned char* dataout,unsigned char * out_len);
//void lf_line_desmac3(unsigned char* key,unsigned char* sjs,unsigned char* datain,unsigned char in_len,unsigned char* dataout,unsigned char* out_len);
void EsamAuthenCode(unsigned char *ucKey, unsigned char *ucRandom,unsigned char *inMingWen,unsigned char inLen,unsigned char *outAuthCode );
void PBOC_3DES_MAC( U08 *buf, U32 buf_size, U08 *key, U08 *mac_buf,U08 *iv);

#endif


