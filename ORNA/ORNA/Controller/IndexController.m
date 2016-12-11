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
#import "DFSound.h"

@interface IndexController ()<ZWColorPickerDelegate>
{
    BOOL isFirstLoad;
    
    BOOL isDynamic;     // 是否处于渐变模式
    
}

@property (weak, nonatomic) IBOutlet ColorPickerView *imageView;
@property (weak, nonatomic) IBOutlet CircleView *circleView;

@property (weak, nonatomic) IBOutlet UIButton *btnAll;
@property (weak, nonatomic) IBOutlet UIImageView *imvBtnAll;

@property (weak, nonatomic) IBOutlet DFSlider *sliderLightness;
@property (weak, nonatomic) IBOutlet DFSlider *sliderSpeed;
@property (weak, nonatomic) IBOutlet UILabel *lblTest;
@property (weak, nonatomic) IBOutlet UILabel *lblTest2;
@property (weak, nonatomic) IBOutlet UILabel *lblTest3;
@property (weak, nonatomic) IBOutlet UILabel *lblTest4;


@property (assign, nonatomic) BOOL isDelayOver;
@property (weak, nonatomic) IBOutlet UIButton *btnStatic;
@property (weak, nonatomic) IBOutlet UIButton *btnDynamic;
@property (weak, nonatomic) IBOutlet UIImageView *imvStatic;
@property (weak, nonatomic) IBOutlet UIImageView *imvDynamic;
@property (weak, nonatomic) IBOutlet UILabel *lblConnectedName;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imvComylogoTop;


//@property (weak, nonatomic) IBOutlet UILabel *lblConnectedName;

@end

@implementation IndexController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self setNavTitle:@"ORNA"];
    [self initLeftButton:@"menu" text:nil];
    [self initRightButton:@"disconnected" text:nil isGif:NO];
    
    self.imvBtnAll.layer.cornerRadius = 20;
    self.imvBtnAll.layer.borderWidth = 1;
    self.imvBtnAll.layer.borderColor = [UIColor whiteColor].CGColor;
    self.imvBtnAll.layer.masksToBounds = YES;
    
    self.circleView.circleRadius = (ScreenWidth * 0.618 + 30 ) / 2;
    self.circleView.circleWidth = 5;
    self.circleView.backgroundColor= [UIColor clearColor];
    
    self.sliderLightness.minimumValue = 5;             // 客户要求改为最低5
    self.sliderLightness.maximumValue = 255;
    
    self.sliderSpeed.minimumValue = 20;
    self.sliderSpeed.maximumValue = 100;
    
    // RGB(143, 187, 226)
    UIColor *sliderColor = RGB(143, 187, 226);
    // 旋转
    self.sliderSpeed.transform = CGAffineTransformRotate(self.sliderSpeed.transform, -M_PI);
    self.sliderLightness.minimumTrackTintColor = sliderColor;
    self.sliderLightness.maximumTrackTintColor = [UIColor lightGrayColor];
    
    self.sliderSpeed.minimumTrackTintColor = [UIColor lightGrayColor];
    self.sliderSpeed.maximumTrackTintColor = sliderColor;
    
    
    __weak typeof(self) weakself = self;
    [self.imageView setPickerStyle:0 andBlock:^(UIColor *color, BOOL isNow) {
        [weakself changecolor:color isNow:isNow];
    }];
    
    isFirstLoad = YES;
    
#ifdef DEBUG
    self.lblTest.hidden = self.lblTest2.hidden = NO;
#else
    self.lblTest.hidden = self.lblTest2.hidden = YES;
#endif
    
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
        [self setAllControlEnable];
    }else{
        [self initRightButton:DisConnectedImage text:nil isGif:NO];
        [self setAllControlEnable];
    }
    [self refreshLblConnectedName];
}

-(void)setAllControlEnable
{
    self.btnAll.enabled = NO;
    self.imageView.userInteractionEnabled = NO;
    self.sliderSpeed.enabled = NO;
    self.sliderLightness.enabled = NO;
}


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
            UIAlertView *alert = [UIAlertView bk_showAlertViewWithTitle:@"Alert\n"
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

- (void)changecolor:(UIColor *)color isNow:(BOOL)isNow{
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
        [DDBLE setRGB:@[@(R),@(G),@(B)] isNow:isNow];
    }
}

- (void)refreshImvBtnAll{
    self.imvBtnAll.image = [UIImage imageNamed:(self.btnAll.selected ? @"swith_on" : @"swith_off")];
}


- (void)refreshLblConnectedName{
    self.lblConnectedName.text = DDBLE.isLink ? [NSString stringWithFormat:@"Connected to '%@'", DDBLE.per.name] : @"";
    self.imvComylogoTop.constant = DDBLE.isLink ? 5 : 10;
}

- (IBAction)btnAllClick:(UIButton *)sender {
    if (self.btnAll.selected) {
        self.btnAll.selected = NO;
        [DDBLE swithStandbyOrWorking:YES];
    }else{
        self.btnAll.selected = YES;
        [DDBLE swithStandbyOrWorking:NO];
    }
    [self refreshImvBtnAll];
    
    [DFSound vibrate];
}



//- (IBAction)sliderBrightnessTouchUpInside:(id)sender {
//    [self sliderBrightnessChangeEnd:sender];
//}
//
//- (IBAction)sliderBrightnessTouchUpOutside:(id)sender {
//    [self sliderBrightnessChangeEnd:sender];
//}
//
//- (IBAction)sliderBrightnessTouchCancel:(id)sender {
//    [self sliderBrightnessChangeEnd:sender];
//}
- (IBAction)sliderBrightnessChangeEnd:(UISlider *)sender{
    NSLog(@"拖动结束了");
    [DDBLE setBrightness:sender.value isNow:YES];
}


- (IBAction)sliderSpeedChangeEnd:(UISlider *)sender{
    NSLog(@"拖动结束了");
    [DDBLE setSpeed:sender.value isNow:YES];
}


- (IBAction)sliderBrightnessChange:(UISlider *)sender {
    [DDBLE setBrightness:sender.value isNow:NO];
}
- (IBAction)sliderSpeedChange:(UISlider *)sender {
    [DDBLE setSpeed:sender.value isNow:NO];
}
- (IBAction)btnStaticClick:(UIButton *)sender {
    if ([DDBLE.arrValue[0] intValue] == 1 && DDBLE.isLink) {
        [DDBLE swithDynamicOrStatic:NO];
        [DFSound vibrate];
    }
}
- (IBAction)btnDynamicClick:(UIButton *)sender {
    if ([DDBLE.arrValue[0] intValue] == 0 && DDBLE.isLink) {
        [DDBLE swithDynamicOrStatic:YES];
        [DFSound vibrate];
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
        
        [self refreshImvBtnAll];
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
                   self.btnAll.enabled = YES;
                   [self refreshLblConnectedName];);
}

-(void)CallBack_DisconnetedPerpheral:(NSString *)uuidString
{
    [super CallBack_DisconnetedPerpheral:uuidString];
    DDWeakVV
    NextWaitInMain(
                   DDStrongVV
                   [self setAllControlEnable];
                   [self refreshLblConnectedName];);
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)slia:(UISlider *)sender {
}
@end
