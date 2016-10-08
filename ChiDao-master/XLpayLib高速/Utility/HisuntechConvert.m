//
//  Convert.m
//  Demo_1
//
//  Created by allen on 14/10/22.
//  Copyright (c) 2014年 itazk. All rights reserved.
//

#import "HisuntechConvert.h"

@implementation HisuntechConvert
+(NSString *)convertBankAbbreviationToBankChinese:(NSString *)bankAbbreviation{
    /*
     CEB=中国光大银行
     PSBC=中国邮政储蓄银行
     ICBC=中国工商银行
     ABC=中国农业银行
     BOC=中国银行
     CCB=中国建设银行
     CDB=国家开发银行
     EIBC=中国进出口银行
     ADBC=中国农业发展银行
     BCOM=交通银行
     ECITIC=中信银行
     HXB=华夏银行
     CMBC=中国民生银行
     GDB=广东发展银行
     SDB=深圳发展银行
     CMB=招商银行
     CIB=兴业银行
     SPDB=上海浦东发展银行
     EBCL=恒丰银行
     CZB=浙商银行
     CBHC=渤海银行
     HSCB=徽商银行
     PABC=平安银行
     BOB=北京银行
     BOS=上海银行
     BSB=包商银行
     BRCB=北京农商银行
     CDRCB=成都农商银行
     BODL=大连银行
     BEA=东亚银行
     FJNX=福建农信社
     ZJCB=广东南粤银行
     GZCB=广州银行
     HRBCB=哈尔滨银行
     CITIB=花旗银行
     JSB=江苏银行
     CGNG=南充商业银行
     NJCB=南京银行
     NCB=南洋商业银行
     BOIMC=内蒙古银行
     NBCB=宁波银行
     BONX=宁夏银行
     QDCCB=青岛银行
     BOQH=青海银行
     SRCB=上海农商银行
     SXCCB=绍兴银行
     SJB=盛京银行
     TZB=台州银行
     WZCB=温州银行
     UCCB=乌鲁木齐银行
     SC=渣打银行
     CSCB=长沙银行
     CZCB=浙江稠州商业银行
     MTB=浙江民泰商业银行
     ZJTLCB=浙江泰隆银行
     CQRCB=重庆农村商业银行
     CQCB=重庆银行
     CRB=珠海华润银行
     */
    NSDictionary *bank = @{@"CEB":@"中国光大银行",
                           @"PSBC":@"中国邮政储蓄银行",
                           @"ICBC":@"中国工商银行",
                           @"ABC":@"中国农业银行",
                           @"BOC":@"中国银行",
                           @"CCB":@"中国建设银行",
                           @"CDB":@"国家开发银行",
                           @"EIBC":@"中国进出口银行",
                           @"ADBC":@"中国农业发展银行",
                           @"BOCOM":@"交通银行",
                           @"CITIC":@"中信银行",
                           @"HXB":@"华夏银行",
                           @"CMBC":@"中国民生银行",
                           @"GDB":@"广东发展银行",
                           @"SDB":@"深圳发展银行",
                           @"CMB":@"招商银行",
                           @"CIB":@"兴业银行",
                           @"SPDB":@"上海浦东发展银行",
                           @"EBCL":@"恒丰银行",
                           @"CZB":@"浙商银行",
                           @"CBHC":@"渤海银行",
                           @"HSCB":@"徽商银行",
                           @"PABC":@"平安银行",
                           @"BOB":@"北京银行",
                           @"BOS":@"上海银行",
                           @"BSB":@"包商银行",
                           @"BRCB":@"北京农商银行",
                           @"CDRCB":@"成都农商银行",
                           @"BODL":@"大连银行",
                           @"BEA":@"东亚银行",
                           @"FJNX":@"福建农信社",
                           @"ZJCB":@"广东南粤银行",
                           @"GZCB":@"广州银行",
                           @"HRBCB":@"哈尔滨银行",
                           @"CITIB":@"花旗银行",
                           @"JSB":@"江苏银行",
                           @"CGNG":@"南充商业银行",
                           @"NJCB":@"南京银行",
                           @"NCB":@"南洋商业银行",
                           @"BOIMC":@"内蒙古银行",
                           @"NBCB":@"宁波银行",
                           @"BONX":@"宁夏银行",
                           @"QDCCB":@"青岛银行",
                           @"SRCB":@"上海农商银行",
                           @"SXCCB":@"绍兴银行",
                           @"SJB":@"盛京银行",
                           @"TZB":@"台州银行",
                           @"WZCB":@"温州银行",
                           @"UCCB":@"乌鲁木齐银行",
                           @"SC":@"渣打银行",
                           @"CSCB":@"长沙银行",
                           @"CZCB":@"浙江稠州商业银行",
                           @"MTB":@"浙江民泰商业银行",
                           @"ZJTLCB":@"浙江泰隆银行",
                           @"CQRCB":@"重庆农村商业银行",
                           @"CQCB":@"重庆银行",
                           @"CRB":@"珠海华润银行",
                           @"BORZ":@"日照银行",
                           @"WHCCB":@"威海市商业银行"
                           };//BORZ   WHCCB
    NSString *bankChinese = [bank objectForKey:bankAbbreviation];
    return bankChinese;
}

@end
