//
//  FoodViewController.m
//  LoveLife
//
//  Created by qianfeng on 15/12/29.
//  Copyright (c) 2015年 wj. All rights reserved.
//

#import "FoodViewController.h"
#import "NBWaterFlowLayout.h"
#import "FoodCollectionViewCell.h"
#import "FoodTitleCollectionViewCell.h"
#import "FoodDetailViewController.h"
//视频播放
#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>
@interface FoodViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateWaterFlowLayout/*playVideoDelegate*/>
{
    UICollectionView *_collectionView;
    //分类id
    NSString *_categoryID;
    //标题
    NSString *_titleString;
    //指示条
    UIView *_lineView;
    //分页
    int _page;

}
//存放button的数组
@property(nonatomic,strong)NSMutableArray *buttonArray;
//数据源数组
@property(nonatomic,strong)NSMutableArray *dataSource;
@end

@implementation FoodViewController
-(void)viewWillAppear:(BOOL)animated{
    //设置默认选中第一个button
    for (UIButton *butt in self.buttonArray) {
        if (butt==self.buttonArray.firstObject) {
            butt.selected=YES;
        }
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self createNav];
    [self initData];
    [self createHeaderView];
    [self createCollectionView];
    [self createRefresh];
}
#pragma mark---创建刷新请求数据----
-(void)createRefresh{
    //下拉刷新
    _collectionView.header=[MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self loadNewData];
    }];
    //上拉加载
    _collectionView.footer=[MJRefreshAutoFooter footerWithRefreshingBlock:^{
        [self loadMoreData];
    }];
    [_collectionView.header beginRefreshing];
}
-(void)loadNewData{
    _page=0;
    self.dataSource=[[NSMutableArray alloc]init];
    [self loadData];
}
-(void)loadMoreData{
    _page++;
    [self loadData];
}
-(void)loadData{
    AFHTTPRequestOperationManager *manager=[AFHTTPRequestOperationManager manager];
    NSDictionary * dic = @{@"methodName": @"HomeSerial", @"page": [NSString stringWithFormat:@"%d",_page], @"serial_id": _categoryID, @"size": @"20"};
    [manager POST:FOODURL parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([responseObject[@"code"] intValue]==0) {
            //开始解析数据
            for (NSDictionary *dataDic in responseObject[@"data"][@"data"]) {
                //字典转模型
                FoodModel *model=[[FoodModel alloc]init];
                [model setValuesForKeysWithDictionary:dataDic];
                [self.dataSource addObject:model];
            }
            if (_page==0) {
                [_collectionView.header endRefreshing];
            }
            else{
                [_collectionView.footer endRefreshing];
            }
            [_collectionView reloadData];
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}
#pragma mark---创建collectioView---
-(void)createCollectionView{
    //创建网格布局对象
    NBWaterFlowLayout *flowLayout=[[NBWaterFlowLayout alloc]init];
    //设置列数
    flowLayout.numberOfColumns=2;
    //网格的大小
    flowLayout.itemSize=CGSizeMake((SCREEN_W-20)/2, 150);
    //设置代理
    flowLayout.delegate=self;
    //创建网格对象
    _collectionView=[[UICollectionView alloc]initWithFrame:CGRectMake(0, 45, SCREEN_W, SCREEN_H-40) collectionViewLayout:flowLayout];
    //设置代理
    _collectionView.delegate=self;
    _collectionView.dataSource=self;
    //设置背景颜色
    _collectionView.backgroundColor=[UIColor whiteColor];
    //注册cell
    [_collectionView registerClass:[FoodCollectionViewCell class] forCellWithReuseIdentifier:@"food"];
    [_collectionView registerClass:[FoodTitleCollectionViewCell class] forCellWithReuseIdentifier:@"foodTitle"];
    [self.view addSubview:_collectionView];
    
    
}
#pragma mark---collectionView的协议方法---
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataSource?self.dataSource.count+1:0;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.item==0) {
        //标题cell
        FoodTitleCollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"foodTitle" forIndexPath:indexPath];
        //赋值
        cell.titleLabel.text=_titleString;
        return cell;
    }
    else{
        //正文
        FoodCollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"food" forIndexPath:indexPath];
        //设置代理
