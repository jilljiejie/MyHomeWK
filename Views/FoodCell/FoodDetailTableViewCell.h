//
//  FoodDetailTableViewCell.h
//  MyHomeWK
//
//  Created by qianfeng on 16/1/4.
//  Copyright © 2016年 wj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FoodDetailModel.h"
@interface FoodDetailTableViewCell : UITableViewCell
{
    UIImageView *_imageView;
    UILabel *_stepLabel;
}
-(void)refreshUI:(FoodDetailModel *)model indexPath:(NSIndexPath *)indexPath;
@end
