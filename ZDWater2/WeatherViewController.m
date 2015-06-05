//
//  WeatherViewController.m
//  ZDWater2
//      ********天气预报*********
//  Created by teddy on 15/6/3.
//  Copyright (c) 2015年 teddy. All rights reserved.
//

#import "WeatherViewController.h"
#import "WeatherObject.h"
#import "SVProgressHUD.h"

@interface WeatherViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *bgImage;

@property (weak, nonatomic) IBOutlet UILabel *curentTemp;
@property (weak, nonatomic) IBOutlet UILabel *currentTime;
@property (weak, nonatomic) IBOutlet UIImageView *currentImage;
@property (weak, nonatomic) IBOutlet UILabel *currentStation;
@property (weak, nonatomic) IBOutlet UILabel *currentWind;

@property (weak, nonatomic) IBOutlet UIView *torromView;
@property (weak, nonatomic) IBOutlet UILabel *torromDate;
@property (weak, nonatomic) IBOutlet UIImageView *torromImage;
@property (weak, nonatomic) IBOutlet UILabel *torromStation;
@property (weak, nonatomic) IBOutlet UILabel *torromWind;

@property (weak, nonatomic) IBOutlet UIView *secondView;
@property (weak, nonatomic) IBOutlet UILabel *secondDate;
@property (weak, nonatomic) IBOutlet UIImageView *secondImage;
@property (weak, nonatomic) IBOutlet UILabel *secondStation;
@property (weak, nonatomic) IBOutlet UILabel *secondWind;

@end

@implementation WeatherViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"天气预报";
    
    UISegmentedControl *seg = [[UISegmentedControl alloc] initWithItems:@[@"萧山区",@"绍兴市",@"余姚市",@"慈溪市"]];
    seg.segmentedControlStyle = UISegmentedControlStyleBar;
    seg.selectedSegmentIndex = 0;
    seg.multipleTouchEnabled = NO;
    seg.apportionsSegmentWidthsByContent = YES;
    [seg addTarget:self action:@selector(selectItemsAction:) forControlEvents:UIControlEventValueChanged];
    self.navigationItem.titleView = seg;
    
    self.bgImage.image = [UIImage imageNamed:@"tq.jpg"];
    
    [self getWeatherData:@"萧山"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)selectItemsAction:(UISegmentedControl *)seg
{
    NSString *cityName = nil;
    [SVProgressHUD show];
    switch (seg.selectedSegmentIndex) {
        case 0:
            cityName = @"萧山";
            break;
        case 1:
            cityName = @"绍兴";
            break;
        case 2:
            cityName = @"余姚";
            break;
        case 3:
            cityName = @"慈溪";
            break;
        default:
            break;
    }
    
    [self getWeatherData:cityName];
}

- (void)getWeatherData:(NSString *)area
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if ([WeatherObject fetchWithArea:area]) {
            [self updateUI];
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                [SVProgressHUD dismissWithError:nil];
            });
        }
    });
}

//更新UI
- (void)updateUI
{
    [SVProgressHUD dismissWithSuccess:nil];
    dispatch_async(dispatch_get_main_queue(), ^{
        NSArray *arr = [WeatherObject requestData];
        NSDictionary *dic = [arr objectAtIndex:0];
        
        self.curentTemp.text = [dic objectForKey:@"tempreal"];
        self.currentTime.text = [dic objectForKey:@"time"];
        self.currentImage.image = [UIImage imageNamed:[dic objectForKey:@"image"]];
        self.currentStation.text = [NSString stringWithFormat:@"%@ %@",[dic objectForKey:@"weather"],[dic objectForKey:@"temp"]];
        self.currentWind.text = [dic objectForKey:@"wind"];
        
        self.torromDate.text = [dic objectForKey:@"date1"];
        self.torromImage.image = [UIImage imageNamed:[dic objectForKey:@"image1"]];
        self.torromStation.text = [NSString stringWithFormat:@"%@ %@",[dic objectForKey:@"weather1"],[dic objectForKey:@"temp1"]];
        self.torromWind.text = [dic objectForKey:@"wind1"];
        
        self.secondDate.text = [dic objectForKey:@"date2"];
        self.secondImage.image = [UIImage imageNamed:[dic objectForKey:@"image2"]];
        self.secondStation.text = [NSString stringWithFormat:@"%@ %@",[dic objectForKey:@"weather2"],[dic objectForKey:@"temp2"]];
        self.secondWind.text = [dic objectForKey:@"wind2"];
    });
}

@end
