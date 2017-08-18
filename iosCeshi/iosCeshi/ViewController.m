//
//  ViewController.m
//  iosCeshi
//
//  Created by 最爱是深蓝 on 2017/8/18.
//  Copyright © 2017年 ProductTest. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIButton*bu=[UIButton new];
    bu.frame=CGRectMake(100, 100, 100, 100);
    bu.backgroundColor=[UIColor redColor];
    [self.view addSubview:bu];
    UILabel*la=[UILabel new];
    la.text=@"is";
    la.backgroundColor=[UIColor redColor];
    la.frame=CGRectMake(100, 100, 100, 100);
    [self.view addSubview:la];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
