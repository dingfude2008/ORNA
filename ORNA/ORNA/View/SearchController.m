//
//      ┏┛ ┻━━━━━┛ ┻┓
//      ┃　　　　　　 ┃
//      ┃　　　━　　　┃
//      ┃　┳┛　  ┗┳　┃
//      ┃　　　　　　 ┃
//      ┃　　　┻　　　┃
//      ┃　　　　　　 ┃
//      ┗━┓　　　┏━━━┛
//        ┃　　　┃   神兽保佑
//        ┃　　　┃   代码无BUG！
//        ┃　　　┗━━━━━━━━━┓
//        ┃　　　　　　　    ┣┓
//        ┃　　　　         ┏┛
//        ┗━┓ ┓ ┏━━━┳ ┓ ┏━┛
//          ┃ ┫ ┫   ┃ ┫ ┫
//          ┗━┻━┛   ┗━┻━┛
//
//  Created by 丁付德 on 16/8/11.
//  Copyright © 2016年 dfd. All rights reserved.
//

#import "SearchController.h"
#pragma mark - 宏命令

@interface SearchController () <UITableViewDelegate, UITableViewDataSource>
{
    __weak IBOutlet UITableView *tabView;
    NSDate *beginDate;
    BOOL swtRefresh;                            // 刷新开关
    NSTimer *timer;
}

@property (strong, nonatomic) NSMutableDictionary *                dicData;             // 数据源



@end

@implementation SearchController

#pragma mark - override
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"SearchController";
    [self setNavTitle:@"Search"];
    [self initLeftButton:nil text:@"Back"];
    [self initRightButton:@"disconnected" text:nil isGif:NO];
    [self initData];
    [self initView];
}

#pragma mark - ------------------------------------- 生命周期
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self beginSearchAgain];
    timer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(checkLink) userInfo:nil repeats:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [timer stop];
    timer = nil;
    DDBLE.delegate = nil;
    [super viewWillDisappear:animated];
}

- (void)dealloc
{
    NSLog(@"SearchController销毁了");
}

-(void)rightButtonClick
{
    if (!DDBLE.isScaning) {
        [self beginSearchAgain];
    }
}


// 初始化数据
- (void)initData
{
    
}

// 初始化布局控件
- (void)initView
{
    UIView *viewMask = [[UIView alloc] initWithFrame:CGRectMake(0, NavBarHeight, ScreenWidth, ScreenHeight + NavBarHeight + 60)];
    viewMask.backgroundColor = [UIColor whiteColor];
    [self.view insertSubview:viewMask atIndex:0];
    
    tabView.tableHeaderView = ({
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 100)];
        view.backgroundColor = DClear;
        view;
    });
    tabView.backgroundColor = DClear;
    tabView.separatorStyle = UITableViewCellSelectionStyleGray;
    tabView.contentInset = UIEdgeInsetsMake(70, 0, 30, 0);
    tabView.scrollIndicatorInsets = tabView.contentInset;
}


#pragma mark UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return self.dicData.count;
}

#pragma mark UITableViewDelegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"Cell"; // 标识符
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    cell.contentView.backgroundColor = DClear;
    cell.textLabel.textColor = DBlack;
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 43, ScreenWidth, 1)];
    line.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.5];
    [cell.contentView addSubview:line];
    
    CBPeripheral *cbp = (CBPeripheral *)self.dicData.allValues[indexPath.row];
    cell.textLabel.text = cbp.name;
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    [cell setSelectedBackgroundView:({
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 64)];
        view.backgroundColor = DBlackA(0.3);
        view;
    })];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    [DDBLE stopScan];
    
    NSString *cbpUUID = _dicData.allKeys[indexPath.row];
    CBPeripheral *cbp = _dicData[cbpUUID];
    
    __block SearchController *blockSelf = self;
    UIAlertView *alert = [UIAlertView bk_showAlertViewWithTitle:@"Bound to this device?\n"
                                                        message:cbp.name
                                              cancelButtonTitle:@"Cancel"
                                              otherButtonTitles:@[@"OK"]
                                                        handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
        if (buttonIndex)
        {
            blockSelf->swtRefresh = YES;
            [DDBLE retrievePeripheral:cbpUUID];
            [blockSelf performSelector:@selector(checkisLinkAfterConnecting) withObject:nil afterDelay:10];
            // 这里防止用户点击后， 连接不上， 是因为设备已经长时间没有连接停止广播造成的
            blockSelf->beginDate = DNow;
            [blockSelf->tabView reloadData];
        }
    }];
    [alert show];
}

-(void)Found_Next:(NSMutableDictionary *)recivedTxt
{
    NSLog(@"Search : Found_Next");
    if(!swtRefresh){
        __block SearchController *blockSelf = self;
        __block NSMutableDictionary *blockrecivedTxt = [recivedTxt mutableCopy];
        NSLog(@"");
        [DFD performBlockInMain:^{
            blockSelf.dicData = [blockrecivedTxt mutableCopy];
            if (blockSelf.dicData.count > 0 && [DNow timeIntervalSinceDate:beginDate] > 1.5)
            {
                blockSelf->tabView.userInteractionEnabled = YES;
                NSLog(@"刷新界面");
                blockSelf -> beginDate = DNow;
                [blockSelf -> tabView reloadData];
            }
        }];
    }
}


-(void)beginSearchAgain
{
    if (!DDBLE.isOn) {
        MBShow(@"Please turn on Bluetooth");
        
        
        return;
    }
    beginDate = DNow;
    
    [DDBLE startScan];
    [self.dicData removeAllObjects];
    [tabView reloadData];
    __block SearchController *blockSelf = self;
    NextWaitInMainAfter(
                        if(blockSelf.dicData.count)
                        {
                            blockSelf->tabView.userInteractionEnabled = YES;
                        }
                        , 1.5);
    
    NextWaitInMainAfter(
                        if(!blockSelf.dicData.count)
                        {
                            if (blockSelf.view.window) {
                                MBShow(@"No device found.");
                            }
                        }
                        , DDSearchTime);
}

-(void)checkisLinkAfterConnecting
{
    if (!DDBLE.isLink) {
//        MBHide
        MBShow(@"请尝试重新连接");
        swtRefresh = NO;
        [self beginSearchAgain];
    }
}


-(void)checkLink
{
    if (DDBLE.isLink && DDBLE.dicConnected.count)
    {
        [timer stop];
        timer = nil;
        SetUserDefault(DefaultUUIDString, DDBLE.dicConnected.allKeys[0]);
        __block SearchController *blockSelf = self;
        NextWaitInMainAfter(
                [blockSelf.navigationController popViewControllerAnimated:YES];, 1);
    }
}






@end
