//
//  ViewController.m
//  ShiDianWebViewController
//
//  Created by 冯成林 on 2017/8/11.
//  Copyright © 2017年 冯成林. All rights reserved.
//

#import "ViewController.h"
#import "ShiDianWebViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
}

- (IBAction)btnAction:(id)sender {
    
    ShiDianWebViewController *wvc = [[ShiDianWebViewController alloc] init];
    wvc.url = @"https://www.jd.com/";
    
    wvc.requestBlock = ^(NSString *url) {
      
        NSLog(@"调用的：%@",url);
    };
    [self.navigationController pushViewController:wvc animated:YES];
    
}




@end
