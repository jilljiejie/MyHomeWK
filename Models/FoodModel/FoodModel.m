//
//  FoodModel.m
//  MyHomeWK
//
//  Created by qianfeng on 16/1/4.
//  Copyright © 2016年 wj. All rights reserved.
//

#import "FoodModel.h"

@implementation FoodModel
//防崩溃
-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    if ([key isEqualToString:@"description"]) {
        self.detail=value;
    }
}
@end
