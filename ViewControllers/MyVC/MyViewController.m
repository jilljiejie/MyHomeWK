//
//  MyViewController.m
//  LoveLife
//
//  Created by qianfeng on 15/12/29.
//  Copyright (c) 2015年 wj. All rights reserved.
//

#import "MyViewController.h"
#import "AppDelegate.h"
#import "AboutMeViewController.h"
#import "MyCollectionViewController.h"
#import "LoginViewController.h"
@interface MyViewController ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)UIImageView *headerImageView;
@property(nonatomic,strong)UIView *darkView;//夜间模式
@property(nonatomic,strong)NSArray *logoArray;//图标
@property(nonatomic,strong)NSArray *titleArray;//标题
@end

@implementation MyViewController
static float imageOriginHeight=260;
- (void)viewDidLoad {
    [super viewDidLoad];
    self.logoArray=@[@"iconfont-iconfontaixinyizhan",@"iconfont-lajitong",@"iconfont-yejianmoshi",@"iconfont-zhengguiicon40",@"iconfont-guanyu"];
    self.titleArray=@[@"我的收藏",@"清理缓存",@"夜间模式",@"推送消息",@"关于"];
    self.darkView=[[UIView alloc]initWithFrame:self.view.bounds];
    [self settingNav];
    [self createUI];
}
#pragma mark---设置导航---
-(void)settingNav{
    self.titleLabel.text=@"我的";
    [self.rightButton setTitle:@"登录" forState:UIControlStateNormal];
    [self setRightButtonClick:@selector(rightButtonAction)];
}
-(void)rightButtonAction{
    LoginViewController *login=[[LoginViewController alloc]init];
    login.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:login animated:YES];
}
#pragma mark--创建UI---
-(void)createUI{
    self.tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_H) style:UITableViewStylePlain];
    self.tableView.dataSource=self;
    self.tableView.delegate=self;
    self.tableView.tableFooterView=[[UIView alloc]init];
    [self.view addSubview:self.tableView];
    
    self.headerImageView=[FactoryUI createImageViewWithFrame:CGRectMake(0, -imageOriginHeight, SCREEN_W, imageOriginHeight) imageName:@"welcome1"];
    [self.tableView addSubview:self.headerImageView];
    self.tableView.contentInset=UIEdgeInsetsMake(imageOriginHeight, 0, 0, 0);
}
#pragma mark---tableView协议方法---
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.logoArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *reuseID=@"reuse id";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:reuseID];
    if (!cell) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseID];
        if (indexPath.row==0 || indexPath.row==1 || indexPath.row==4) {
            cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        }
        if (indexPath.row==2 || indexPath.row==3) {
            UISwitch *swi=[[UISwitch alloc]initWithFrame:CGRectMake(SCREEN_W-60, 5, 50, 30)];
            [swi addTarget:self action:@selector(swichValueChange:) forControlEvents:UIControlEventValueChanged];
            //设置颜色
            swi.onTintColor=[UIColor greenColor];
            swi.tag=indexPath.row;
            [cell.contentView addSubview:swi];
        }
    }
    cell.imageView.image=[UIImage imageNamed:self.logoArray[indexPath.row]];
    cell.textLabel.text=self.titleArray[indexPath.row];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case 0://我的收藏
        {
            MyCollectionViewController *mycollect=[[MyCollectionViewController alloc]init];
            mycollect.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:mycollect animated:YES];
        }
            break;
        case 1://清理缓存
        {
            [self folderSizeWithPath:[self getPath]];
        }
            break;
        case 4://关于（二维码）
        {
            AboutMeViewController *about=[[AboutMeViewController alloc]init];
            about.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:about animated:YES];
        }
            break;
            
        default:
            break;
    }
}
#pragma mark---清理缓存----
-(NSString *)getPath{
    NSString *path=NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject;
    return path;
}
-(CGFloat)folderSizeWithPath:(NSString *)path{
    //初始化一个文件管理类
    NSFileManager *fileManager=[NSFileManager defaultManager];
    //定义一个变量
    CGFloat folerSize=0.0;
    //加以判断，如果文件夹存在计算大小
    if ([fileManager fileExistsAtPath:path]) {
        //获取文件夹下的文件路径
        NSArray *fileArray=[fileManager subpathsAtPath:path];
        for (NSString *fileName in fileArray) {
            //获取子文件路径
            NSString *subFile=[path stringByAppendingPathComponent:fileName];
            long fileSize=[fileManager attributesOfItemAtPath:subFile error:nil].fileSize;
            folerSize+=fileSize/1024.0/1024.0;
        }
        //删除文件
        [self showAlert:folerSize];
        return folerSize;

    }
    return 0;

}
-(void)showAlert:(CGFloat)folderSize{
    if (folderSize>0.01) {
        //提示用户清除缓存
        UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"提示" message:[NSString stringWithFormat:@"缓存大小为%.2fM,是否清除？？",folderSize] preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action1=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        UIAlertAction *action2=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self clearCachFileWithPath:[self getPath]];
        }];
        [alert addAction:action1];
        [alert addAction:action2];
        [self presentViewController:alert animated:YES completion:nil];
    }
    else{
        //提示用户缓存已经清理过
        UIAlertView *alertView=[[UIAlertView alloc] initWithTitle:@"提示" message:@"缓存文件已被清除" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
    
    }
    
}
//删除文件
-(void)clearCachFileWithPath:(NSString *)path{
    NSFileManager *fileManager=[NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:path]) {
        NSArray *fileArray=[fileManager subpathsAtPath:path];
        for (NSString *fileName in fileArray) {
            if ([fileName hasSuffix:@"mp3"]) {
                NSLog(@"不删除MP3类型的文件");
                return;
            }
            NSString *filePath=[path stringByAppendingPathComponent:fileName];
            [fileManager removeItemAtPath:filePath error:nil];
        }
    }

}


