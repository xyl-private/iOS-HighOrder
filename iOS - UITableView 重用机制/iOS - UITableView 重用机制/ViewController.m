//
//  ViewController.m
//  iOS - UITableView 重用机制
//
//  Created by xyl-apple on 15/4/11.
//  Copyright (c) 2015年 xyl. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (strong, nonatomic) IBOutlet UITableView *TV;
@property(nonatomic,assign) int count;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 100;
};

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCellStyle style = UITableViewCellStyleSubtitle;
    static NSString *cellID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:style reuseIdentifier:cellID];
        cell.detailTextLabel.text = [NSString stringWithFormat:@"Cell %d",++self.count]; //当分配内存时标记
    }
    cell.textLabel.text = [NSString stringWithFormat:@"Cell %ld",[indexPath row] + 1];  //当新显示一个Cell时标记
    NSLog(@"%@",cell.textLabel.text);
    NSLog(@"%ld",[indexPath row]);
    return cell;
}

@end
