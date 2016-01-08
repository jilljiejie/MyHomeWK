//
//  MusicViewController.m
//  LoveLife
//
//  Created by qianfeng on 15/12/29.
//  Copyright (c) 2015年 wj. All rights reserved.
//

#import "MusicViewController.h"
#import "MusicCollectionViewCell.h"
#import "MusicCollectionReusableView.h"
#import "MusicDetailViewController.h"
@interface MusicViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
{
    UICollectionView *_collectionView;
}
@property(nonatomic,strong)NSArray *nameArray;
@property(nonatomic,strong)NSArray *urlArray;
@property(nonatomic,strong)NSArray *imageArray;
@end

@implementation MusicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleLabel.text=@"音乐";
    [self initData];
    [self createCollectionView];
}
#pragma mark---初始化数组---
-(void)initData{
    self.nameArray = @[@"流行",@"新歌",@"华语",@"英语",@"日语",@"轻音乐",@"民谣",@"韩语",@"歌曲排行榜"];
    self.urlArray = @[liuxing,xinge,huayu,yingyu,riyu,qingyinyue,minyao,hanyu,paihangbang];
    self.imageArray = @[@"shili0",@"shili1",@"shili2",@"shili8",@"shili10",@"shili19",@"shili15",@"shili13",@"shili24"];
}
#pragma mark---创建collectionView---
-(void)createCollectionView{
    //创建网格布局对象
    UICollectionViewFlowLayout *flowLayOut=[[UICollectionViewFlowLayout alloc]init];
    //设置滚动方向
    flowLayOut.scrollDirection=UICollectionViewScrollDirectionVertical;
    //创建网格对象
    _collectionView=[[UICollectionView alloc]initWithFrame:self.view.bounds collectionViewLayout:flowLayOut];
    //设置代理
    _collectionView.delegate=self;
    _collectionView.dataSource=self;
    //设置背景颜色
    _collectionView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:_collectionView];
    //注册cell
    [_collectionView registerClass:[MusicCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    //注册header
    [_collectionView registerClass:[MusicCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"view"];
    //注册footer
    [_collectionView registerClass:[MusicCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"view"];
}
#pragma mark---collectionView协议方法----
//确定section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
//确定每个section对应的item的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.imageArray.count;
}
//创建cell
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    MusicCollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.imageView.image=[UIImage imageNamed:self.imageArray[indexPath.item]];
    cell.titleLabel.text=self.nameArray[indexPath.item];
    return cell;
}
//设置item的大小
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake((SCREEN_W-20)/2, 150);
}
//设置水平间距
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 5;
}
//设置垂直间距,默认的垂直和水平间距都是10
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 5;
}
//四周的边距
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(5, 5, 5, 5);
}
//设置header的大小
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeMake(60, 30);
}
//设置footer的大小
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    return CGSizeMake(60, 30);
}
-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    MusicCollectionReusableView *view=[collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"view" forIndexPath:indexPath];
    if (kind==UICollectionElementKindSectionHeader) {
        view.label.text=@"段头";
    }
    else{
        view.label.text=@"段尾";
    }
    return view;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    MusicDetailViewController *detail=[[MusicDetailViewController alloc]init];
    detail.urlString=self.urlArray[indexPath.item];
    detail.typeString=self.nameArray[indexPath.row];
    detail.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:detail animated:YES];
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
