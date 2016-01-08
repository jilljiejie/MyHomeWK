//
//  MyCollectionViewController.m
//  MyHomeWK
//
//  Created by qianfeng on 16/1/6.
//  Copyright © 2016年 wj. All rights reserved.
//

#import "MyCollectionViewController.h"
#import "DBManager.h"
#import "ReadModel.h"
#import "ArticalDetailViewController.h"
#import "ArticalTableViewCell.h"
@interface MyCollectionViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;
}
@property(nonatomic,strong)NSMutableArray *dataSource;
@end

@implementation MyCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self settingNav];
    [self createTableView];
    [self loadData];
}
-(void)loadData{
    DBManager *manager=[DBManager defaultManager];
    NSArray *arr=[manager getData];
    self.dataSource=[NSMutableArray arrayWithArray:arr];
}
-(void)settingNav{
    self.titleLabel.text=@"我的收藏";
    [self.leftButton setImage:[UIImage imageNamed:@"qrcode_scan_titlebar_back_nor@2x"] forState:UIControlStateNormal];
    [self setLeftButtonClick:@selector(backButton)];
}
-(void)backButton{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)createTableView{
    _tableView=[[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    [self.view addSubview:_tableView];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *reuseID=@"reuse id";
    ArticalTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:reuseID];
    if (!cell) {
        cell=[[ArticalTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseID];
    }
    if (self.dataSource) {
        ReadModel *model=self.dataSource[indexPath.row];
        [cell refreshUI:model];
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ArticalDetailViewController *detail=[[ArticalDetailViewController alloc]init];
    ReadModel *model=self.dataSource[indexPath.row];
    detail.model=model;
    [self.navigationController pushViewController:detail animated:YES];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 150;
}
-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete;
}
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    //先删除数据库中的数据，然后删除界面cell，最后舒心数据
    DBManager *manager=[DBManager defaultManager];
    ReadModel *model=self.dataSource[indexPath.row];
    [manager deleteNameFromTable:model.dataID];
    
    //删除cell
    [self.dataSource removeObjectAtIndex:indexPath.row];
    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationBottom];
    //刷新界面
    [tableView reloadData];
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
