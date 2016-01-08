//
//  MusicModel.h
//  MyHomeWK
//
//  Created by qianfeng on 16/1/5.
//  Copyright © 2016年 wj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MusicModel : NSObject
@property(nonatomic,copy)NSString *artist;//演唱者
@property(nonatomic,copy)NSString *coverURL;//图片
@property(nonatomic,copy)NSString *title;//歌曲名
@property(nonatomic,copy)NSString *url;//歌曲网址
@end
