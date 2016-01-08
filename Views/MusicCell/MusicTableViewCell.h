//
//  MusicTableViewCell.h
//  MyHomeWK
//
//  Created by qianfeng on 16/1/5.
//  Copyright © 2016年 wj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MusicModel.h"
@interface MusicTableViewCell : UITableViewCell
@property(nonatomic,strong)UIImageView *musicImage;
@property(nonatomic,strong)UILabel *authorLabel;//演唱者
@property(nonatomic,strong)UILabel *nameLabel;//歌曲名
-(void)refreshUI:(MusicModel *)model;
@end
