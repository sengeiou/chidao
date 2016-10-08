//
//  MYEncryptedFile.m
//  ManYiXing
//
//  Created by min on 16/8/3.
//  Copyright © 2016年 李友富. All rights reserved.
//

#import "MYEncryptedFile.h"

#import "openssl/evp.h"
#import "openssl/bio.h"
#import "openssl/buffer.h"

@implementation MYEncryptedFile

unsigned char *dst = nil;
unsigned char *outdata = nil;

+ (NSString*)dictionaryToJson:(NSDictionary *)dic

{
    NSError *parseError = nil;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
}

+ (NSString *) goEncryptDES:(NSDictionary *)dic {
    
    // 加密
    int a = 0;
    
    unsigned char* key = "etmobile";

    NSString *parStr = [MYEncryptedFile dictionaryToJson:dic];

    unsigned char* data = [parStr UTF8String];


    EncryptDES(data, strlen(data), key, 8, &outdata, &a);

    dst =malloc(a*2+1);

    memset(dst, 0, a*2+1);

    bin_to_asc(dst, outdata, a);

    NSString *str=[NSString stringWithCString:dst encoding:NSUTF8StringEncoding];
    
    return str;

}

+ (void)goFreeMemory {

    if (dst != nil ) {
        free(dst);
    }
    if (outdata != nil) {
        free(outdata);
    }
}

// -------------------

#define USE_EVP
int EncryptDES(unsigned char* data,int datalen,unsigned char* key,int keylen,
               unsigned char** outdata,int* outdatalen)
{
#ifdef USE_EVP
    int outlen, tmplen;
    
    unsigned char iv[] = {1,2,3,4,5,6,7,8};
    
    EVP_CIPHER_CTX ctx;
    /*默认是有填充的，设置为不填充 EVP_CIPHER_CTX_set_padding(&ctx,0); //1 自动补齐 0 不补齐*/
    EVP_CIPHER_CTX_init(&ctx);
    
    //DES标准算法应该是ECB模式
    int ret = EVP_EncryptInit_ex(&ctx, EVP_des_cbc(), NULL, key, iv);///
    
    ret = EVP_CIPHER_CTX_set_padding(&ctx, 0x0001|0x0002); //1 PKCS1自动补齐 0 不补齐
    if (ret<=0)
    {
        //        LOGE("EVP_CIPHER_CTX_set_padding failed:%d", ret);
        return -1;
    }
    //calc the 3des output len 8 multiple,be careful multi 2
    
    int c_po_len = (datalen + 8) & ~(8 - 1);
    unsigned char *cipher_t = (unsigned char *)malloc(c_po_len * sizeof(char));
    memset((void *)cipher_t, 0x0, c_po_len);
    ret = EVP_EncryptUpdate(&ctx, cipher_t, &outlen, (unsigned char*)data, datalen);
    if(ret <= 0)
    {
        free(cipher_t);
        cipher_t = NULL;
        EVP_CIPHER_CTX_cleanup(&ctx);
        return -1;
    }
    
    //注意，传入给下面函数的输出缓存参数必须注意不能覆盖了原来的加密输出的数据
    ret = EVP_EncryptFinal_ex(&ctx, cipher_t + outlen, &tmplen);
    if(ret <= 0)
    {
        free(cipher_t);
        cipher_t = NULL;
        EVP_CIPHER_CTX_cleanup(&ctx);
        
        return -2;
    }
    outlen += tmplen;
    EVP_CIPHER_CTX_cleanup(&ctx);
    
    //返回数据
    *outdatalen = outlen;
    *outdata = (unsigned char *)malloc(outlen+1);
    memcpy(*outdata, cipher_t, outlen);
    /*
     char *pasc = (char *)malloc(2*outlen+1);
     memset(pasc, 0, 2*outlen+1);
     LOGE("EVP_EncryptFinal_ex: %s(%d)", cipher_t, outlen);
     bin_to_asc(pasc, cipher_t, outlen);
     pasc[2*outlen] = '\0';
     
     LOGE("EVP_EncryptFinal_ex asc : %s(%d)", pasc, outlen);
     */
    *(*outdata+outlen) = '\0';
    
    free(cipher_t);
    cipher_t = NULL;
    return 0;
#else
    int docontinue = 1;
    unsigned char ch;
    unsigned char *src = NULL; /* 补齐后的明文 */
    //unsigned char *dst = NULL; /* 解密后的明文 */
    DES_cblock keyEncrypt;
    memset(keyEncrypt, 0, 8);
    
    if (keylen <= 8)
        memcpy(keyEncrypt, key, keylen);
    else
        memcpy(keyEncrypt, key, 8);
    
    DES_key_schedule keySchedule;
    DES_set_key_unchecked(&keyEncrypt, &keySchedule);
    
    const_DES_cblock inputText;
    DES_cblock outputText;
    
    /* 分析补齐明文所需空间及补齐填充数据 */
    int data_rest = datalen % 8;
    int len = datalen + (8 - data_rest);
    ch = 8 - data_rest;
    src = (unsigned char *)malloc(len);
    *outdata = (unsigned char *)malloc(len);
    *outdatalen = len;
    if (NULL == src || NULL == *outdata)
    {
        docontinue = 0;
    }
    if (docontinue)
    {
        int count;
        int i;
        /* 构造补齐后的加密内容 PKCS#7*/
        memset(src, 0, len);
        memcpy(src, data, datalen);
        memset(src + datalen, ch, 8 - data_rest);
        
        /* 循环加密/解密，每8字节一次 */
        count = len / 8;
        for (i = 0; i < count; i++)
        {
            memcpy(inputText, src + i * 8, 8);
            DES_ecb_encrypt(&inputText, &outputText, &keySchedule, DES_ENCRYPT);
            memcpy(*outdata + 8 * i, outputText, 8);
        }
    }
    
    if (NULL != src)
    {
        free(src);
        src = NULL;
    }
    
    return 0;
#endif // USE_EVP
}

