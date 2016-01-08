//
//  MusicCollectionReusableView.m
//  MyHomeWK
//
//  Created by qianfeng on 16/1/5.
//  Copyright © 2016年 wj. All rights reserved.
//

#import "MusicCollectionReusableView.h"

@implementation MusicCollectionReusableView
-(id)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
        self.label=[FactoryUI createLabelWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height) text:nil textColor:[UIColor darkGrayColor] font:[UIFont systemFontOfSize:15]];
        //添加在self上
        [self addSubview:self.label];
    }
    return self;
}
@end
