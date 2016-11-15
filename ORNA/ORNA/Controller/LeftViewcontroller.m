//
//  LeftViewcontroller.m
//  ORNA
//
//  Created by DFD on 16/11/2.
//  Copyright © 2016年 dfd. All rights reserved.
//

#import "LeftViewcontroller.h"
#import "tvcLeft.h"
//#import "IndexController.h"

#define viewBackGroundColor             RGBA(42, 46, 51, 1)

@interface LeftViewcontroller ()<UITableViewDelegate, UITableViewDataSource>
{
    CGRect BIGFRAME;
    CGRect SMALLFRAME;
    NSTimeInterval ANIMATIONTIME;
    BOOL isLeft;                        //  是否离开
}

@property (weak, nonatomic) IBOutlet UITableView        *tabView;

@property (strong, nonatomic) NSArray *arrTblImgData;           // 默认的图片
@property (strong, nonatomic) NSArray *arrTblImgData2;          // 选中时的图片
@property (strong, nonatomic) NSArray *arrTblNameData;

@end

@implementation LeftViewcontroller

-(instancetype)init
{
    self = [super init];
    if (self) {
        [self initLeft];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initTable];
    [self initData];
    [self initView];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    isLeft = NO;
    [self.view setFrame:CGRectMake(-100, 0, ScreenWidth, ScreenHeight)];
    [UIView transitionWithView:self.view duration:ANIMATIONTIME options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        [self.view setFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    } completion:^(BOOL finished) {}];
    [_tabView reloadData];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [UIView transitionWithView:self.view duration:ANIMATIONTIME options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        [self.view setFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    } completion:^(BOOL finished) {}];
    isLeft = YES;
    [_tabView setUserInteractionEnabled:YES];
    
    [super viewWillDisappear:animated];
}


-(void)initLeft
{
    AppDelegate *delegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    delegate.left = self;
}


-(void)initView
{
    
//    self.view.backgroundColor = RGB(64,64,64);
    _tabView.rowHeight = 50;
    
    BIGFRAME = CGRectMake(0, _tabView.frame.origin.y, 260, 375);
    SMALLFRAME = CGRectMake(-160, _tabView.frame.origin.y, 0, 0);
    ANIMATIONTIME = 0.35;
    
}


#pragma mark UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return _arrTblNameData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    tvcLeft *cell = [tvcLeft cellWithTableView:tableView index:indexPath.row];
    cell.lblName.text = _arrTblNameData[indexPath.row];
    
    cell.lblName.highlightedTextColor =  RGBA(16, 128, 218, 1);
    cell.imvBig.highlightedImage = [UIImage imageFromColor:RGBA(0, 0, 0, 0.9)];
    if (IS_IPad) cell.imvBig.image = [UIImage imageFromColor:DBlack];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(isLeft) return;
    isLeft = YES;
    [_tabView setUserInteractionEnabled:NO];                        // 防止点击触发特效
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    self.appDelegate.customTb.selectedIndex = indexPath.row;
    [self.appDelegate.sideViewController hideSideViewController:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return Bigger(RealHeight(110), 50);
}


-(void)initTable
{
    
}

-(void)initData
{
    _arrTblNameData = @[@"Control", @"Description", @"User-Manual", @"About us"];
}

@end
