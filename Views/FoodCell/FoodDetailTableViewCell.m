//
//  FoodDetailTableViewCell.m
//  MyHomeWK
//
//  Created by qianfeng on 16/1/4.
//  Copyright © 2016年 wj. All rights reserved.
//

#import "FoodDetailTableViewCell.h"

@implementation FoodDetailTableViewCell
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createUI];
    }
    return self;
}
-(void)createUI{
    _imageView=[FactoryUI createImageViewWithFrame:CGRectMake(10, 10, SCREEN_W-20, 150) imageName:nil];
    [self.contentView addSubview:_imageView];
    _stepLabel=[FactoryUI createLabelWithFrame:CGRectMake(10, _imageView.frame.size.height+_imageView.frame.origin.y+5, SCREEN_W-20, 20) text:nil textColor:[UIColor grayColor] font:[UIFont systemFontOfSize:15]];
    _stepLabel.numberOfLines=0;
    [self.contentView addSubview:_stepLabel];
}
-(void)refreshUI:(FoodDetailModel *)model indexPath:(NSIndexPath *)indexPath{
    [_imageView sd_setImageWithURL:[NSURL URLWithString:model.dishes_step_image] placeholderImage:[UIImage imageNamed:@""]];
    NSMutableAttributedString *string=[[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%ld:%@",indexPath.row+1,model.dishes_step_desc]];
    if (indexPath.row+1>9) {
        [string addAttributes:@{NSForegroundColorAttributeName:RGB(255, 156, 187, 1),NSFontAttributeName:[UIFont systemFontOfSize:20]} range:NSMakeRange(0, 3)];
    }
    else{
        [string addAttributes:@{NSForegroundColorAttributeName:RGB(255, 156, 187, 1),NSFontAttributeName:[UIFont systemFontOfSize:20]} range:NSMakeRange(0, 2)];
    }
    _stepLabel.attributedText=string;
    
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
