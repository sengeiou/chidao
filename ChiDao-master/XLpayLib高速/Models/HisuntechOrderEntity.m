//
//  OrderEntity.m
//  IPos
//
//  Created by hisuntech on 11-8-17.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "HisuntechOrderEntity.h"


@implementation HisuntechOrderEntity

@synthesize client;
@synthesize	characterSet;
@synthesize	partner;
@synthesize	notifyurl;
@synthesize	requestid;
@synthesize	signType;
@synthesize	type1;
@synthesize	itfVersion;
@synthesize	currency;
@synthesize	merAcDate;
@synthesize	userToken;
@synthesize	merchantCert;
@synthesize	ordno;
@synthesize	orderDate;
@synthesize	txnamt;
@synthesize	period;
@synthesize	periodUnit;
@synthesize	prodesc;
@synthesize	proid;
@synthesize	pronum;
@synthesize	proname;
@synthesize proprice;
@synthesize	reserved1;
@synthesize	reserved2;
@synthesize	couponsflag;
@synthesize	sign;
@synthesize publicKey;
@synthesize orderStrGlobal;
@synthesize clientName;
//add ren_lei
@synthesize isIposCalled;
@synthesize isToSoundPayPage;
@synthesize isCalled;
@synthesize mainView;
@synthesize mainViewNaviControllerImg;
@synthesize MERCNM;
@synthesize orderCREDT;
@synthesize isReturn;

@synthesize clientVersion;

+(HisuntechOrderEntity *)Instance{
	static HisuntechOrderEntity *shareSingleton;
	@synchronized(self){
		if (!shareSingleton) {
			shareSingleton=[[HisuntechOrderEntity alloc]init];
            NSDictionary *dict = [[NSBundle mainBundle] infoDictionary];
            NSString *strVer = [NSString stringWithFormat:@"%@",[dict objectForKey:@"CFBundleShortVersionString"]];
            [HisuntechOrderEntity Instance].clientVersion = strVer;
		}
		
	}
	return shareSingleton;
}

+(void)releaseData{
     [HisuntechOrderEntity Instance].client= @"";
    	[HisuntechOrderEntity Instance].characterSet= @"";
    	[HisuntechOrderEntity Instance].partner= @"";
    	[HisuntechOrderEntity Instance].notifyurl= @"";
    	[HisuntechOrderEntity Instance].requestid = @"";
    	[HisuntechOrderEntity Instance].signType = @"";
    	[HisuntechOrderEntity Instance].type1 = @"";
    	[HisuntechOrderEntity Instance].itfVersion = @"";
    	[HisuntechOrderEntity Instance].currency = @"";
    	[HisuntechOrderEntity Instance].merAcDate = @"";
    	[HisuntechOrderEntity Instance].userToken = @"";
    	[HisuntechOrderEntity Instance].merchantCert = @"";
    	[HisuntechOrderEntity Instance].ordno = @"";
    	[HisuntechOrderEntity Instance].orderDate = @"";
    	[HisuntechOrderEntity Instance].txnamt = @"";
    	[HisuntechOrderEntity Instance].period = @"";
    	[HisuntechOrderEntity Instance].periodUnit = @"";
    	[HisuntechOrderEntity Instance].prodesc = @"";
    	[HisuntechOrderEntity Instance].proid = @"";
    	[HisuntechOrderEntity Instance].pronum = @"";
    	[HisuntechOrderEntity Instance].proname = @"";
        [HisuntechOrderEntity Instance].proprice = @"";
    	[HisuntechOrderEntity Instance].reserved1 = @"";
    	[HisuntechOrderEntity Instance].reserved2 = @"";
    	[HisuntechOrderEntity Instance].couponsflag = @"";
    	[HisuntechOrderEntity Instance].sign = @"";
        [HisuntechOrderEntity Instance].publicKey = @"";
        [HisuntechOrderEntity Instance].orderStrGlobal = @"";
        [HisuntechOrderEntity Instance].clientName= @"";
        //add ren_lei
        [HisuntechOrderEntity Instance].isIposCalled= @"";
        [HisuntechOrderEntity Instance].isToSoundPayPage= @"";
        [HisuntechOrderEntity Instance].isCalled= @"";
        [HisuntechOrderEntity Instance]. mainView = NULL;
        [HisuntechOrderEntity Instance].mainViewNaviControllerImg = NULL;
        [HisuntechOrderEntity Instance].MERCNM= @"";
        [HisuntechOrderEntity Instance].orderCREDT= @"";
}


@end
