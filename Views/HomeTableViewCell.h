//
//  HomeTableViewCell.h
//  LoveLife
//
//  Created by qianfeng on 15/12/29.
//  Copyright (c) 2015年 wj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeModel.h"
@interface HomeTableViewCell : UITableViewCell
{
    //图片
    UIImageView *_imageView;
    //标题
    UILabel *_titlelabel;
}
-(void)refreshUI:(HomeModel *)model;

@end
