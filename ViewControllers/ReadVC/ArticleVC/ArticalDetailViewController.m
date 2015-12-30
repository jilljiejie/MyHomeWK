//
//  ArticalDetailViewController.m
//  LoveLife
//
//  Created by qianfeng on 15/12/30.
//  Copyright © 2015年 wj. All rights reserved.
//

#import "ArticalDetailViewController.h"

@interface ArticalDetailViewController ()

@end

@implementation ArticalDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self settingNav];
    [self createUI];
}
-(void)createUI{
    UIWebView *webView=[[UIWebView alloc]initWithFrame:self.view.bounds];
    //loadHTMLString加载的是类似标签式的字符串，loadRequest加载的是网址
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:ARTICALDETAILURL,self.model.dataID]]]];
    //使得webView适应屏幕大小
    webView.scalesPageToFit=YES;
    [self.view addSubview:webView];
    
    //webView和javascript的交互
}
-(void)settingNav{
self.titleLabel.text=@"详情";
    [self.leftButton setImage:[UIImage imageNamed:@"qrcode_scan_titlebar_back_nor@2x"] forState:UIControlStateNormal];
    [self.rightButton setImage:[UIImage imageNamed:@"iconfont-fenxiang"] forState:UIControlStateNormal];
    [self setLeftButtonClick:@selector(leftAction)];
    [self setRightButtonClick:@selector(rightAcrion)];
}
#pragma mark---按钮的响应事件---
-(void)leftAction{
    [self.navigationController popViewControllerAnimated:YES];
}
//分享
-(void)rightAcrion{
    //下载网络图片
    UIImage *image=[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.model.pic]]];
    [UMSocialSnsService presentSnsIconSheetView:self appKey:APPKEY shareText:[NSString stringWithFormat:ARTICALDETAILURL,self.model.dataID] shareImage:image shareToSnsNames:@[UMShareToSina,UMShareToQQ,UMShareToQzone,UMShareToWechatTimeline,UMShareToWechatSession] delegate:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
