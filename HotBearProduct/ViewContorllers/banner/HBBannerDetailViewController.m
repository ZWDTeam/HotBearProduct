//
//  HBBannerDetailViewController.m
//  HotBear
//
//  Created by Cody on 2017/5/24.
//  Copyright © 2017年 zhongweidi. All rights reserved.
//

#import "HBBannerDetailViewController.h"

@interface HBBannerDetailViewController ()<UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@end

@implementation HBBannerDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"活动详情";
    
    
    NSURLRequest * urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:self.model.activityPath]];
    
    [self.webView loadRequest:urlRequest];

}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;

}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView{
    [self.activityIndicator startAnimating];
}


- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [self.activityIndicator stopAnimating];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
