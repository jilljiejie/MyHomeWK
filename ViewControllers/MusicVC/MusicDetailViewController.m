//
//  MusicDetailViewController.m
//  MyHomeWK
//
//  Created by qianfeng on 16/1/5.
//  Copyright © 2016年 wj. All rights reserved.
//

#import "MusicDetailViewController.h"
#import "MBProgressHUD.h"
#import "MusicModel.h"
#import "MusicTableViewCell.h"
#import "MusicPlayViewController.h"
@interface MusicDetailViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    int _page;//分页
}
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSMutableArray *dataSource;//数据源
@property(nonatomic,strong)MBProgressHUD *hud;
//mp3文件
@property(nonatomic,strong)NSMutableArray *urlArray;
@end

@implementation MusicDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.tableView];
    [self settingNav];
    _page=0;
    [self loadData];
    [self createRefresh];
}
//上拉刷新
-(void)createRefresh{
    _tableView.footer=[MJRefreshAutoFooter footerWithRefreshingBlock:^{
        [self loadMoreData];
    }];
}
-(void)loadMoreData{
    _page++;
    [self loadData];
}
-(void)loadData{
//让活动指示器开始工作
    [self.hud show:YES];
    AFHTTPRequestOperationManager *manager=[AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes=[NSSet setWithObjects:@"text/html", nil];
    [manager GET:self.urlString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray *dataArr=responseObject[@"data"];
        for (NSDictionary *dataDic in dataArr) {
            //MP3文件
            [self.urlArray addObject:dataDic[@"url"]];
            
            MusicModel *model=[[MusicModel alloc]init];
            [model setValuesForKeysWithDictionary:dataDic];
            [self.dataSource addObject:model];
        }
        //隐藏活动指示器
        [self.hud hide:YES];
        
        //结束上拉加载
        [self.tableView.footer endRefreshing];
        [self.tableView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}
#pragma mark---设置导航----
-(void)settingNav{
    self.titleLabel.text=self.typeString;
    [self.leftButton setImage:[UIImage imageNamed:@"qrcode_scan_titlebar_back_nor@2x"] forState:UIControlStateNormal];
    [self setLeftButtonClick:@selector(leftButtonAction)];
}
-(void)leftButtonAction{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark---tableView协议方法---
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *reuseID=@"reuse id";
    MusicTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:reuseID];
    if (!cell) {
        cell=[[MusicTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseID];
    }
    MusicModel *model=self.dataSource[indexPath.row];
    [cell refreshUI:model];
//    self.tableView.separatorColor=RGB(255, 156, 187, 1);
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 140;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MusicPlayViewController *play=[[MusicPlayViewController alloc]init];
    play.hidesBottomBarWhenPushed=YES;
    //传值
    play.model=self.dataSource[indexPath.row];
    play.urlArray=self.urlArray;
    play.currentIndex=(int)indexPath.row;
    [self.navigationController pushViewController:play animated:YES];
}
#pragma mark---懒加载---
-(UITableView *)tableView{
    if (!_tableView) {
        _tableView=[[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
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
-(NSMutableArray *)urlArray{
    if (!_urlArray) {
        _urlArray=[[NSMutableArray alloc]init];
    }
    return _urlArray;
}
//活动指示器
-(MBProgressHUD *)hud{
    if (!_hud) {
        _hud=[[MBProgressHUD alloc]initWithView:self.view];
        //设置加载文字
        _hud.labelText=@"正在加载";
        //设置加载文字的大小
        _hud.labelFont=[UIFont systemFontOfSize:15];
        //设置加载文字的颜色
        _hud.labelColor=[UIColor whiteColor];
        //设置背景颜色
        self.hud.backgroundColor=[UIColor colorWithWhite:0 alpha:0.2];
        //设置中间指示器的颜色
        self.hud.activityIndicatorColor=[UIColor whiteColor];
        [self.view addSubview:_hud];
    }
    return _hud;
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
