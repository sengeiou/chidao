

//
//  PayProtocolViewController.m
//  JincaiSDK
//
//  Created by zzp on 15/5/19.
//  Copyright (c) 2015年 com.hisuntech. All rights reserved.
//

#import "PayProtocolViewController.h"

@interface PayProtocolViewController ()<UIWebViewDelegate,NSURLConnectionDelegate>
{
    UIWebView *web;
    NSURLRequest *originRequest;
    UIActivityIndicatorView *_indicatorView;
    //重新加载
    UIButton *_updateBtn;
    NSURL *url;
}

@property(nonatomic,assign,getter =isAuthed)BOOL authed;
@property(nonatomic,assign)NSURL *currenURL;

@end

@implementation PayProtocolViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"协议";
    self.view.backgroundColor= [UIColor grayColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    web = [[UIWebView alloc] initWithFrame:CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width , [UIScreen mainScreen].bounds.size.height- 64)];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.url] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:5];
    web.delegate = self;
    [web loadRequest:request];
    
    
    
    web.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:web];
    
    _indicatorView = [[UIActivityIndicatorView alloc] init];
    _indicatorView.frame = CGRectMake(0, 0, 30, 30);
    _indicatorView.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2, [UIScreen mainScreen].bounds.size.height/2);
    _indicatorView.color = [UIColor redColor];
    _indicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
//    [_indicatorView startAnimating];
    [web addSubview:_indicatorView];
    //更新按钮
    _updateBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [_updateBtn setTitle:@"刷新" forState:UIControlStateNormal];
    _updateBtn.frame = CGRectMake(0,0, 100, 40);
    _updateBtn.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2, [UIScreen mainScreen].bounds.size.height/2);
    _updateBtn.hidden = YES;
    [_updateBtn addTarget:self action:@selector(updateClick:) forControlEvents:UIControlEventTouchUpInside];
    [web addSubview:_updateBtn];
    [self createBack];
}


-(NSString *)mimeType:(NSURL *)url
{
    //1.NSURLRequest
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    //2.NSURLConnection
    //NSURLResponse 就是服务器的响应 在它里面获取MIMEType
    //使用同步方法获取MIMEType
    NSURLResponse *response = nil;
    [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
    return response.MIMEType;
}



-(void)updateClick:(UIButton *)btn
{
    [web reload];
}

-(void)createBack
{
    UIBarButtonItem *back = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageWithContentsOfFile:ResourcePath(@"back_btn_n (2).png")] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleBordered target:self     action:@selector(backPop)];
    self.navigationItem.leftBarButtonItem = back;
}

- (void)backPop
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    NSString *path = ResourcePath(@"protocol.html");
    NSURL *nowUrl = [NSURL fileURLWithPath:path];
    NSURLRequest *request = [NSURLRequest requestWithURL:nowUrl];
    [web loadRequest:request];

}
-(void)webViewDidStartLoad:(UIWebView *)webView
{
    
}

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    [_indicatorView stopAnimating];
}





- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    
    NSString *scheme = [[request URL] scheme];
    //判断是不是https
    if ([scheme isEqualToString:@"https"]) {
        //如果是https:的话，那么就用NSURLConnection来重发请求。从而在请求的过程当中吧要请求的URL做信任处理。
        if (!self.isAuthed) {
            originRequest = request;
            NSURLConnection* conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
            [conn start];
            [webView stopLoading];
            return NO;
        }
    }
    
//    [self reflashButtonState];
//    [self freshLoadingView:YES];
    
    NSURL *theUrl = [request URL];
    self.currenURL = theUrl;
    return YES;
    
}

#pragma mark ================= NSURLConnectionDataDelegate
- (void)connection:(NSURLConnection *)connection willSendRequestForAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
{
    //开始转
    [_indicatorView startAnimating];
    
    if ([challenge previousFailureCount]== 0) {
        _authed = YES;
        //NSURLCredential 这个类是表示身份验证凭据不可变对象。凭证的实际类型声明的类的构造函数来确定。
        NSURLCredential* cre = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
        [challenge.sender useCredential:cre forAuthenticationChallenge:challenge];
    }else
    {
        [challenge.sender cancelAuthenticationChallenge:challenge];
    }
    
}


// Deprecated authentication delegates.
- (BOOL)connection:(NSURLConnection *)connection canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace
{
    return [protectionSpace.authenticationMethod
            isEqualToString:NSURLAuthenticationMethodServerTrust];
    return YES;
}

- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
{
    
    
    //    if (([challenge.protectionSpace.authenticationMethod
    //          isEqualToString:NSURLAuthenticationMethodServerTrust])) {
    //        if ([challenge.protectionSpace.host isEqualToString:@"111.200.87.69:8443/ccard"]) {
    //            NSLog(@"Allowing bypass...");
    //            NSURLCredential *credential = [NSURLCredential credentialForTrust:
    //                                           challenge.protectionSpace.serverTrust];
    //            [challenge.sender useCredential:credential
    //                 forAuthenticationChallenge:challenge];
    //        }
    //    }
    [challenge.sender continueWithoutCredentialForAuthenticationChallenge:challenge];
    
}

#pragma mark ================= NSURLConnectionDataDelegate <NSURLConnectionDelegate>

- (NSURLRequest *)connection:(NSURLConnection *)connection willSendRequest:(NSURLRequest *)request redirectResponse:(NSURLResponse *)response
{
    
    return request;
    
}
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    
    self.authed = YES;
    //webview 重新加载请求。
    [web loadRequest:originRequest];
    [connection cancel];
}





@end
