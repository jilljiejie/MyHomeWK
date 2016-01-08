//
//  FoodDescripModel.h
//  MyHomeWK
//
//  Created by qianfeng on 16/1/4.
//  Copyright © 2016年 wj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FoodDescripModel : NSObject
@property(nonatomic,copy)NSString *image;//头视图的图片
@property(nonatomic,copy)NSString *dashes_name;//菜名
@property(nonatomic,copy)NSString *cooking_time;//制作时间
@property(nonatomic,copy)NSString *hard_level;//难度
@property(nonatomic,copy)NSString *taste;//口味
@property(nonatomic,copy)NSString *material_desc;//描述
@property(nonatomic,copy)NSArray *step;
@end
