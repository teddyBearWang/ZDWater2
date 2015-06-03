//
//  NotificationCell.h
//  ZDWater
//  *************通知公告*********************
//  Created by teddy on 15/5/18.
//  Copyright (c) 2015年 teddy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NotificationCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UIImageView *image; //图片
@property (nonatomic, strong) IBOutlet UILabel *name; //名字
@property (nonatomic, strong) IBOutlet UILabel *detail; //详细
@property (nonatomic, strong) IBOutlet UILabel *date; //时间

@end
