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
//  Created by 丁付德 on 16/8/9.
//  Copyright © 2016年 dfd. All rights reserved.
//

#import "BaseController.h"
//#import "FLAnimatedImage.h"
//#import "FLAnimatedImageView.h"

#pragma mark - 宏命令
@interface BaseController ()<BLEManagerDelegate>
{
    NSTimer *           timerAutoLink;                   // 连接循环器
}

@end

@implementation BaseController

#pragma mark - override
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"BaseController";
    self.edgesForExtendedLayout = UIRectEdgeNone;
    if (![self isKindOfClass:NSClassFromString(@"LeftViewcontroller")]) {
        DDBLE.delegate              = self;
    }
    self.appDelegate            = (AppDelegate *)[UIApplication sharedApplication].delegate;
    self.windowView             = self.appDelegate.window;
}


#pragma mark - ------------------------------------- 生命周期
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (DDBLE.delegate != self && ![self isKindOfClass:NSClassFromString(@"LeftViewcontroller")]) {
        DDBLE.delegate              = self;
    }
    
//    if(![self isKindOfClass:NSClassFromString(@"SearchController")])
//    {
//        
//        timerAutoLink = [NSTimer DF_sheduledTimerWithTimeInterval:1 block:^{
//            if (!DDBLE.isLink && GetUserDefault(DefaultUUIDString) && DDBLE.isOn)// 防止用户推出登录后仍会连接
//            {
//                NextWaitInGlobal(
//                                 [DDBLE retrievePeripheral:GetUserDefault(DefaultUUIDString)];);
//            }
//        } repeats:YES];
//    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}


-(void)viewWillDisappear:(BOOL)animated
{
    if (timerAutoLink) {
        [timerAutoLink DF_stop];
        timerAutoLink = nil;
    }
    [super viewDidDisappear:animated];
}

-(void)initLeftButton:(NSString *)imgName
                 text:(NSString *)text
{
    NSString *img = imgName ? imgName : @"back";
    if (!text && imgName)
    {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0, 0, 20, 20);
        [button addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        [button setImage:[UIImage imageNamed:img] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@02", img]] forState:UIControlStateNormal];
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    }
    else if(!imgName && text)
    {
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 80, 22)];
        btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        btn.titleLabel.font = [UIFont systemFontOfSize:15];
        btn.titleLabel.textColor = DWhite;
        
        if([img isEqualToString:@"back"])
        {
            [btn setImage: [UIImage imageNamed:@"back"] forState: UIControlStateNormal];
            [btn setImage: [UIImage imageNamed:@"back02"] forState: UIControlStateHighlighted];
        }
        
        [btn setTitle:text forState: UIControlStateNormal];
        [btn setImageEdgeInsets: UIEdgeInsetsMake(0, -5, 0, 0)];
        [btn setTitleEdgeInsets: UIEdgeInsetsMake(0, -3, 0, -70)];   // 防止字太多， 无法显示
        [btn setTitleColor:DWhite forState:UIControlStateNormal];
        [btn setTitleColor:DWhiteA(0.5) forState:UIControlStateHighlighted];
        [btn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    }
    else
    {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:[[UILabel alloc] init]];
    }
}

-(void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)initRightButton:(NSString *)imgName
                  text:(NSString *)text
                 isGif:(BOOL)isGif
{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:[[UILabel alloc] init]];
    if (imgName || text || isGif)
    {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0, 0, 30, 30);
        [button addTarget:self action:@selector(rightButtonClick) forControlEvents:UIControlEventTouchUpInside];
        if (isGif)
        {
            [button addSubview:({
                UIActivityIndicatorView *_activity = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
                [_activity setCenter:button.center];
                [_activity setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhite];
                _activity.userInteractionEnabled = NO;
                [_activity startAnimating];
                _activity;
            })];
        }
        else if (imgName){
            button.frame = CGRectMake(0, 0, 90, 44);
            button.backgroundColor = [UIColor clearColor];
            [button setImage:[UIImage imageNamed:imgName] forState:UIControlStateNormal];
            [button setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@02",imgName]] forState:UIControlStateHighlighted];
            button.imageEdgeInsets = UIEdgeInsetsMake(0,40,20,20);
            [button setTitle:([imgName isEqualToString:@"disconnected"] ? @"CLICK ON THE BLUETOOTH LOGO TO SEARCH YOUR DEVICE" : @"CLICK ON THE BLUETOOTH LOGO TO UNBUND YOUR DEVICE") forState:UIControlStateNormal];
            button.titleLabel.font = [UIFont systemFontOfSize:6];
            button.titleLabel.numberOfLines = 2;
            button.titleLabel.textAlignment = NSTextAlignmentCenter;
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
            button.titleEdgeInsets = UIEdgeInsetsMake(20, -39, 0, -15);
        }else if (text){
            [button setTitle:kString(text) forState:UIControlStateNormal];
            [button setTitleColor:DWhite forState:UIControlStateNormal];
            [button setBackgroundColor:DClear];
            [button.titleLabel setFont:[UIFont systemFontOfSize:16]];
        }
        
        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:button];
        self.navigationItem.rightBarButtonItem = item;
    }
}

