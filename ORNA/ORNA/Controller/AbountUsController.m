//
//  AbountUsController.m
//  ORNA
//
//  Created by DFD on 16/11/2.
//  Copyright © 2016年 dfd. All rights reserved.
//

#import "AbountUsController.h"

@interface AbountUsController ()

@end

@implementation AbountUsController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setNavTitle:@"About Us"];
    [self initLeftButton:@"menu" text:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)back
{
    [self.appDelegate.sideViewController showLeftViewController:YES];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
