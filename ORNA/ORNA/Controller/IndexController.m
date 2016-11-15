//
//  IndexController.m
//  ORNA
//
//  Created by DFD on 16/11/2.
//  Copyright © 2016年 dfd. All rights reserved.
//

#import "IndexController.h"
#import "LeftViewcontroller.h"
#import "ColorPickerView.h"
#import "SearchController.h"
#import "CircleView.h"

@interface IndexController ()<ZWColorPickerDelegate>
{
    BOOL isFirstLoad;
    
    BOOL isDynamic;     // 是否处于渐变模式
}

@property (weak, nonatomic) IBOutlet ColorPickerView *imageView;
@property (weak, nonatomic) IBOutlet CircleView *circleView;

@property (weak, nonatomic) IBOutlet UIButton *btnAll;
@property (weak, nonatomic) IBOutlet UISlider *sliderLightness;
@property (weak, nonatomic) IBOutlet UISlider *sliderSpeed;
@property (weak, nonatomic) IBOutlet UILabel *lblTest;
@property (weak, nonatomic) IBOutlet UILabel *lblTest2;
@property (weak, nonatomic) IBOutlet UILabel *lblTest3;
@property (weak, nonatomic) IBOutlet UILabel *lblTest4;


@property (assign, nonatomic) BOOL isDelayOver;
@property (weak, nonatomic) IBOutlet UIButton *btnStatic;
@property (weak, nonatomic) IBOutlet UIButton *btnDynamic;
@property (weak, nonatomic) IBOutlet UIImageView *imvStatic;
@property (weak, nonatomic) IBOutlet UIImageView *imvDynamic;

@end

@implementation IndexController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [self setVcLeftDelegate];
    
    [self setNavTitle:@"ORNA"];
    [self initLeftButton:@"menu" text:nil];
    [self initRightButton:@"disconnected" text:nil isGif:NO];
    self.btnAll.layer.cornerRadius = 20;
    self.btnAll.layer.borderWidth = 1;
    self.btnAll.layer.borderColor = [UIColor whiteColor].CGColor;
    self.btnAll.layer.masksToBounds = YES;
    
    self.circleView.circleRadius = (ScreenWidth * 0.618 + 30 ) / 2;
    self.circleView.circleWidth = 5;
    self.circleView.backgroundColor= [UIColor clearColor];
    
    self.sliderLightness.minimumValue = 50;
    self.sliderLightness.maximumValue = 255;
    
    self.sliderSpeed.minimumValue = 20;
    self.sliderSpeed.maximumValue = 100;
    
    // 旋转
    self.sliderSpeed.transform = CGAffineTransformRotate(self.sliderSpeed.transform, -M_PI);
    self.sliderLightness.minimumTrackTintColor = [UIColor blueColor];
    self.sliderLightness.maximumTrackTintColor = [UIColor grayColor];
    
    self.sliderSpeed.minimumTrackTintColor = [UIColor grayColor];
    self.sliderSpeed.maximumTrackTintColor = [UIColor blueColor];
    
    [self.btnAll setBackgroundImage:[UIImage imageNamed:@"swith_on"] forState:UIControlStateSelected];
    [self.btnAll setBackgroundImage:[UIImage imageNamed:@"swith_off"] forState:UIControlStateNormal];

    __weak typeof(self) weakself = self;
    [self.imageView setPickerStyle:0 andBlock:^(UIColor *color) {
        [weakself changecolor:color];
    }];
    
    isFirstLoad = YES;
    
//#ifdef DEBUG
//    self.lblTest.hidden = self.lblTest2.hidden = NO;
//#else
//    self.lblTest.hidden = self.lblTest2.hidden = YES;
//#endif
//    
    self.lblTest.hidden = self.lblTest2.hidden = self.lblTest3.hidden = self.lblTest4.hidden = YES;
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    DDWeakVV
    NextWaitInMain(
        DDStrongVV
        self.isDelayOver = YES;
    );
    
    if (isFirstLoad)
    {
        isFirstLoad = NO;
        if (GetUserDefault(DefaultUUIDString)) {
            NSLog(@"本地存有存储的连接设备");
            [DDBLE retrievePeripheral:GetUserDefault(DefaultUUIDString)];
        }else{
            NSLog(@"本地没有存储默认的连接设备, 扫描中");
            [DDBLE startScan];
        }
    }
    
    if (DDBLE.isLink) {
        [self initRightButton:ConnectedImage text:nil isGif:NO];
        self.btnAll.enabled = YES;
        self.sliderSpeed.enabled = YES;
        self.sliderLightness.enabled = YES;
    }else if(DDBLE.isScaning && GetUserDefault(DefaultUUIDString)){
        [self initRightButton:nil text:nil isGif:YES];
        [self setAllControlEnable];
        
    }else{
        [self initRightButton:DisConnectedImage text:nil isGif:NO];
//        self.btnAll.enabled = NO;
        [self setAllControlEnable];
    }
}