-(void)rightButtonClick
{
    NSLog(@"rightButtonClick");
}

-(void)setNavTitle:(NSString *)title
{
    UILabel *lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    lblTitle.text = kString(title);
    lblTitle.font = [UIFont systemFontOfSize:20];
    lblTitle.textAlignment = NSTextAlignmentCenter;
    lblTitle.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = lblTitle;
}

// 禁止旋转
- (BOOL)shouldAutorotate
{
    return NO;
}

// 电池栏不隐藏
-(BOOL)prefersStatusBarHidden
{
    return NO;
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleDefault;
}

//点击按钮旋转到横屏或者竖屏
- (void)switchToLandscapeOrPortrait:(BOOL)isLandscape
{
    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)])
    {
        SEL selector             = NSSelectorFromString(@"setOrientation:");
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
        [invocation setSelector:selector];
        [invocation setTarget:[UIDevice currentDevice]];
        int val                  = !isLandscape ? UIInterfaceOrientationPortrait:UIInterfaceOrientationLandscapeRight;
        // 从2开始是因为0 1 两个参数已经被selector和target占用
        [invocation setArgument:&val atIndex:2];
        [invocation invoke];
    }
}

-(void)Found_CBPeripherals:(NSMutableDictionary *)recivedTxt
{
    NSMutableString *str = [NSMutableString string];
    for (NSString *key in recivedTxt.allKeys)
    {
        [str appendString:@"UUID:"];
        [str appendString:key];
        [str appendString:@"  name:"];
        [str appendString: ((CBPeripheral *)recivedTxt[key]).name];
        [str appendString:@"\n"];
    }
    //NSLog(@"%@", str);
    [self Found_Next:recivedTxt];
}

-(void)CallBack_ConnetedPeripheral:(NSString *)uuidString
{
    NSLog(@"CallBack_ConnetedPeripheral");
    DDWeakVV
    NextWaitInMain(
           DDStrongVV
                   
           [self initRightButton:ConnectedImage text:nil isGif:NO];);
    [DDBLE begin:GetUserDefault(DefaultUUIDString)];
}

-(void)CallBack_DisconnetedPerpheral:(NSString *)uuidString
{
    NSLog(@"CallBack_DisconnetedPerpheral");
    DDWeakVV
    NextWaitInMain(
           DDStrongVV
           [self initRightButton:DisConnectedImage text:nil isGif:NO];);
}

-(void)CallBack_Data:(int)type uuidString:(NSString *)uuidString obj:(NSObject *)obj
{
    
}


-(void)CallBack_BeginSearch
{
    NSLog(@"CallBack_BeginSearch");
    DDWeakVV
    NextWaitInMain(
           DDStrongVV
                   if(GetUserDefault(DefaultUUIDString) ||  [NSStringFromClass([self class]) isEqualToString:@"SearchController"]){
                       [self initRightButton:nil text:nil isGif:YES];
                   });
}


-(void)CallBack_FinishSearch
{
    NSLog(@"CallBack_FinishSearch");
    DDWeakVV
    NextWaitInMain(
                   DDStrongVV
                   if([NSStringFromClass([self class]) isEqualToString:@"SearchController"]){
                       if (DDBLE.isLink) {
                           [self initRightButton:ConnectedImage text:nil isGif:NO];
                       }else{
                           [self initRightButton:DisConnectedImage text:nil isGif:NO];
                       }
                   }
                   );
}

-(void)Found_Next:(NSMutableDictionary *)recivedTxt
{
    //NSLog(@"Found_Next");
}

-(void)CallBack_ManageStateChange:(BOOL)isON
{
    
    
    DDWeakVV
    NextWaitInMain(
           DDStrongVV
           if(!isON){
              [self initRightButton:DisConnectedImage text:nil isGif:NO];
           }
           else{
               if(GetUserDefault(DefaultUUIDString)){
                   [DDBLE retrievePeripheral:GetUserDefault(DefaultUUIDString)];
               }else{
                   [DDBLE startScan];
               }
           });
}





















@end