/*
 *DES解密
 *
 */
int DecryptDES(unsigned char* data,int datalen,unsigned char* key,int keylen,
               char** outdata,int* outdatalen)
{
    
    unsigned char iv[] = {1,2,3,4,5,6,7,8};
    
    EVP_CIPHER_CTX ctx;
    EVP_CIPHER_CTX_init(&ctx);
    
    int ret = EVP_DecryptInit_ex(&ctx, EVP_des_cbc(), NULL, key, iv);
    ret = EVP_CIPHER_CTX_set_padding(&ctx, 0x0001|0x0002); //1 PKCS1自动补齐 0 不补齐*/
    if (ret<=0)
    {
        EVP_CIPHER_CTX_cleanup(&ctx);
        //        LOGE("EVP_DecryptInit_ex failed:%d", ret);
        return -1;
    }
    int c_len = 0;
    //calc the 3des output len 8 multiple
    int c_po_len = (datalen + 8) & ~(8 - 1);
    unsigned char *cipher_t = (unsigned char *)malloc(c_po_len*sizeof(char));
    memset((void *)cipher_t, 0, c_po_len);
    
    ret = EVP_DecryptUpdate(&ctx, cipher_t, &c_len, data, datalen);
    
    if (ret <=0 )
    {
        free(cipher_t);
        EVP_CIPHER_CTX_cleanup(&ctx);
        //        LOGE("EVP_DecryptUpdate failed:%d", ret);
        return -1;
    }
    
    int f_len=0;
    ret = EVP_DecryptFinal_ex(&ctx, cipher_t+c_len, &f_len);
    
    if (ret <= 0)
    {
        free(cipher_t);
        EVP_CIPHER_CTX_cleanup(&ctx);
        //        LOGE("EVP_DecryptFinal_ex failed:%d", ret);
        return -1;
    }
    
    
    EVP_CIPHER_CTX_cleanup(&ctx);
    //返回数据
    int outlen = c_len+f_len;
    *outdatalen = outlen;
    *outdata = (char *)malloc(outlen+1);
    memset(*outdata, 0, outlen+1);
    memcpy(*outdata, cipher_t, outlen);
    /*TODO*/
    *(*outdata+outlen) = '\0';
    //*outdata[outlen] = '\0';//这里怎么会越界呢？？有空研究--->should be: (*outdata)[outlen]
    //LOGE("EVP_DecryptFinal_ex: %s(%d)", *outdata, outlen);
    free(cipher_t);
    cipher_t = NULL;
    
    return 0;
}


char * Base64Encode(const unsigned char * input, int length, bool with_new_line)
{
    BIO * bmem = NULL;
    BIO * b64 = NULL;
    BUF_MEM * bptr = NULL;
    
    b64 = BIO_new(BIO_f_base64());
    if(!with_new_line) {
        BIO_set_flags(b64, BIO_FLAGS_BASE64_NO_NL);
    }
    bmem = BIO_new(BIO_s_mem());
    b64 = BIO_push(b64, bmem);
    BIO_write(b64, input, length);
    BIO_flush(b64);
    BIO_get_mem_ptr(b64, &bptr);
    
    char * buff = (char *)malloc(bptr->length + 1);
    memcpy(buff, bptr->data, bptr->length);
    buff[bptr->length] = 0;
    
    BIO_free_all(b64);
    b64 = NULL;
    return buff;
}

unsigned char * Base64Decode(char * input, int length, int *out_len, bool with_new_line)
{
    BIO * b64 = NULL;
    BIO * bmem = NULL;
    unsigned char * buffer = (unsigned char *)malloc(length);
    memset(buffer, 0, length);
    
    b64 = BIO_new(BIO_f_base64());
    if(!with_new_line) {
        BIO_set_flags(b64, BIO_FLAGS_BASE64_NO_NL);
    }
    bmem = BIO_new_mem_buf(input, length);
    bmem = BIO_push(b64, bmem);
    *out_len = BIO_read(bmem, buffer, length);
    
    BIO_free_all(bmem);
    
    return buffer;
}