-(void)setAllControlEnable
{
    self.btnAll.enabled = NO;
    self.imageView.userInteractionEnabled = NO;
    self.sliderSpeed.enabled = NO;
    self.sliderLightness.enabled = NO;
}

// 设置代理
//-(void)setVcLeftDelegate
//{
//    AppDelegate *delegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
//    LeftViewcontroller *left = (LeftViewcontroller *)delegate.left;
//    left.delegate = self;
//}

-(void)back
{
    [self.appDelegate.sideViewController showLeftViewController:YES];
}

-(void)rightButtonClick
{
    if (self.isDelayOver)
    {
        if (!DDBLE.isLink)
        {
            SearchController *searchController = [[SearchController alloc] initWithNibName:@"Search" bundle:nil];
            [self.navigationController pushViewController:searchController animated:YES];
        }
        else
        {
            __block IndexController *blockSelf = self;
            UIAlertView *alert = [UIAlertView bk_showAlertViewWithTitle:@"Alert"
                    message:@"Are you sure to remove the binding device?"
          cancelButtonTitle:@"Cancel"
          otherButtonTitles:@[@"YES"]
                    handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
                        if (buttonIndex)
                        {
                            [DDBLE stopLink:GetUserDefault(DefaultUUIDString)];
                            RemoveUserDefault(DefaultUUIDString);
                            blockSelf.imageView.userInteractionEnabled = NO;
                            blockSelf.btnAll.enabled = NO;
                            blockSelf.sliderSpeed.enabled = NO;
                            blockSelf.sliderLightness.enabled = NO;
                        }
                    }];
            [alert show];
        }
    }
}


