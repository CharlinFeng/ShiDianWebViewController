//
//  ShiDianWebViewController.m
//  ShiDianWebViewController
//
//  Created by 冯成林 on 2017/8/11.
//  Copyright © 2017年 冯成林. All rights reserved.
//

#import "ShiDianWebViewController.h"
#import <WebKit/WebKit.h>
#import "CALayer+Transition.h"
#import "CoreIV.h"

@interface ShiDianWebViewController ()<WKNavigationDelegate>

@property (nonatomic,strong) WKWebView *webview;

@property (nonatomic,copy) NSString *currentURL;

@end

@implementation ShiDianWebViewController


- (void)viewDidLoad {
    [super viewDidLoad];

    [self.view addSubview:self.webview];
    
    self.webview.layer.borderColor = [UIColor redColor].CGColor;
    self.webview.layer.borderWidth = 2;
    
    [self loadURL:nil];

}

-(void)loadURL:(NSString *)url_load{
    
    NSString *url_load_p = url_load == nil ? self.url : url_load;
    NSURL *u = [NSURL URLWithString:url_load_p];
    NSURLRequest *request = [NSURLRequest requestWithURL:u];
    [self.webview loadRequest:request];


}


-(void)viewDidLayoutSubviews {

    self.webview.frame = self.view.bounds;
}

-(WKWebView *)webview {

    if (_webview == nil) {
    
        _webview = [[WKWebView alloc] init];
        _webview.navigationDelegate = self;
    }

    return _webview;
}





/** 代理方法专区 */



// 在发送请求之前，决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler{
    
    NSString *currentURL_temp = [navigationAction.request.URL.absoluteString stringByRemovingPercentEncoding];
    
    if([currentURL_temp isEqualToString:@"about:blank"]) {
        decisionHandler(WKNavigationActionPolicyCancel);
        return;
    }
    
    if([currentURL_temp isEqualToString:@"https://so.m.jd.com/solocalocalstorage.html"]) {
        decisionHandler(WKNavigationActionPolicyCancel);
        return;
    }
    
    decisionHandler(WKNavigationActionPolicyAllow);
    
    
    [CoreIV showWithType:IVTypeLoad view:self.view msg:nil failClickBlock:^{
        
        NSLog(@"加载失败1");
        [self loadURL:self.currentURL];
    }];
    
    if (self.currentURL == nil || [self.currentURL isEqualToString:self.url]) {
        
    }else {
        
        [self.view transitionWithAnimType:TransitionAnimTypePush subType:TransitionSubtypeRight curve:TransitionCurveEaseOut duration:0.45];
    }
    
    
    
    
    self.currentURL = currentURL_temp;
    
    
    //执行block
    if(self.requestBlock != nil) {
        
        self.requestBlock(self.currentURL);
    }
    
    
    NSLog(@"在发送请求之前，决定是否跳转:%@",currentURL_temp);
}





// 页面开始加载时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation{
    

    
}




// 在收到响应后，决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler{
    
    decisionHandler(WKNavigationResponsePolicyAllow);
    
    NSLog(@"在收到响应后，决定是否跳转");
}



// 当内容开始返回时调用
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation{
    
    NSLog(@"当内容开始返回时调用");
    [CoreIV dismissFromView:self.view animated:YES];
}

// 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    [CoreIV dismissFromView:self.view animated:YES];
}

// 页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation{
    
    [CoreIV showWithType:IVTypeError view:self.view msg:@"加载失败" failClickBlock:^{
        NSLog(@"加载失败2");
    }];
}


// 接收到服务器跳转请求之后调用
- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(WKNavigation *)navigation{
    
    NSLog(@"接收到服务器跳转请求之后调用");
}



@end