int replace_char(char *src,int srclen,char org_ch,char dst_ch)
{
    int i;
    
    for(i=0;i<srclen;i++)
    {
        if (src[i]==org_ch) src[i]=dst_ch;
    }
    
    return 0;
}

int asc_to_bin(unsigned char *hex,char *dsp,int count)
{
    int i,offset = 0,tmp;
    for(i=0;i<count;i++)
    {
        tmp = dsp[i*2];
        if(isalpha(tmp)) offset = (isupper(tmp)? 0x41:0x61);
        
        hex[i] = ((dsp[i * 2] <= 0x39) ? dsp[i * 2] - 0x30
                  : dsp[i * 2] - offset + 10);
        hex[i] = hex[i] << 4;
        
        tmp = dsp[i*2+1];
        if(isalpha(tmp)) offset = (isupper(tmp)? 0x41:0x61);
        
        hex[i] += ((dsp[i * 2 + 1] <= 0x39) ? dsp[i * 2 + 1] - 0x30
                   : dsp[i * 2 + 1] - offset + 10);
    }
    return count;
}

int bin_to_asc( char *dsp, unsigned char *hex, int count)
{
    int i;
    char ch;
    for(i = 0; i < count; i++)
    {
        ch = (hex[i] & 0xf0) >> 4;
        dsp[i * 2] = (ch > 9) ? ch + 0x41 - 10 : ch + 0x30;
        ch = hex[i] & 0xf;
        dsp[i * 2 + 1] = (ch > 9) ? ch + 0x41 - 10 : ch + 0x30;
    }
    return 2*count;
}

int bcd_to_asc(char *dst,char *src,int len)
{
    int tmp_in,dstlen = 0;
    unsigned char   temp;
    
    for( tmp_in = 0; tmp_in < len ; tmp_in ++ )
    {
        temp = src[tmp_in] & 0xF0;
        temp = temp >> 4;
        
        dst[2*tmp_in] = temp + 0x30;
        
        temp = src[tmp_in] & 0x0F;
        dst[2*tmp_in+1] = temp + 0x30;
    }
    dstlen = len*2;
    return dstlen;
}

int asc_to_bcd(unsigned char *dst,unsigned char *src,int len)
{
    int tmp_in;
    unsigned char temp,d1,d2;
    
    for( tmp_in = 0; tmp_in < len ; )
    {
        temp = src[tmp_in];
        d1 = temp - 0x30;
        
        tmp_in++;
        
        if (tmp_in>=len)
        {
            d2=0x00;
        }
        else
        {
            temp = src[tmp_in];
            d2 = temp - 0x30;
        }
        
        tmp_in++;
        dst[(tmp_in-2)/2] = (d1<<4) | d2;
    }
    
    return (tmp_in+1)/2;
}

unsigned char asc_2_bcd(unsigned char asc) {
    unsigned char bcd;
    
    if ((asc >= '0') && (asc <= '9'))
        bcd = (unsigned char) (asc - '0');
    else if ((asc >= 'A') && (asc <= 'F'))
        bcd = (unsigned char) (asc - 'A' + 10);
    else if ((asc >= 'a') && (asc <= 'f'))
        bcd = (unsigned char) (asc - 'a' + 10);
    else
        bcd = (unsigned char) (asc - 48);
    return bcd;
}
unsigned char * ASCII_To_BCD(unsigned char *ascii, int asc_len) {
    unsigned char * bcd = (unsigned char*)malloc(asc_len/2);
    int j = 0;
    for (int i = 0; i < (asc_len + 1) / 2; i++) {
        bcd[i] = asc_2_bcd(ascii[j++]);
        bcd[i] = (unsigned char) (((j >= asc_len) ? 0x00 : asc_2_bcd(ascii[j++])) + (bcd[i] << 4));
    }
    return bcd;
}
/*
 char * BCD_2_ASCII(unsigned char* bytes, int len) {
 
 char *temp = (char *)malloc(len*2);
 char * val;
 for (int i = 0; i < bytes.length; i++){
 val =char)(((bytes[i] & 0xf0) >> 4) & 0x0f);
 temp[i * 2] = (char) (val > 9 ? val + 'A' - 10 : val + '0');
 
 val = (char) (bytes[i] & 0x0f);
 temp[i * 2 + 1] = (char) (val > 9 ? val + 'A' - 10 : val + '0');
 }
 return temp;
 }*/

char * BCD_2_ASC(unsigned char* bytes, int len) {
    
    char *temp = malloc(len*2);
    char val;
    for (int i = 0; i < len; i++) {
        val = (char) (((bytes[i] & 0xf0) >> 4) & 0x0f);
        temp[i * 2] = (char) (val > 9 ? val + 'A' - 10 : val + '0');
        
        val = (char) (bytes[i] & 0x0f);
        temp[i * 2 + 1] = (char) (val > 9 ? val + 'A' - 10 : val + '0');
    }
    return temp;
}

@end
