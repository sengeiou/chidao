//
//  OrderEntity.h
//  IPos
//
//  Created by hisuntech on 11-8-17.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//


@interface HisuntechOrderEntity : NSObject {
    NSString *client;
	NSString  *characterSet;	
	//合作商户的ID
	NSString  *partner;
	NSString  *notifyurl;
	NSString  *requestid;
	NSString  *signType;
	NSString  *type1;
	NSString  *itfVersion;
	NSString  *currency;
	NSString  *merAcDate;
	NSString  *userToken;
	NSString  *merchantCert;
	NSString  *ordno;
	NSString  *orderDate;
	NSString  *txnamt;
	NSString  *period;
	NSString  *periodUnit;
	NSString  *prodesc;
	NSString  *proid;
	NSString  *pronum;
	NSString  *proname;
    NSString  *proprice;
	NSString  *reserved1;
	NSString  *reserved2;
	NSString  *couponsflag;
	NSString  *sign;

	NSString *publicKey;
	
	NSString *orderStrGlobal;
	NSString *clientName;
    
    //下订单 返回的
    NSString *orderCREDT;//订单创建日期
    NSString *MERCNM;//商户名称
    
    ////add by ren_lei
    NSString *isIposCalled;
    NSString *isToSoundPayPage;
    NSString *isCalled;
    Boolean isReturn;

    UIViewController* mainView;
    UIImage* mainViewNaviControllerImage;
}

////add by ren_lei
@property Boolean isReturn;
@property(nonatomic,retain) NSString *orderCREDT;
@property(nonatomic,retain)	NSString  *MERCNM;
@property(nonatomic,retain) NSString *isIposCalled;
@property(nonatomic,retain)	NSString  *isToSoundPayPage;
@property(nonatomic,retain)	NSString  *isCalled;
@property(nonatomic,retain) UIViewController* mainView;
@property(nonatomic,retain) UIImage* mainViewNaviControllerImg;
/////end

@property(nonatomic,retain)	NSString  *client;
@property(nonatomic,readwrite,retain)	NSString  *characterSet;
@property(nonatomic,retain)	NSString  *partner;
@property(nonatomic,retain)	NSString  *notifyurl;
@property(nonatomic,retain)	NSString  *requestid;
@property(nonatomic,retain)	NSString  *signType;
@property(nonatomic,retain)	NSString  *type1;
@property(nonatomic,retain)	NSString  *itfVersion;
@property(nonatomic,retain)	NSString  *currency;
@property(nonatomic,retain)	NSString  *merAcDate;
@property(nonatomic,retain)	NSString  *userToken;
@property(nonatomic,retain)	NSString  *merchantCert;
@property(nonatomic,retain)	NSString  *ordno;
@property(nonatomic,retain)	NSString  *orderDate;
@property(nonatomic,retain)	NSString  *txnamt;
@property(nonatomic,retain)	NSString  *period;
@property(nonatomic,retain)	NSString  *periodUnit;
@property(nonatomic,retain)	NSString  *prodesc;
@property(nonatomic,retain)	NSString  *proid;
@property(nonatomic,retain)	NSString  *pronum;
@property(nonatomic,retain)	NSString  *proname;
@property(nonatomic,retain) NSString  *proprice;
@property(nonatomic,retain)	NSString  *reserved1;
@property(nonatomic,retain)	NSString  *reserved2;
@property(nonatomic,retain)	NSString  *couponsflag;
@property(nonatomic,retain)	NSString  *sign;

@property(nonatomic,retain) NSString *publicKey;
@property (nonatomic,retain)NSString *orderStrGlobal;
@property (nonatomic,retain) NSString *clientName;
@property (nonatomic,retain) NSString *clientVersion;

+(HisuntechOrderEntity *)Instance;
+(void)releaseData;
@end
