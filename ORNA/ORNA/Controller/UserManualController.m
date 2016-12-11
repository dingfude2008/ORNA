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
    
    UIScrollView *scrview = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 6, ScreenWidth, ScreenHeight)];
    [self.view addSubview:scrview];
    
    scrview.contentSize = CGSizeMake(ScreenWidth, ScreenWidth * (3000.0 / 1242.0) + 1 *NavBarHeight);
    UIImageView *imv = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenWidth * (3000.0 / 1242.0))];
    imv.image = [UIImage imageNamed:@"userManual"];
    [scrview addSubview:imv];
    
    scrview.contentInset = UIEdgeInsetsMake(-6, 0, NavBarHeight, 0);
    scrview.scrollIndicatorInsets = scrview.contentInset;
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
