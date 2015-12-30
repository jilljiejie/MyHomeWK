//
//  ReadModel.m
//  LoveLife
//
//  Created by qianfeng on 15/12/30.
//  Copyright © 2015年 wj. All rights reserved.
//

#import "ReadModel.h"

@implementation ReadModel
-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    //如果解析出得数据的字段与系统的重复的话，需做处理
    if ([key isEqualToString:@"id"]) {
        self.dataID=value;
    }
}

@end
