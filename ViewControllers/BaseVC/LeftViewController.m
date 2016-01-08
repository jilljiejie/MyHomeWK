//
//  LeftViewController.m
//  LoveLife
//
//  Created by qianfeng on 15/12/29.
//  Copyright (c) 2015年 wj. All rights reserved.
//

#import "LeftViewController.h"

@interface LeftViewController ()
{
    UIImageView *_imageView;
    UILabel *_label;
}
@end

@implementation LeftViewController
-(void)viewWillAppear:(BOOL)animated{
    NSUserDefaults *user=[NSUserDefaults standardUserDefaults];
    [_imageView sd_setImageWithURL:[NSURL URLWithString:[user objectForKey:@"iconURL"]] placeholderImage:[UIImage imageNamed:@""]];
    _label.text=[user objectForKey:@"userName"];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=RGB(255, 156, 187, 1);
    //头像
    _imageView=[FactoryUI createImageViewWithFrame:CGRectMake((SCREEN_W-100-80)/2, 80, 80, 80) imageName:nil];
    _imageView.layer.cornerRadius=40;
    _imageView.layer.masksToBounds=YES;
    _imageView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:_imageView];
    //昵称
    _label=[FactoryUI createLabelWithFrame:CGRectMake(0, _imageView.frame.origin.y+_imageView.frame.size.height+10, SCREEN_W-100, 30) text:nil textColor:[UIColor whiteColor] font:[UIFont systemFontOfSize:18]];
    _label.textAlignment=NSTextAlignmentCenter;
    //    _nickNameLabel.backgroundColor=[UIColor orangeColor];
    [self.view addSubview:_label];

    
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
