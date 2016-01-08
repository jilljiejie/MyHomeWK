//
//  LoginViewController.m
//  MyHomeWK
//
//  Created by qianfeng on 16/1/6.
//  Copyright © 2016年 wj. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSArray *array=@[@"sina",@"qq",@"weixin.jpg"];
    for (int i=0; i<array.count; i++) {
        UIButton *button=[FactoryUI createButtonWithFrame:CGRectMake(30+i*SCREEN_W/3, 200, 50, 50) title:nil titleColor:nil imageName:array[i] backgroundImageName:nil target:self selector:@selector(logoButtonAction:)];
        button.tag=300+i;
        [self.view addSubview:button];
    }
    [self createNav];
}
//设置导航
-(void)createNav{
    self.titleLabel.text=@"详情";
    [self.leftButton setImage:[UIImage imageNamed:@"qrcode_scan_titlebar_back_nor@2x"] forState:UIControlStateNormal];
    [self setLeftButtonClick:@selector(leftButtonClick)];
}
-(void)leftButtonClick{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)logoButtonAction:(UIButton *)button{
    switch (button.tag-300) {
        case 0:
        {
            UMSocialSnsPlatform *snsPlatform=[UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToSina];
            snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
                if (response.responseCode==UMSResponseCodeSuccess) {
                    UMSocialAccountEntity *snsAccount=[[UMSocialAccountManager socialAccountDictionary] valueForKey:UMShareToSina];
                    [self saveData:snsAccount];
                }
            });
        }
            break;
        case 1:
        {
            UMSocialSnsPlatform *snsPlatform=[UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToQQ];
            snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
                if (response.responseCode==UMSResponseCodeSuccess) {
                    UMSocialAccountEntity *snsAccount=[[UMSocialAccountManager socialAccountDictionary] valueForKey:UMShareToQQ];
                    [self saveData:snsAccount];
                }
            });
            
        }
            break;
        case 2:
        {
            UMSocialSnsPlatform *snsPlatform=[UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToWechatSession];
            snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
                if (response.responseCode==UMSResponseCodeSuccess) {
                    UMSocialAccountEntity *snsAccount=[[UMSocialAccountManager socialAccountDictionary] valueForKey:UMShareToWechatSession];
                    [self saveData:snsAccount];
                }
            });
        }
            break;
            
        default:
            break;
    }
}
-(void)saveData:(UMSocialAccountEntity *)snsAccount{
    NSUserDefaults *user=[NSUserDefaults standardUserDefaults];
    [user setObject:snsAccount.userName forKey:@"userName"];
    [user setObject:snsAccount.iconURL forKey:@"iconURL"];
    [user synchronize];
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
