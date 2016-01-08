//
//  MusicCollectionViewCell.m
//  MyHomeWK
//
//  Created by qianfeng on 16/1/5.
//  Copyright © 2016年 wj. All rights reserved.
//

#import "MusicCollectionViewCell.h"

@implementation MusicCollectionViewCell
-(id)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
        [self createUI];
    }
    return self;
}
-(void)createUI{
    self.imageView=[FactoryUI createImageViewWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height) imageName:nil];
    self.imageView.userInteractionEnabled=YES;
    [self.contentView addSubview:self.imageView];
    
    //标题
    self.titleLabel=[FactoryUI createLabelWithFrame:CGRectMake(0, 0, self.imageView.frame.size.width, 30) text:nil textColor:[UIColor whiteColor] font:[UIFont systemFontOfSize:16]];
    self.titleLabel.center=self.imageView.center;
    self.titleLabel.textAlignment=NSTextAlignmentCenter;
    [self.contentView addSubview:self.titleLabel];
}

@end
