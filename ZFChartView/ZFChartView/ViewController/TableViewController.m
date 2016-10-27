//
//  TableViewController.m
//  ZFChartView
//
//  Created by apple on 16/2/25.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "TableViewController.h"
#import "SingleBarChartViewController.h"
#import "MultiBarChartViewController.h"
#import "SingleLineChartViewController.h"
#import "MultiLineChartViewController.h"
#import "PieChartViewController.h"
#import "WaveChartViewController.h"
#import "SingleHorizontalBarChartViewController.h"
#import "MultiHorizontalBarChartViewController.h"
#import "SingleRadarChartViewController.h"
#import "MultiRadarChartViewController.h"
#import "SingleCirqueChartViewController.h"
#import "MultiCirqueChartViewController.h"

@interface TableViewController ()

@property (nonatomic, strong) NSArray * nameArray;
@property (nonatomic, strong) NSArray * viewControllerArray;

@end

@implementation TableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.nameArray = @[@"柱状图:一组数据\n(SingleBarChartViewController)",
                       @"柱状图:多组数据\n(MultiBarChartViewController)",
                       @"线状图:一组数据\n(SingleLineChartViewController)",
                       @"线状图:多组数据\n(MultiLineChartViewController)",
                       @"饼图\n(PieChartViewController)",
                       @"波浪图\n(WaveChartViewController)",
                       @"柱状图(横向):一组数据\n(SingleHorizontalBarChartViewController)",
                       @"柱状图(横向):多组数据\n(MultiHorizontalBarChartViewController)",
                       @"雷达图:一组数据\n(SingleRadarChartViewController)",
                       @"雷达图:多组数据\n(MultiRadarChartViewController)",
                       @"圆环图:一组数据\n(SingleCirqueChartViewController)",
                       @"圆环图:多组数据\n(MultiCirqueChartViewController)"];
    
    self.viewControllerArray = @[@"SingleBarChartViewController",
                                 @"MultiBarChartViewController",
                                 @"SingleLineChartViewController",
                                 @"MultiLineChartViewController",
                                 @"PieChartViewController",
                                 @"WaveChartViewController",
                                 @"SingleHorizontalBarChartViewController",
                                 @"MultiHorizontalBarChartViewController",
                                 @"SingleRadarChartViewController",
                                 @"MultiRadarChartViewController",
                                 @"SingleCirqueChartViewController",
                                 @"MultiCirqueChartViewController"];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.nameArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * cellIdentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    cell.textLabel.text = self.nameArray[indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:13.f];
    cell.textLabel.numberOfLines = 0;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.navigationController pushViewController:[[NSClassFromString(self.viewControllerArray[indexPath.row]) alloc] init] animated:YES];
}

@end
