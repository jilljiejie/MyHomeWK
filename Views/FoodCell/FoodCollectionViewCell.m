//
//  FoodCollectionViewCell.m
//  MyHomeWK
//
//  Created by qianfeng on 16/1/4.
//  Copyright © 2016年 wj. All rights reserved.
//

#import "FoodCollectionViewCell.h"
@interface FoodCollectionViewCell()
@property(nonatomic,strong)FoodModel *foodModel;
@end
@implementation FoodCollectionViewCell
-(id)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
        [self custumUI];
    }
    return self;
}
-(void)custumUI{
    _imageView=[FactoryUI createImageViewWithFrame:CGRectMake(10, 10, (SCREEN_W-20)/2-20, 130) imageName:nil];
    _imageView.userInteractionEnabled=YES;
    [self.contentView addSubview:_imageView];
    _titleLabel=[FactoryUI createLabelWithFrame:CGRectMake(10, _imageView.frame.origin.y+_imageView.frame.size.height+5, _imageView.frame.size.width, 20) text:nil textColor:[UIColor lightGrayColor] font:[UIFont systemFontOfSize:15]];
    _titleLabel.textAlignment=NSTextAlignmentLeft;
    [self.contentView addSubview:_titleLabel];
    _desLabel=[FactoryUI createLabelWithFrame:CGRectMake(10, _titleLabel.frame.size.height+_titleLabel.frame.origin.y+5, _titleLabel.frame.size.width, 20) text:nil textColor:[UIColor lightGrayColor] font:[UIFont systemFontOfSize:12]];
    [self.contentView addSubview:_desLabel];
    //设置播放按钮
    UIButton *playButton=[FactoryUI createButtonWithFrame:CGRectMake(0, 0, 40, 40) title:nil titleColor:nil imageName:@"iconfont-bofang-3" backgroundImageName:nil target:self selector:@selector(playButtonAction)];
    playButton.center=_imageView.center;
    [self.contentView addSubview:playButton];
}
//播放按钮
-(void)playButtonAction{
//    if ([self.delegate respondsToSelector:@selector(play:)]) {
//        [self.delegate play:_foodModel];
//    }
    self.playBlock(_foodModel);
}
-(void)refreshUI:(FoodModel *)model{
    _foodModel=model;
    [_imageView sd_setImageWithURL:[NSURL URLWithString:model.image] placeholderImage:[UIImage imageNamed:@""]];
    _titleLabel.text=model.title;
    _desLabel.text=model.detail;
}
@end