//        cell.delegate=self;
        cell.playBlock=^(FoodModel *model){
            //初始化播放器
            AVPlayerViewController *playerVC=[[AVPlayerViewController alloc]init];
            //设置播放资源
            AVPlayer *avPlayer=[AVPlayer playerWithURL:[NSURL URLWithString:model.video]];
            playerVC.player=avPlayer;
            [self presentViewController:playerVC animated:YES completion:nil];
        };
        //赋值
        if (self.dataSource) {
            FoodModel *model=self.dataSource[indexPath.item-1];
            [cell refreshUI:model];
        }
        
        return cell;
    }
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    FoodDetailViewController *detail=[[FoodDetailViewController alloc]init];
    detail.hidesBottomBarWhenPushed=YES;
    FoodModel *model=self.dataSource[indexPath.item-1];
    
    detail.dishID=model.dishes_id;
    detail.video=model.video;
    detail.navTitle=model.title;
    [self.navigationController pushViewController:detail animated:YES];
}
-(CGFloat)collectionView:(UICollectionView *)collectionView waterFlowLayout:(NBWaterFlowLayout *)layout heightForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==0) {
        return 30;
    }
    else{
        return 170;
    }
}
#pragma mark---初始化数据---
-(void)initData{
    _categoryID=@"1";
    _titleString=@"家常菜";
}
////实现自定义的协议方法
//-(void)play:(FoodModel *)model{
////初始化播放器
//    AVPlayerViewController *playerVC=[[AVPlayerViewController alloc]init];
//    //设置播放资源
//    AVPlayer *avPlayer=[AVPlayer playerWithURL:[NSURL URLWithString:model.video]];
//    playerVC.player=avPlayer;
//    [self presentViewController:playerVC animated:YES completion:nil];
//}


#pragma mark---设置导航---
-(void)createNav{
    self.titleLabel.text=@"美食";
}
//创建头部按钮分类
-(void)createHeaderView{
    self.buttonArray=[[NSMutableArray alloc]init];
    NSArray *titleArray=@[@"家常菜",@"小炒",@"凉菜",@"烘焙"];
    UIView *bgView=[FactoryUI createViewWithFrame:CGRectMake(0, 0, SCREEN_W, 40)];
    bgView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:bgView];
    for (int i=0; i<4; i++) {
        UIButton *button=[FactoryUI createButtonWithFrame:CGRectMake(SCREEN_W/4*i, 0, SCREEN_W/4, 40) title:titleArray[i] titleColor:[UIColor grayColor] imageName:nil backgroundImageName:nil target:self selector:@selector(buttonAction:)];
        button.tag=100+i;
        //设置选中时的颜色
        [button setTitleColor:RGB(255, 156, 187, 1) forState:UIControlStateSelected];
        button.titleLabel.font=[UIFont systemFontOfSize:15];
        button.titleLabel.textAlignment=NSTextAlignmentCenter;
        [bgView addSubview:button];
        //创建的button添加到数组中
        
        [self.buttonArray addObject:button];
    }
    //下面的指示条
    _lineView=[FactoryUI createViewWithFrame:CGRectMake(0, 38, SCREEN_W/4, 2)];
    _lineView.backgroundColor=RGB(255, 156, 187, 1);
    [bgView addSubview:_lineView];
}
#pragma mark---点击四个小button的响应方法---
-(void)buttonAction:(UIButton *)button{
    [UIView animateWithDuration:0.3 animations:^{
        _lineView.frame=CGRectMake((button.tag-100)*SCREEN_W/4, 38, SCREEN_W/4, 2);
    }];
    for (UIButton *butt in self.buttonArray) {
        if (butt.selected==YES) {
            butt.selected=NO;
        }
        
    }
    button.selected=YES;

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