#pragma mark---switch响应事件
-(void)swichValueChange:(UISwitch *)swit{
    if (swit.tag==2) {
        //夜间模式
        if (swit.on) {
            UIApplication *application=[UIApplication sharedApplication];
            AppDelegate *delegate=application.delegate;
            self.darkView.backgroundColor=[UIColor blackColor];
            self.darkView.alpha=0.3;
            //关掉交互
            self.darkView.userInteractionEnabled=NO;
            [delegate.window addSubview:self.darkView];
            
        }
        else{
            [self.darkView removeFromSuperview];
        }
    }
    else{
    //消息推送
        if (swit.on) {
            //创建本地推送
            [self createLocalNotification];
        }
        else{
            //取消本地推送
            [self cancelLocalNotification];
        }
    }
}
-(void)createLocalNotification{
    //解决iOS8以后本地推送无法接收到推送消息的问题
    //获取系统的版本号
    float systemVersion=[UIDevice currentDevice].systemVersion.floatValue;
    if (systemVersion>=8.0) {
        //设置推送消息的类型
        UIUserNotificationType type=UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound;
        //将类型添加到设置里
        UIUserNotificationSettings *settings=[UIUserNotificationSettings settingsForTypes:type categories:nil];
        //将设置内容注册到系统管理里面
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
        
    }
    //初始化本地推送
    UILocalNotification *localNotification=[[UILocalNotification alloc]init];
    //设置当前开始什么时候开始推送
    localNotification.fireDate=[NSDate dateWithTimeIntervalSinceNow:10];
    //设置需要推送的重复周期
    localNotification.repeatInterval=NSCalendarUnitDay;
    //设置推送的时区
    localNotification.timeZone=[NSTimeZone defaultTimeZone];
    //设置推送内容
    localNotification.alertBody=@"亲，您好久没来了哦，快来看看人家";
    //设置推送时的音效
    localNotification.soundName=@"";
    //设置提示的消息的个数
    localNotification.applicationIconBadgeNumber=1;
    //将推送任务添加到系统管理里面
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
    
}
-(void)cancelLocalNotification{
    //第一种：直接取消全部的推送任务
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    //第二种：取消指定条件下的推送任务
    NSArray *array=[[UIApplication sharedApplication] scheduledLocalNotifications];
    for (UILocalNotification *noti in array) {
        if ([noti.alertBody isEqualToString:@""]) {
            [[UIApplication sharedApplication] cancelLocalNotification:noti];
            //取消推送任务后重置icon的值
            [UIApplication sharedApplication].applicationIconBadgeNumber=0;
        }
    }
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
//实现思路：通过改变scrollView的偏移量（contentOffset）来改变图片的frame
    if (scrollView==self.tableView) {
        //获取scrollView的偏移量
        CGFloat yOffset=scrollView.contentOffset.y;
        CGFloat xOffset=(yOffset+imageOriginHeight)/2;
        if (yOffset<-imageOriginHeight) {
            CGRect rect=self.headerImageView.frame;
            //改变imageView的frame
            rect.origin.y=yOffset;
            rect.size.height=-yOffset;
            rect.origin.x=xOffset;
            rect.size.width=SCREEN_W+fabs(xOffset)*2;
            self.headerImageView.frame=rect;
        }
    }
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
