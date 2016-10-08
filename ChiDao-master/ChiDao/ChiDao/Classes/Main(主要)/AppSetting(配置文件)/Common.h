
typedef NS_ENUM(NSInteger, GestureType) {
    
    TapGesType = 1,
    LongGesType,
    
};
#import "KeyChainUUID.h"
#import "IOSMD5Class.h"

#define BASEURL @"http://123.129.210.53:8080/fbms"

//-----------登录功能-----------------
//用户快速注册
#define UserRegURL @"/accountApply/userreg.mb"
//登录
#define LoginURL @"/accountApply/userLog.mb"
//注销
#define LogoutURL @"/accountApply/logout.mb"
//用户修改基本信息
#define UserUpdateURL @"/accountApply/userUpdate.mb"
//token更新
#define TokenUpdateURL @"/accountApply/tokenupdate.mb"
//校验密码
#define ValidatePwdURL @"/accountApply/validatePwd.mb"
//修改密码
#define RevisePwdURL @"/accountApply/revisePwd.mb"
//忘记密码
#define ForgetPwdURL @"/accountApply/forgetPwd.mb"

//-----------鲁通卡功能-----------------
//鲁通卡添加
#define AddCard @"/etc/addcard.mb"
//鲁通卡删除
#define RemoveCard @"/etc/removecard.mb"
//鲁通卡记录查询
#define GetCard @"/etc/getcards.mb"
//订单提交
#define CreateOrder @"/etc/createorder.mb"
//多订单查询(根据app账单调整)
#define GetOrders @"/etc/getorders.mb"
//卡信息查询
#define GetCardInfo @"/etc/getcardinfo.mb"

//-----------我的功能-----------------
//发票信息查询
#define GetTicketURL @"/etc/gettickets.mb"
//地址添加 最多X条，X=5
#define AddAddrURL @"/person/addaddr.mb"
//地址修改
#define UpdateAddrURL @"/person/editAddr.mb"
//地址删除
#define RemoveAddrURL @"/person/deladdr.mb"
//地址信息查询
#define GetAddrsURL @"/person/getaddrs.mb"
//-----------obu激活功能-----------------
//OBU 亮灯次数获取
#define OBULightURL @"/obu/getLightNums.mb"
//OBU 视频上传
#define OBUUpLoadFileURL @"/obu/uploadOBUVideo.mb"

//获取UDID
#define UDID [IOSMD5Class md5_16BIT:[KeyChainUUID Value]]
//转换十六进制颜色
#define HexColor(str) [Tool colorWithHexString:str]

#define WS(weakSelf)  __weak __typeof(&*self)weakSelf = self;


//判断是否为iPhone
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)

//判断是否为iphone5的宏
#define iPhone5 ([UIScreen mainScreen].bounds.size.height == 568)

//判断是否为iphone4 的宏
#define iPhone4 ([UIScreen mainScreen].bounds.size.height == 480)

//日志输出宏定义
#ifdef DEBUG
//调试状态
#define MyLog(...) NSLog(__VA_ARGS__)
#else
//发布状态
#define MyLog(...)

#endif

#define iOS7 ([[[UIDevice currentDevice]systemVersion] floatValue] >= 7.0)

#define iOS6 (([[[UIDevice currentDevice]systemVersion] floatValue] >= 6.0)&&([[[UIDevice currentDevice]systemVersion] floatValue] < 7.0))
#define IOS_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]

#define myBounds [UIScreen mainScreen].bounds
#define myScreenWidth [UIScreen mainScreen].bounds.size.width
#define myScreenHeight [UIScreen mainScreen].bounds.size.height

#define kScreen_Height      ([UIScreen mainScreen].bounds.size.height)
#define kScreen_Width       ([UIScreen mainScreen].bounds.size.width)
#define kScreen_Frame       (CGRectMake(0, 0 ,kScreen_Width,kScreen_Height))

//NavBar高度
#define myNavigationBarHeight 44
//状态栏高度
#define myStatusBarHeight [[UIApplication sharedApplication] statusBarFrame].size.height

// 获得RGB颜色
#define kkColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1]


#define RGBA(R/*红*/, G/*绿*/, B/*蓝*/, A/*透明*/) \
[UIColor colorWithRed:R/255.f green:G/255.f blue:B/255.f alpha:A]

// 去除滚动条
#pragma mark 重写这个方法的目的。去掉父类默认的操作：显示滚动条
#define kHideScroll - (void)viewDidAppear:(BOOL)animated { }


//单例宏

// .h
#define single_interface(class)  + (class *)shared##class;

// .m
// \ 代表下一行也属于宏
// ## 是分隔符
#define single_implementation(class) \
static class *_instance; \
\
+ (class *)shared##class \
{ \
if (_instance == nil) { \
_instance = [[self alloc] init]; \
} \
return _instance; \
} \
\
+ (id)allocWithZone:(NSZone *)zone \
{ \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
_instance = [super allocWithZone:zone]; \
}); \
return _instance; \
}

// 页面的背景色
#define BackgroundColor kkColor(255, 255, 255)
// 导航栏的背景色
#define NavBarColor kkColor(239, 239, 239)

// 小字背景色
#define DetailColor kkColor(134, 134, 134)

//设置字体
#define kFontSize [UIFont systemFontOfSize:13]
//标题字体大小
#define myTextSizeTitle [UIFont systemFontOfSize:15]

//按钮颜色
#define btnColor [UIColor colorWithRed:244/255.0 green:96/255.0 blue:45/255.0 alpha:1]


//标题颜色
#define myTextColorTitle [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:1]

//边框颜色
#define myBorderColor [[UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.4]CGColor]
#define myBorderColor2 [[UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.2]CGColor]

//边框宽度
#define myBorderWidth 0.6
//圆角大小
#define myCornerRadius 4
//分割线高度
#define myLineHight1 0.5

//tableView距离底部的高度
#define myTableViewMargin_ios6 50
#define myTableViewMargin_ios7 30


#define kCustom0xColor(rgbValue, alphaValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0x00FF00) >> 8))/255.0 blue:((float)(rgbValue & 0x0000FF))/255.0 alpha:alphaValue] // 16进制颜色
#define kColor_0x666666 kCustom0xColor(0x666666, 1.0f) // 0x66666颜色

#define kIOS7adp() if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {\
self.edgesForExtendedLayout = UIRectEdgeNone;\
self.extendedLayoutIncludesOpaqueBars = NO;\
self.modalPresentationCapturesStatusBarAppearance = NO;\
self.navigationController.navigationBar.translucent = NO;\
[self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], UITextAttributeTextColor, [UIColor whiteColor], UITextAttributeTextShadowColor,[UIFont fontWithName:@"HelveticaNeue-Bold" size:18.0], UITextAttributeFont,    nil]];\
}\



