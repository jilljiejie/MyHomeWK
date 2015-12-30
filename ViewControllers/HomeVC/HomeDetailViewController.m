//
//  HomeDetailViewController.m
//  LoveLife
//
//  Created by qianfeng on 15/12/30.
//  Copyright © 2015年 wj. All rights reserved.
//

#import "HomeDetailViewController.h"

@interface HomeDetailViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;
    //头部图片
    UIImageView *_headerImageView;
    //头部文字
    UILabel *_headerTitleLabel;
}
@property(nonatomic,strong)NSMutableArray *dataSource;//tableView的数据
//头部视图的数据
@property(nonatomic,strong)NSMutableDictionary *dataDic;
@end

@implementation HomeDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createNav];
    [self createUI];
    [self loadData];
}
#pragma mark---请求数据---
-(void)loadData{
    //初始化
    self.dataDic=[[NSMutableDictionary alloc]init];
    self.dataSource=[[NSMutableArray alloc]init];
    
    AFHTTPRequestOperationManager *manager=[AFHTTPRequestOperationManager manager];
//    manager.responseSerializer=[AFHTTPResponseSerializer serializer];
    [manager GET:[NSString stringWithFormat:HOMEDETAIL,[self.dataID intValue]] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //头部视图数据
        self.dataDic=responseObject[@"data"];
        //tableView数据
        self.dataSource=self.dataDic[@"product"];
        //数据请求完之后刷新页面
        [self reloadHeaderView];
        [_tableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}
-(void)reloadHeaderView{
    [_headerImageView sd_setImageWithURL:[NSURL URLWithString:self.dataDic[@"pic"]] placeholderImage:[UIImage imageNamed:@""]];
    _headerTitleLabel.text=self.dataDic[@"desc"];
}
#pragma mark---设置导航---
-(void)createNav{
    self.titleLabel.text=@"详情";
    [self.leftButton setImage:[UIImage imageNamed:@"qrcode_scan_titlebar_back_nor@2x"] forState:UIControlStateNormal];
    [self setLeftButtonClick:@selector(leftButtonClick)];
}
-(void)leftButtonClick{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark---创建UI----
-(void)createUI{
//tableView
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_H) style:UITableViewStylePlain];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    [self.view addSubview:_tableView];
    //头部控件
    _headerImageView=[FactoryUI createImageViewWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_H/3) imageName:nil];
    _headerTitleLabel=[FactoryUI createLabelWithFrame:CGRectMake(10, _headerImageView.frame.size.height-40, SCREEN_W-20, 40) text:nil textColor:[UIColor whiteColor] font:[UIFont systemFontOfSize:10]];
    _headerTitleLabel.numberOfLines=0;
    [_headerImageView addSubview:_headerTitleLabel];
    
    _tableView.tableHeaderView=_headerImageView;
    
}
#pragma mark---tableView代理方法---
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataSource.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *arr=self.dataSource[section][@"pic"];
    return arr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *reuseID=@"reuse id";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:reuseID];
    if (!cell) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseID];
        UIImageView *imageView=[FactoryUI createImageViewWithFrame:CGRectMake(10, 10, SCREEN_W-20, 200) imageName:nil];
        imageView.tag=10;
        [cell.contentView addSubview:imageView];
        //去掉点击cell时的灰色
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    //赋值
    UIImageView *imageView=(UIImageView *)[cell.contentView viewWithTag:10];
    if (self.dataSource) {
        NSArray *sectionArray=self.dataSource[indexPath.section][@"pic"];
        [imageView sd_setImageWithURL:[NSURL URLWithString:sectionArray[indexPath.row][@"pic"]] placeholderImage:[UIImage imageNamed:@""]];
    }
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 220;
}
//每个section的header
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *bgView=[FactoryUI createViewWithFrame:CGRectMake(0, 0, SCREEN_W, 60)];
    bgView.backgroundColor=[UIColor whiteColor];
    //索引
    UILabel *indexLabel=[FactoryUI createLabelWithFrame:CGRectMake(10, 10, 40, 40) text:[NSString stringWithFormat:@"%ld",section+1] textColor:RGB(255, 156, 187, 1) font:[UIFont systemFontOfSize:16]];
    indexLabel.textAlignment=NSTextAlignmentCenter;
    indexLabel.layer.borderColor=RGB(255, 156, 187, 1).CGColor;
    indexLabel.layer.borderWidth=2;
    indexLabel.layer.cornerRadius=10;
    indexLabel.layer.masksToBounds=YES;
    [bgView addSubview:indexLabel];
    //标题
    UILabel *titleLabel=[FactoryUI createLabelWithFrame:CGRectMake(indexLabel.frame.size.width+indexLabel.frame.origin.x+10, 10, SCREEN_W-100, 40) text:nil textColor:[UIColor darkGrayColor] font:[UIFont systemFontOfSize:18]];
    titleLabel.textAlignment=NSTextAlignmentLeft;
    [bgView addSubview:titleLabel];
    //价钱
    UIButton *priceButton=[FactoryUI createButtonWithFrame:CGRectMake(SCREEN_W-70, 10, 60, 40) title:nil titleColor:RGB(255, 156, 187, 1) imageName:nil backgroundImageName:nil target:self selector:@selector(buttonAction)];
    [bgView addSubview:priceButton];
    //赋值
    titleLabel.text=self.dataSource[section][@"title"];
    [priceButton setTitle:[NSString stringWithFormat:@"￥%@",self.dataSource[section][@"price"]] forState:UIControlStateNormal];
    return bgView;
}
-(void)buttonAction{

}
//设置header的高度
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 60;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
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
