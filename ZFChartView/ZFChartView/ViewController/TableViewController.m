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

@interface TableViewController ()

@property (nonatomic, strong) NSArray * nameArray;

@end

@implementation TableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.nameArray = @[@"柱状图:一组数据(SingleBarChartViewController)",
                       @"柱状图:多组数据(MultiBarChartViewController)",
                       @"线状图:一组数据(SingleLineChartViewController)",
                       @"线状图:多组数据(MultiLineChartViewController)",
                       @"饼图(PieChartViewController)",
                       @"波浪图(WaveChartViewController)",
                       @"柱状图(横向):一组数据(SingleHorizontalBarChartViewController)",
                       @"柱状图(横向):多组数据(MultiHorizontalBarChartViewController)"];
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
    if (indexPath.row == 0) {
        SingleBarChartViewController * vc = [[SingleBarChartViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }else if (indexPath.row == 1){
        MultiBarChartViewController * vc = [[MultiBarChartViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }else if (indexPath.row == 2){
        SingleLineChartViewController * vc = [[SingleLineChartViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }else if (indexPath.row == 3){
        MultiLineChartViewController * vc = [[MultiLineChartViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }else if (indexPath.row == 4){
        PieChartViewController * vc = [[PieChartViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }else if (indexPath.row == 5){
        WaveChartViewController * vc = [[WaveChartViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }else if (indexPath.row == 6){
        SingleHorizontalBarChartViewController * vc = [[SingleHorizontalBarChartViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }else if (indexPath.row == 7){
        MultiHorizontalBarChartViewController * vc = [[MultiHorizontalBarChartViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}

@end
