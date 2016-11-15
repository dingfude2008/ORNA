//
//  DescriptionController.m
//  ORNA
//
//  Created by DFD on 16/11/14.
//  Copyright © 2016年 dfd. All rights reserved.
//

#import "DescriptionController.h"

@interface DescriptionController ()

@end

@implementation DescriptionController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavTitle:@"Product Description"];
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
