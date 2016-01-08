//
//  MusicTableViewCell.m
//  MyHomeWK
//
//  Created by qianfeng on 16/1/5.
//  Copyright © 2016年 wj. All rights reserved.
//

#import "MusicTableViewCell.h"

@implementation MusicTableViewCell
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self customUI];
    }
    return self;
}
-(void)customUI{
    //图片
    self.musicImage=[FactoryUI createImageViewWithFrame:CGRectMake(10, 10, 120, 110) imageName:nil];
    [self.contentView addSubview:self.musicImage];
    //歌曲名
    self.nameLabel=[FactoryUI createLabelWithFrame:CGRectMake(self.musicImage.frame.origin.x+self.musicImage.frame.size.width+10, 20, 150, 20) text:nil textColor:[UIColor grayColor] font:[UIFont systemFontOfSize:15]];
    [self.contentView addSubview:_nameLabel];
    //演唱者
    _authorLabel=[FactoryUI createLabelWithFrame:CGRectMake(_nameLabel.frame.origin.x, _nameLabel.frame.size.height+_nameLabel.frame.origin.y, 100, 20) text:nil textColor:[UIColor lightGrayColor] font:[UIFont systemFontOfSize:13]];
    [self.contentView addSubview:_authorLabel];
}
-(void)refreshUI:(MusicModel *)model{
    [self.musicImage sd_setImageWithURL:[NSURL URLWithString:model.coverURL] placeholderImage:[UIImage imageNamed:@"special_palcehold"]];
    _nameLabel.text=model.title;
    _authorLabel.text=model.artist;
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
