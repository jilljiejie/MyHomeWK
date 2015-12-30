//
//  HomeTableViewCell.m
//  LoveLife
//
//  Created by qianfeng on 15/12/29.
//  Copyright (c) 2015年 wj. All rights reserved.
//

#import "HomeTableViewCell.h"

@implementation HomeTableViewCell
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createUI];
    }
    return self;
}
-(void)createUI{
    _titlelabel=[FactoryUI createLabelWithFrame:CGRectMake(10, 10, SCREEN_W-20, 20) text:nil textColor:RGB(255, 156, 187, 1) font:[UIFont systemFontOfSize:16]];
    [self.contentView addSubview:_titlelabel];
    
    _imageView=[FactoryUI createImageViewWithFrame:CGRectMake(10, _titlelabel.frame.size.height+_titlelabel.frame.origin.y+10, SCREEN_W-20, 180) imageName:nil];
    [self.contentView addSubview:_imageView];
}
-(void)refreshUI:(HomeModel *)model{
    [_imageView sd_setImageWithURL:[NSURL URLWithString:model.pic] placeholderImage:[UIImage imageNamed:@""]];
    _titlelabel.text=model.title;
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
