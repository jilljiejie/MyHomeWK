//
//  FoodDetailViewController.m
//  MyHomeWK
//
//  Created by qianfeng on 16/1/4.
//  Copyright © 2016年 wj. All rights reserved.
//

#import "FoodDetailViewController.h"
#import "PlayerViewController.h"
#import "FoodDetailTableViewCell.h"
#import "FoodDetailModel.h"//分步
#import "FoodDescripModel.h"
#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>
@interface FoodDetailViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UIView *_mainBgView;
    //背景大图
    UIImageView *_mainImageView;
    //菜品名称
    UILabel *_titleLabel;
    //详情描述
    UILabel *_detailLabel;
    
}
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSMutableArray *dataSource;

@end

@implementation FoodDetailViewController
-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden=YES;
}
-(void)viewWillDisappear:(BOOL)animated{
    self.navigationController.navigationBarHidden=NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.tableView];
    [self createTableViewHeader];
    [self loadData];
}
-(void)loadData{
    self.dataSource=[[NSMutableArray alloc]init];
    AFHTTPRequestOperationManager *manager=[AFHTTPRequestOperationManager manager];
    NSDictionary * dic = @{@"dishes_id": self.dishID, @"methodName": @"DishesView"};
    [manager POST:FOODURL parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([responseObject[@"code"] intValue]==0) {
            NSDictionary *dataDic=responseObject[@"data"];
            FoodDescripModel *desModel=[[FoodDescripModel alloc]init];
            [desModel setValuesForKeysWithDictionary:dataDic];
            
            NSArray *stepArray=dataDic[@"step"];
            for (NSDictionary *stepDic in stepArray) {
                FoodDetailModel *model=[[FoodDetailModel alloc]init];
                [model setValuesForKeysWithDictionary:stepDic];
                [self.dataSource addObject:model];
            }
            [self refreshUI:desModel];
            [_tableView reloadData];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}
-(void)refreshUI:(FoodDescripModel *)model{
    [_mainImageView sd_setImageWithURL:[NSURL URLWithString:model.image] placeholderImage:[UIImage imageNamed:@""]];
    _titleLabel.text=model.dashes_name;
    _detailLabel.text=model.material_desc;
    for (int i=0; i<3; i++) {
        UILabel *label=(UILabel *)[self.view viewWithTag:100+i];
        if (i==0) {
            label.text=[NSString stringWithFormat:@"难度:%@",model.hard_level];
        }
        else if (i==1){
        label.text=[NSString stringWithFormat:@"时间:%@",model.cooking_time];
        }
        else{
        label.text=[NSString stringWithFormat:@"口味:%@",model.taste];
        }
    }
}
-(void)createTableViewHeader{
    _mainBgView=[FactoryUI createViewWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_H+64)];
    _mainBgView.backgroundColor=[UIColor whiteColor];
    //背景大图
    _mainImageView=[FactoryUI createImageViewWithFrame:CGRectMake(0, 0, SCREEN_W, (SCREEN_H+64)/3*2) imageName:nil];
    _mainImageView.userInteractionEnabled=YES;
    [_mainBgView addSubview:_mainImageView];
    //返回按钮
    UIButton *backButton=[FactoryUI createButtonWithFrame:CGRectMake(10, 10, 40, 40) title:nil titleColor:nil imageName:@"iconfont-back" backgroundImageName:nil target:self selector:@selector(bacKButtonAction)];
    [_mainImageView addSubview:backButton];
    //播放按钮
    UIButton *playButton=[FactoryUI createButtonWithFrame:CGRectMake(0, 0, 60, 60) title:nil titleColor:nil imageName:@"iconfont-bofang-3" backgroundImageName:nil target:self selector:@selector(playButtonAction)];
    playButton.center=_mainImageView.center;
    [_mainImageView addSubview:playButton];
    //下面bottomView
    UIView *bottomView=[FactoryUI createViewWithFrame:CGRectMake(0,(SCREEN_H+64)/3*2-30 , SCREEN_W, 30)];
    bottomView.backgroundColor=[UIColor blackColor];
    bottomView.alpha=0.3;
    [_mainImageView addSubview:bottomView];
    NSArray *titleArray=@[@"食材准备",@"制作步骤",@"下载"];
    NSArray *imageArray=@[@"iconfont-bofang-4",@"iconfont-bofang-4",@"iconfont-xiazai"];
    for (int i=0; i<3; i++) {
        UIButton *button=[FactoryUI createButtonWithFrame:CGRectMake(20+(20+(SCREEN_W-80)/3)*i, 5, (SCREEN_W-80)/3, 20) title:titleArray[i] titleColor:[UIColor whiteColor] imageName:imageArray[i] backgroundImageName:nil target:self selector:@selector(buttonAction:)];
        [bottomView addSubview:button];
    }
    //名称
    _titleLabel=[FactoryUI createLabelWithFrame:CGRectMake(0, _mainImageView.frame.origin.y+_mainImageView.frame.size.height+15, SCREEN_W-20, 20) text:nil textColor:[UIColor darkGrayColor] font:[UIFont systemFontOfSize:18]];
    [_mainBgView addSubview:_titleLabel];
    //详情描述
    _detailLabel=[FactoryUI createLabelWithFrame:CGRectMake(10, _titleLabel.frame.origin.y+_titleLabel.frame.size.height+10, SCREEN_W-20, 50) text:nil textColor:[UIColor lightGrayColor] font:[UIFont systemFontOfSize:15]];
    _detailLabel.numberOfLines=0;
    _detailLabel.lineBreakMode=NSLineBreakByCharWrapping;
    [_mainBgView addSubview:_detailLabel];
    //难度，时间，口味
    NSArray *imageArr=@[@"矢量智能对象难易度@2x",@"矢量智能对象时长@3x",@"矢量智能对象口味@2x"];
    for (int i=0; i<3; i++) {
        UIImageView *imageView=[FactoryUI createImageViewWithFrame:CGRectMake(70+(70+(SCREEN_W-70*4)/3)*i, _detailLabel.frame.origin.y+_detailLabel.frame.size.height+10, (SCREEN_W-70*4)/3, 40) imageName:imageArr[i]];
        [_mainBgView addSubview:imageView];
        
        UILabel *label=[FactoryUI createLabelWithFrame:CGRectMake(50+(50+(SCREEN_W-50*4)/3)*i, imageView.frame.origin.y+imageView.frame.size.height+10, (SCREEN_W-50*4)/3, 20) text:nil textColor:[UIColor lightGrayColor] font:[UIFont systemFontOfSize:12]];
        label.textAlignment=NSTextAlignmentCenter;
        label.tag=100+i;
        [_mainBgView addSubview:label];
        
    }
    //设置tableHeaderView
    _tableView.tableHeaderView=_mainBgView;

}
#pragma mark---按钮的响应方法---
-(void)bacKButtonAction{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)playButtonAction{
    //初始化播放器
    PlayerViewController *playerVC=[[PlayerViewController alloc]init];
    //设置播放源
    AVPlayer *avPlayer=[AVPlayer playerWithURL:[NSURL URLWithString:self.video]];
    playerVC.player=avPlayer;
    [self presentViewController:playerVC animated:YES completion:nil];
}
-(void)leftButtonAction{
[self.navigationController popViewControllerAnimated:YES];
}
-(void)buttonAction:(UIButton *)button{

}
#pragma mark---tableView协议方法---
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    FoodDetailTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell=[[FoodDetailTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    if (self.dataSource) {
        FoodDetailModel *model=self.dataSource[indexPath.row];
        [cell refreshUI:model indexPath:indexPath];
    }
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 200;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view=[FactoryUI createViewWithFrame:CGRectMake(0, 0, SCREEN_W, 30)];
    UILabel *label=[FactoryUI createLabelWithFrame:CGRectMake(0, 0, SCREEN_W, 30) text:@"制作步骤" textColor:[UIColor blackColor] font:[UIFont systemFontOfSize:20]];
    label.textAlignment=NSTextAlignmentCenter;
    [view addSubview:label];
    return view;
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView==_tableView) {
        if (scrollView.contentOffset.y>=SCREEN_H+64) {
            [UIView animateWithDuration:0.3 animations:^{
                _tableView.frame=CGRectMake(0, 0, SCREEN_W, SCREEN_H);
                self.navigationController.navigationBarHidden=NO;
            }];
            //设置导航的标题
            UILabel *titleLabel=[FactoryUI createLabelWithFrame:CGRectMake(0, 0, 100, 30) text:self.navTitle textColor:[UIColor whiteColor] font:[UIFont systemFontOfSize:20]];
            titleLabel.textAlignment=NSTextAlignmentCenter;
            self.navigationItem.titleView=titleLabel;
            //设置返回按钮
            [self.leftButton setImage:[UIImage imageNamed:@"iconfont-fanhui"] forState:UIControlStateNormal];
            [self setLeftButtonClick:@selector(leftButtonAction)];
            
        }
        else{
            [UIView animateWithDuration:0.3 animations:^{
                _tableView.frame=CGRectMake(0, 0, SCREEN_W, SCREEN_H+64);
                self.navigationController.navigationBarHidden=YES;
            }];
        }
    }
}
#pragma mark---懒加载（重写get方法）---
-(UITableView *)tableView{
    if (!_tableView) {
        _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_H+64) style:UITableViewStylePlain];
        _tableView.dataSource=self;
        _tableView.delegate=self;
    }
    return _tableView;
}
-(NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource=[[NSMutableArray alloc]init];
    }
    return _dataSource;
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
