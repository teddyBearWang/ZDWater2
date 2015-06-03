//
//  QualityDetailController.h
//  ZDWater
// ************水质详细信息********************
//  Created by teddy on 15/5/26.
//  Copyright (c) 2015年 teddy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QualityDetailController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *tableView;
}

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *datas;

@end
