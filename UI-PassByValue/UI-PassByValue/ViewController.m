//
//  ViewController.m
//  UI-PassByValue
//
//  Created by xyl-apple on 15/3/12.
//  Copyright (c) 2015年 zeepson. All rights reserved.
//

#import "ViewController.h"
#import "SecondVC.h"
#import "ThreeViewController.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}
/*
    根据storyboard 跳转 传值
 
 */
- (IBAction)passValueOne:(id)sender {
    
    SecondVC * svc = [self.storyboard instantiateViewControllerWithIdentifier:@"SecondVC"];
    svc.stringL = @"方法一跳转";
    [self presentViewController:svc animated:YES completion:nil];
    
    
    
}
/*
    使用 segue 连线 传值
 
 */
- (IBAction)passValueTwo:(id)sender {
    
    [self performSegueWithIdentifier:@"three" sender:sender];
    
    
    
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    ThreeViewController * tvc = segue.destinationViewController;
    UIButton * bu = sender;
    tvc.string = bu.titleLabel.text;
    

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
