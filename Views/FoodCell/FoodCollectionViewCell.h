//
//  FoodCollectionViewCell.h
//  MyHomeWK
//
//  Created by qianfeng on 16/1/4.
//  Copyright © 2016年 wj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FoodModel.h"
//@protocol playVideoDelegate<NSObject>
//-(void)play:(FoodModel *)model;
//@end
@interface FoodCollectionViewCell : UICollectionViewCell
{
    UIImageView *_imageView;
    UILabel *_titleLabel;
    UILabel *_desLabel;
}
@property(nonatomic,copy)void(^playBlock)(FoodModel *);
//@property(nonatomic,weak)id<playVideoDelegate>delegate;
-(void)refreshUI:(FoodModel *)model;
@end