#pragma mark - LeftViewcontrollerDelegate
-(void)selected:(NSInteger)ind
{
    switch (ind)
    {
        case 1:
            [self performSegueWithIdentifier:@"index_userManual" sender:nil];
            break;
        case 2:
            [self performSegueWithIdentifier:@"index_aboutUs" sender:nil];
            break;
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)changecolor:(UIColor *)color{
    const CGFloat *components = CGColorGetComponents(color.CGColor);
    CGFloat r = components[0];
    CGFloat g = components[1];
    CGFloat b = components[2];
    
    double R = r * 255.0;
    double G = g * 255.0;
    double B = b * 255.0;
    
    self.circleView.arrColor = @[@(R),@(G),@(B)];
    
    
    // 把最大的那个变为255
    if (R >= G && R >= B) {
        R = 255.0;
    }else if (G >= R && G >= B) {
        G = 255.0;
    }else if (B >= R && B >= G) {
        B = 255.0;
    }
    
    
    if([DDBLE.arrValue[0] intValue] == 127){
        NSLog(@"处于待机模式");
    }else{
        //NSLog(@"改变颜色--> 模式：%@ 速度：%.0f, RGB:%f-%f-%f",(self.sgt.selectedSegmentIndex == 1 ? @"渐变":@"静态"), self.sliderSpeed.value, R, G, B);
        
        [DDBLE setRGB:GetUserDefault(DefaultUUIDString)
                  RGB:@[@(R),@(G),@(B)]];
        
    }
}


- (IBAction)btnAllClick:(UIButton *)sender {
    if (self.btnAll.selected) {
        self.btnAll.selected = NO;
        [DDBLE swithStandbyOrWorking:GetUserDefault(DefaultUUIDString) isStandby:YES];
    }else{
        self.btnAll.selected = YES;
        [DDBLE swithStandbyOrWorking:GetUserDefault(DefaultUUIDString) isStandby:NO];
    }
}
- (IBAction)sliderBrightnessChange:(UISlider *)sender {
    [DDBLE setBrightness:GetUserDefault(DefaultUUIDString) brightness:sender.value];
}
- (IBAction)sliderSpeedChange:(UISlider *)sender {
    [DDBLE setSpeed:GetUserDefault(DefaultUUIDString) speed:sender.value];
}
- (IBAction)btnStaticClick:(UIButton *)sender {
    if ([DDBLE.arrValue[0] intValue] == 1) {
        [DDBLE swithDynamicOrStatic:GetUserDefault(DefaultUUIDString) isDynamic:NO];
    }
}
- (IBAction)btnDynamicClick:(UIButton *)sender {
    if ([DDBLE.arrValue[0] intValue] == 0) {
        [DDBLE swithDynamicOrStatic:GetUserDefault(DefaultUUIDString) isDynamic:YES];
    }
}


//
//- (IBAction)sgtChange:(UISegmentedControl *)sender {
//    if (sender.selectedSegmentIndex) {
//        [DDBLE swithDynamicOrStatic:GetUserDefault(DefaultUUIDString) isDynamic:YES];
//    }else{
//        [DDBLE swithDynamicOrStatic:GetUserDefault(DefaultUUIDString) isDynamic:NO];
//    }
//}


- (void)refresh:(NSArray *)arrValue
{
    // 0:模式 1:速度 2:亮度 3:R 4:G 5:B 6:W
    if (DDBLE.arrValue)
    {
        int model   = [arrValue[0] intValue];
        int speed   = [arrValue[1] intValue];
        int light   = [arrValue[2] intValue];
        int R       = [arrValue[3] intValue];
        int G       = [arrValue[4] intValue];
        int B       = [arrValue[5] intValue];
        
        self.imageView.userInteractionEnabled = NO;
        self.sliderLightness.enabled = NO;
        self.sliderSpeed.enabled = NO;
        
        NSString *strModel = @"";
        
        
        
        
        self.sliderSpeed.enabled = NO;
        switch (model) {
            case 0:
                strModel = @"静态";
                self.imageView.userInteractionEnabled = YES;
                self.sliderLightness.enabled = YES;
                break;
            case 1:
                strModel = @"渐变";
                self.sliderSpeed.enabled = YES;
                self.sliderLightness.enabled = YES;
                break;
            case 127:  // 0x7F
                strModel = @"待机";
                break;
            case 254:  // 0xFE
                strModel = @"密匙";
                break;
        }
        
        int lightBiggest = model == 1 ? light : Bigger(Bigger(R, G), B) ;
        
        self.lblTest.text = [NSString stringWithFormat:@"模式:%@,速度:%03d,亮度:%03d RGB:%03d-%03d-%03d ", strModel, speed, lightBiggest, R,G,B];
        
        NSLog(@"回调后刷新新值：model:%d,speed:%d,light:%d,R:%d,G:%d,B:%d", model, speed, lightBiggest, R,G,B);
        
        self.sliderLightness.value = lightBiggest;
        
        self.btnAll.enabled = YES;
        self.btnAll.selected = YES;
        
        if(model == 1){
            self.imvStatic.image  = [UIImage imageNamed:@"unchecked"];
            self.imvDynamic.image = [UIImage imageNamed:@"checked"];
        }else if(model == 0){
            self.imvStatic.image  = [UIImage imageNamed:@"checked"];
            self.imvDynamic.image = [UIImage imageNamed:@"unchecked"];
        }else if(model == 127){
            self.btnAll.selected = NO;
        }
        
        self.sliderSpeed.value = speed;
    }
}

-(void)CallBack_Data:(int)type uuidString:(NSString *)uuidString obj:(NSObject *)obj
{
    if (obj)
    {
        NSArray *arrValue = (NSArray *)obj;
        NSString *string;
        if (type == 99) {
            string = [NSString stringWithFormat:@"最后一次写入:%@", (NSString *)obj];
        }else if(type == 98)
        {
            string = [NSString stringWithFormat:@"最后一次读取:%@", (NSString *)obj];
        }
        DDWeakVV
        NextWaitInMain(
               DDStrongVV
               if(type == 99){
                   self.lblTest3.text = string;
               }else if(type == 98){
                   self.lblTest4.text = string;
               }else{
                   [self refresh:arrValue];
               });
    }else
    {
        DDWeakVV
        NextWaitInMain(
               DDStrongVV
               self.lblTest2.text = [[NSDate date] toString:@"最新写入成功时间:\nHH:mm:ss:SSS"];);
    }
}

-(void)CallBack_ConnetedPeripheral:(NSString *)uuidString
{
    [super CallBack_ConnetedPeripheral:uuidString];
    DDWeakVV
    NextWaitInMain(
                   DDStrongVV
                   self.btnAll.enabled = YES;);
}

-(void)CallBack_DisconnetedPerpheral:(NSString *)uuidString
{
    [super CallBack_DisconnetedPerpheral:uuidString];
    DDWeakVV
    NextWaitInMain(
                   DDStrongVV
                   //self.btnAll.enabled = NO;
                   [self setAllControlEnable];);
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
