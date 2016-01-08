//
//  AppDelegate.m
//  MyHomeWK
//
//  Created by qianfeng on 15/12/30.
//  Copyright © 2015年 wj. All rights reserved.
//

#import "AppDelegate.h"
#import "MyTabBarViewController.h"
#import "GuidePageView.h"
#import "MMDrawerController.h"
#import "LeftViewController.h"
//支持QQ
#import "UMSocialQQHandler.h"
//支持新浪
#import "UMSocialSinaHandler.h"
//支持微信
#import "UMSocialWechatHandler.h"
@interface AppDelegate ()
@property(nonatomic,strong)MyTabBarViewController *myTabBar;
@property(nonatomic,strong)GuidePageView *guidePageView;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window=[[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor=[UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    _myTabBar=[[MyTabBarViewController alloc]init];
    
    //添加引导页
    [self createGuidePage];
    
    //修改状态栏的颜色(第二种)
    [UIApplication sharedApplication].statusBarStyle=UIStatusBarStyleLightContent;
    
    //实例化
    LeftViewController *leftVC=[[LeftViewController alloc]init];
    MMDrawerController *drawerVC=[[MMDrawerController alloc]initWithCenterViewController:self.myTabBar leftDrawerViewController:leftVC];
    //设置抽屉打开和关闭的模式
    drawerVC.openDrawerGestureModeMask=MMOpenDrawerGestureModeAll;
    drawerVC.closeDrawerGestureModeMask=MMCloseDrawerGestureModeAll;
    //设置左页面打开之后的宽度
    drawerVC.maximumLeftDrawerWidth=SCREEN_W-100;
    
    
    self.window.rootViewController=drawerVC;
    
    //注册友盟分享
    [self addUMShare];
    

    return YES;
}
#pragma mark---添加友盟分享---
-(void)addUMShare{
    //注册友盟分享
    [UMSocialData setAppKey:APPKEY];
    //设置qq的appid,appkey,和url
    [UMSocialQQHandler setQQWithAppId:@"1104908293" appKey:@"MnGtpPN5AiB6MNvj" url:nil];
    //设置微信的appid,appSecret和url
    [UMSocialWechatHandler setWXAppId:@"wx12b249bcbf753e87" appSecret:@"0a9cd00c48ee47a9b23119086bcd3b30" url:nil];
    //打开微博的SSO开关
    [UMSocialSinaHandler openSSOWithRedirectURL:nil];
    //隐藏未安装的客户端(这一步主要针对qq和微信)
    [UMSocialConfig hiddenNotInstallPlatforms:@[UMShareToQQ,UMShareToQzone,UMShareToWechatTimeline,UMShareToWechatSession]];
    
}
-(void)createGuidePage{
    if (![[[NSUserDefaults standardUserDefaults]objectForKey:@"isRun"]boolValue]) {
        NSArray *imageArray=@[@"LaunchImage",@"welcome4",@"welcome3"];
        self.guidePageView=[[GuidePageView alloc]initWithFrame:self.window.bounds imageArray:imageArray];
        [self.myTabBar.view addSubview:self.guidePageView];
        //第一次运行完后进行记录
        [[NSUserDefaults standardUserDefaults] setObject:@YES forKey:@"isRun"];
    }
    [self.guidePageView.GoInButton addTarget:self action:@selector(GoInButtonClick) forControlEvents:UIControlEventTouchUpInside];
}
-(void)GoInButtonClick{
    [self.guidePageView removeFromSuperview];
}
-(void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification{
    //重置icon
    application.applicationIconBadgeNumber=0;
}
- (void)applicationWillEnterForeground:(UIApplication *)application {
    //重置icon
    application.applicationIconBadgeNumber=0;
}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}



- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
