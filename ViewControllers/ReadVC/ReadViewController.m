//
//  ReadViewController.m
//  LoveLife
//
//  Created by qianfeng on 15/12/29.
//  Copyright (c) 2015年 wj. All rights reserved.
//

#import "ReadViewController.h"
#import "ArticleViewController.h"
#import "RecordViewController.h"
@interface ReadViewController ()<UIScrollViewDelegate>
{
    UIScrollView *_scrollVeiw;
    UISegmentedControl *_segmentControl;
}
@end

@implementation ReadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setingNav];
    [self createUI];
}
-(void)setingNav{
    //创建segment
    _segmentControl=[[UISegmentedControl alloc]initWithFrame:CGRectMake(0, 0, 150, 25)];
    //插入标题
    [_segmentControl insertSegmentWithTitle:@"读美文" atIndex:0 animated:YES];
    [_segmentControl insertSegmentWithTitle:@"看语录" atIndex:1 animated:YES];
    //设置字体颜色
    _segmentControl.tintColor=[UIColor whiteColor];
    //设置默认选中读美文
    _segmentControl.selectedSegmentIndex=0;
    //响应方法
    [_segmentControl addTarget:self action:@selector(chageAction:) forControlEvents:UIControlEventValueChanged];
    
    self.navigationItem.titleView=_segmentControl;
}
#pragma mark---segment响应方法---
-(void)chageAction:(UISegmentedControl *)segment{
    _scrollVeiw.contentOffset=CGPointMake(segment.selectedSegmentIndex*SCREEN_W, 0);
}
#pragma mark---scrollView的协议方法---
//scrollView滚动时关联segment
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    _segmentControl.selectedSegmentIndex=scrollView.contentOffset.x/SCREEN_W;
}
#pragma mark---创建UI---
-(void)createUI{
    //创建scrollView
    _scrollVeiw=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_H)];
    //设置分页
    _scrollVeiw.pagingEnabled=YES;
    //设置代理
    _scrollVeiw.delegate=self;
    //设置contentSize
    _scrollVeiw.contentSize=CGSizeMake(SCREEN_W*2, 0);
    //隐藏指示条
    _scrollVeiw.showsHorizontalScrollIndicator=NO;
    _scrollVeiw.bounces=NO;
    _scrollVeiw.showsVerticalScrollIndicator=NO;
    [self.view addSubview:_scrollVeiw];
    //实例化子控制器
    ArticleViewController *arVC=[[ArticleViewController alloc]init];
    RecordViewController *reVC=[[RecordViewController alloc]init];
    NSArray *VCArray=@[arVC,reVC];
    //滚动框架实现
    int i=0;
    for (UIViewController *vc in VCArray) {
        vc.view.frame=CGRectMake(i*SCREEN_W, 0, SCREEN_W, SCREEN_H);
        [self addChildViewController:vc];
        [_scrollVeiw addSubview:vc.view];
        i++;
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
