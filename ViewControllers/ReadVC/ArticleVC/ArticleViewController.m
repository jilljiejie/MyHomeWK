//
//  ArticleViewController.m
//  LoveLife
//
//  Created by qianfeng on 15/12/30.
//  Copyright © 2015年 wj. All rights reserved.
//

#import "ArticleViewController.h"
#import "ReadModel.h"
#import "ArticalTableViewCell.h"
#import "ArticalDetailViewController.h"
@interface ArticleViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;
    int _page;//分页
}
@property(nonatomic,strong)NSMutableArray *dataSource;
@end

@implementation ArticleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
    [self createRefresh];
}
-(void)createRefresh{
    _tableView.header=[MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData) ];
    _tableView.footer=[MJRefreshAutoFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    [_tableView.header beginRefreshing];
}
//下拉刷新
-(void)loadNewData{
    _page=0;
    self.dataSource=[[NSMutableArray alloc]init];
    [self loadData];
}
//上拉加载
-(void)loadMoreData{
    _page++;
    [self loadData];
}
-(void)loadData{
    AFHTTPRequestOperationManager *manager=[AFHTTPRequestOperationManager manager];
    //手动设置格式,默认支持json
    manager.responseSerializer.acceptableContentTypes=[NSSet setWithObjects:@"text/html", nil];
    [manager GET:[NSString stringWithFormat:ARTICALURL,_page] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray *array=responseObject[@"data"];
        for (NSDictionary *dic in array) {
            ReadModel *model=[[ReadModel alloc]init];
            [model setValuesForKeysWithDictionary:dic];
            [self.dataSource addObject:model];
        }
        [_tableView reloadData];
        //结束刷新
        if (_page==0) {
            [_tableView.header endRefreshing];
        }
        else{
            [_tableView.footer endRefreshing];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}
#pragma mark---创建tableView----
-(void)createUI{
    
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_H) style:UITableViewStylePlain];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    [self.view addSubview:_tableView];
    
}
#pragma mark---tableView代理方法----
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *reuseID=@"reuse id";
    ArticalTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:reuseID];
    if (!cell) {
        cell=[[ArticalTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseID];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        
    }
    if (self.dataSource) {
        ReadModel *model=self.dataSource[indexPath.row];
        [cell refreshUI:model];
    }
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 150;
}
//给cell添加一个动画
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    //设置cell的动画效果为3D效果
    cell.layer.transform=CATransform3DMakeScale(0.1, 0.1, 1);
    [UIView animateWithDuration:0.5 animations:^{
        cell.layer.transform=CATransform3DMakeScale(1, 1, 1);
    }];
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ArticalDetailViewController *detail=[[ArticalDetailViewController alloc]init];
    //隐藏tabBar
    detail.hidesBottomBarWhenPushed=YES;
    ReadModel *model=self.dataSource[indexPath.row];
    detail.model=model;
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
