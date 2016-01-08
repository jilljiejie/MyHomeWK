//
//  AboutMeViewController.m
//  MyHomeWK
//
//  Created by qianfeng on 16/1/5.
//  Copyright © 2016年 wj. All rights reserved.
//

#import "AboutMeViewController.h"
#import "QRCodeGenerator.h"
@interface AboutMeViewController ()

@end

@implementation AboutMeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self settingNav];
    [self customUI];
    
}
#pragma mark---生成二维码---
-(void)customUI{
    //生成二维码
    UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 300, 300)];
    imageView.center=self.view.center;
    //imageSize:300表示清晰度
    imageView.image=[QRCodeGenerator qrImageForString:@"www.baidu.com" imageSize:400];
    
    [self.view addSubview:imageView];
}
#pragma mark--设置导航---
-(void)settingNav{
    self.titleLabel.text=@"关于我们";
    [self.leftButton setImage:[UIImage imageNamed:@"qrcode_scan_titlebar_back_nor@2x"] forState:UIControlStateNormal];
    [self setLeftButtonClick:@selector(leftButtonAction)];
}
-(void)leftButtonAction{
    [self.navigationController popViewControllerAnimated:YES];
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
