//
//  MusicPlayViewController.m
//  MyHomeWK
//
//  Created by qianfeng on 16/1/5.
//  Copyright © 2016年 wj. All rights reserved.
//

#import "MusicPlayViewController.h"
#import <AVFoundation/AVFoundation.h>
@interface MusicPlayViewController ()<AVAudioPlayerDelegate>
@property(nonatomic,strong)UISlider *slider;//指示条
@property(nonatomic,strong)AVAudioPlayer *player;
@property(nonatomic,strong)NSTimer *timer;//计时器
@end

@implementation MusicPlayViewController
#pragma mark---切换导航----
//隐藏导航
-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden=YES;
}
-(void)viewWillDisappear:(BOOL)animated{
    self.navigationController.navigationBarHidden=NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    //设置背景图片
    self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"15f81d189d5044b8ff2f825c0cbf1d24.jpg"]];
    [self customUI];
    [self createPlayer];
    //创建计时器
    self.timer=[NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(sliderValueChange) userInfo:nil repeats:YES];
    
    //设置后台播放模式,AVAudioSession指的是音频会话
    AVAudioSession *session=[AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategoryPlayback error:nil];
    //在后台保持活跃
    [session setActive:YES error:nil];
    //拔出耳机之后暂停播放，通过观察者监测
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(isHasDevice:) name:AVAudioSessionRouteChangeNotification object:nil];
    
}
#pragma mark---监听是否有耳机
-(void)isHasDevice:(NSNotification *)noti{
    NSDictionary *dic=noti.userInfo;
    int changeReason=[dic[AVAudioSessionRouteChangeReasonKey]intValue];
    if (changeReason==AVAudioSessionRouteChangeReasonOldDeviceUnavailable) {
        AVAudioSessionRouteDescription *routeDescription=dic[AVAudioSessionRouteChangePreviousRouteKey];
        AVAudioSessionPortDescription *portDescription= [routeDescription.outputs firstObject];
        //原设备为耳机则暂停
        if ([portDescription.portType isEqualToString:@"Headphones"]) {
            if ([_player isPlaying])
            {
                [_player pause];
                self.timer.fireDate=[NSDate distantFuture];
            }
        }
    }

}
#pragma mark---创建UI界面---
-(void)customUI{
    //标题
    UILabel *titleLabel=[FactoryUI createLabelWithFrame:CGRectMake(50, 30, SCREEN_W-100, 30) text:self.model.title textColor:[UIColor whiteColor] font:[UIFont systemFontOfSize:20]];
    titleLabel.textAlignment=NSTextAlignmentCenter;
    [self.view addSubview:titleLabel];
    //返回按钮
    UIButton *backButton=[FactoryUI createButtonWithFrame:CGRectMake(10, 30, 30, 30) title:nil titleColor:nil imageName:@"qrcode_scan_titlebar_back_nor@2x" backgroundImageName:nil target:self selector:@selector(backButtonAction)];
    [self.view addSubview:backButton];
    //演唱者
    UILabel *songerLabel=[FactoryUI createLabelWithFrame:CGRectMake(SCREEN_W-200, backButton.frame.origin.y+backButton.frame.size.height+10, 180, 30) text:[NSString stringWithFormat:@"演唱者:%@",self.model.artist] textColor:[UIColor whiteColor] font:[UIFont systemFontOfSize:15]];
    songerLabel.textAlignment=NSTextAlignmentRight;
    [self.view addSubview:songerLabel];
    //图片
    UIImageView *imageView=[FactoryUI createImageViewWithFrame:CGRectMake(20, songerLabel.frame.origin.y+songerLabel.frame.size.height+30, SCREEN_W-40, SCREEN_W-20) imageName:@""];
    [imageView sd_setImageWithURL:[NSURL URLWithString:self.model.coverURL] placeholderImage:[UIImage imageNamed:@"special_palcehold"]];
    [self.view addSubview:imageView];
    //指示条
    self.slider=[[UISlider alloc]initWithFrame:CGRectMake(20, imageView.frame.origin.y+imageView.frame.size.height+20, SCREEN_W-40, 20)];
    //设置初始的value
    self.slider.value=0;
    [self.slider addTarget:self action:@selector(valueChange:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:self.slider];
    //创建按钮
    NSArray *buttonImageArray=@[@"iconfont-bofangqishangyiqu",@"iconfont-musicbofang",@"iconfont-bofangqixiayiqu"];
    for (int i=0; i<3; i++) {
        UIButton *button=[FactoryUI createButtonWithFrame:CGRectMake((40+(SCREEN_W-3*40)/4)*i+(SCREEN_W-3*40)/4, _slider.frame.origin.y+_slider.frame.size.height+10, 40, 40) title:nil titleColor:nil imageName:buttonImageArray[i] backgroundImageName:nil target:self selector:@selector(playButtonAction:)];
        button.tag=1000+i;
        [self.view addSubview:button];
    }
}
#pragma mark---创建音乐播放器---
-(void)createPlayer{
    //创建队列组
    dispatch_group_t group=dispatch_group_create();
    //创建队列
    dispatch_queue_t queue=dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    //启动异步方法
    dispatch_group_async(group, queue, ^{
        //NSURL创建,播放本地的音频url
        //    _player=[[AVAudioPlayer alloc]initWithContentsOfURL:[NSURL URLWithString:@""] error:nil];
        //NSData创建音乐播放器
        self.player=[[AVAudioPlayer alloc]initWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.urlArray[_currentIndex]]] error:nil];
        //设置代理
        self.player.delegate=self;
        //设置播放音量
        self.player.volume=0.5;
        //设置循环次数
        self.player.numberOfLoops=-1;//负数表示无限循环播放，0只播放一次，正数是几就播放几次
        _player.currentTime=0;
        self.player.currentTime=0;
//        self.player.isPlaying//是否正在播放
//        self.player.numberOfChannels//声道数
//        self.player.duration//持续时间
        //预播放，将播放资源添加到播放器中，用播放器自己分配播放队列
        [self.player prepareToPlay];
        
//        [self.player play];
    });
}
#pragma mark--按钮的响应事件----
-(void)backButtonAction{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark---指示条---
//slider值发生变化时
-(void)valueChange:(UISlider *)slider{
    self.player.currentTime=slider.value*self.player.duration;
}
#pragma mark---定时器监测slider的value
-(void)sliderValueChange{
    self.slider.value=self.player.currentTime/self.player.duration;
}
//播放等按钮的响应事件
-(void)playButtonAction:(UIButton *)button{
    switch (button.tag-1000) {
        case 0:
        {
        //上一曲
            //停掉当前的
            [self.player stop];
            if (self.currentIndex==0) {
                self.currentIndex=(int)self.urlArray.count-1;
            }
            _currentIndex--;
            [self createPlayer];
            [self.player play];
        }
            break;
        case 1:
        {
        //播放、暂停
            //判断如果正在播放，则暂停，改变按钮的状态为播放
            if (self.player.isPlaying) {
                [button setImage:[UIImage imageNamed:@"iconfont-musicbofang"] forState:UIControlStateNormal];
                //暂停
                [self.player pause];
                //播放暂停时定时器也暂停
                [self.timer setFireDate:[NSDate distantFuture]];//计时器暂停
            }
            else{
                [button setImage:[UIImage imageNamed:@"iconfont-zanting"] forState:UIControlStateNormal];
                [self.player play];
                //重启计时器
                [self.timer setFireDate:[NSDate distantPast]];
//                [self.timer invalidate];//销毁计时器，以后无法恢复
            }
        }
            break;
        case 2:
        {
        //下一曲
            //先停掉当前面的
            [self.player stop];
            //如果已经是最后一曲就播放第一曲
            if (self.currentIndex==self.urlArray.count-1) {
                self.currentIndex=0;
            }
            self.currentIndex++;
            [self createPlayer];
            [self.player play];
        }
            break;
            
        default:
            break;
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
