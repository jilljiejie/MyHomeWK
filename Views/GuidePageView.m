//
//  GuidePageView.m
//  LoveLife
//
//  Created by qianfeng on 15/12/29.
//  Copyright (c) 2015年 wj. All rights reserved.
//

#import "GuidePageView.h"
@interface GuidePageView()
{
    UIScrollView *_scrollView;
}
@end
@implementation GuidePageView

-(id)initWithFrame:(CGRect)frame imageArray:(NSArray *)imageArray{
    if (self=[super initWithFrame:frame]) {
        //创建scrollView
        _scrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_H+64)];
        _scrollView.pagingEnabled=YES;//分页
        _scrollView.bounces=NO;//回弹
        _scrollView.contentSize=CGSizeMake(imageArray.count*SCREEN_W, SCREEN_H+64);
        [self addSubview:_scrollView];
        for (int i=0; i<imageArray.count; i++) {
            UIImageView *imageView=[FactoryUI createImageViewWithFrame:CGRectMake(i*SCREEN_W, 0, SCREEN_W, SCREEN_H+64) imageName:imageArray[i]];
            imageView.userInteractionEnabled=YES;//打开交互
            [_scrollView addSubview:imageView];
            if (i==imageArray.count-1) {
                self.GoInButton=[UIButton buttonWithType:UIButtonTypeCustom];
                self.GoInButton.frame=CGRectMake(150, 300, 50, 50);
                [self.GoInButton setImage:[UIImage imageNamed:@"LinkedIn"] forState:UIControlStateNormal];
                [imageView addSubview:self.GoInButton];
            }
        }
    }
    return self;
}

@end
