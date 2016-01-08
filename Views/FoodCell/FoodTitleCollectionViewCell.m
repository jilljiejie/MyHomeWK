//
//  FoodTitleCollectionViewCell.m
//  MyHomeWK
//
//  Created by qianfeng on 16/1/4.
//  Copyright © 2016年 wj. All rights reserved.
//

#import "FoodTitleCollectionViewCell.h"

@implementation FoodTitleCollectionViewCell
-(id)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
        self.titleLabel=[FactoryUI createLabelWithFrame:CGRectMake(0, 0, (SCREEN_W-20)/2, 30) text:nil textColor:[UIColor whiteColor] font:[UIFont systemFontOfSize:15]];
        self.titleLabel.textAlignment=NSTextAlignmentCenter;
        self.titleLabel.backgroundColor=RGB(255, 156, 187, 1);
        [self.contentView addSubview:self.titleLabel];
    }
    return self;
}
@end
