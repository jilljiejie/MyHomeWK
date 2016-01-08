//
//  MusicPlayViewController.h
//  MyHomeWK
//
//  Created by qianfeng on 16/1/5.
//  Copyright © 2016年 wj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MusicModel.h"
@interface MusicPlayViewController : UIViewController
//传值
@property(nonatomic,strong)MusicModel *model;
//MP3文件
@property(nonatomic,strong)NSArray *urlArray;
//index文件
@property(nonatomic,assign)int currentIndex;
@end
