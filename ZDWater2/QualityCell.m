//
//  QualityCell.m
//  ZDWater
//
//  Created by teddy on 15/5/26.
//  Copyright (c) 2015年 teddy. All rights reserved.
//

#import "QualityCell.h"

@implementation QualityCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self initSubViews];
    }
    return self;
}

- (void)initSubViews
{
    
    self.keyLabel = [[UILabel alloc] init];
    self.keyLabel.textAlignment = NSTextAlignmentCenter;
    self.keyLabel.backgroundColor = [UIColor clearColor];
    self.keyLabel.font = [UIFont systemFontOfSize:15];
    [self.contentView addSubview:self.keyLabel];

    self.valueLabel = [[UILabel alloc] init];
    self.valueLabel.backgroundColor = [UIColor clearColor];
    self.valueLabel.font = [UIFont systemFontOfSize:15];
    [self.contentView addSubview:self.valueLabel];
}


- (void)layoutSubviews
{
    self.keyLabel.frame = CGRectMake(0, 11, self.frame.size.width/2-20, 22);
    self.valueLabel.frame = CGRectMake(self.frame.size.width/2 + 10, 11, self.frame.size.width/2-20, 22);
}


@end
