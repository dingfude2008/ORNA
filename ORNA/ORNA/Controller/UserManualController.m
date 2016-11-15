//
//  UserManualController.m
//  ORNA
//
//  Created by DFD on 16/11/14.
//  Copyright © 2016年 dfd. All rights reserved.
//

#import "UserManualController.h"

@interface UserManualController ()

@end

@implementation UserManualController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavTitle:@"User Manual"];
    [self initLeftButton:@"menu" text:nil];
    
    
    UIImageView *imv = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    imv.image = [UIImage imageNamed:@"userManual"];
    [self.view addSubview:imv];
    
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
