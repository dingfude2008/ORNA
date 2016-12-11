//
//  BLEManager.m
//  BLE
//
//  Created by 丁付德 on 15/5/24.
//  Copyright (c) 2015年 丁付德. All rights reserved.
//

#import "BLEManager.h"
#import "BLEManager+Helper.h"

static BLEManager *manager;
//static BOOL isFirstStandby = NO; // 连接上是否是待机
static int countWrite = 0;
static int countWriteSuccess = 0;
@interface BLEManager()<CBCentralManagerDelegate,CBPeripheralDelegate>
{
    dispatch_queue_t __syncQueueMangerDidUpdate;
    NSDate *lastSetBrightnessDate;
    NSDate *lastSetSpeedDate;
    NSDate *lastSetRGB;
    
}

@end

@implementation BLEManager

@synthesize dic;

+(BLEManager *)sharedManager
{
    static dispatch_once_t pred;
    dispatch_once(&pred, ^{
        manager = [[BLEManager alloc] init];
        manager -> __syncQueueMangerDidUpdate = dispatch_get_global_queue(0, 0);
        manager.isOn = YES;
        [self resetBLE];
        manager -> dic = [[NSMutableDictionary alloc] init];
        manager -> beginDate = DNow;
        manager -> num = 0;
        manager.connetNumber = 100000000;
        manager.connetInterval = 1;
        manager.dicConnected = [[NSMutableDictionary alloc] init];
        manager.isFailToConnectAgain = YES;
        manager.isSendRepeat = NO;
        manager.isBeginOK = NO;
        manager.arrValue = @[@0,@20,@50,@0,@0,@0,@0];
        manager -> isRest = YES;
        manager -> lastSetBrightnessDate = [NSDate date];
        manager -> lastSetSpeedDate = [NSDate date];
        manager -> lastSetRGB = [NSDate date];
    });
    return manager;
}

-(void)setIsScaning:(BOOL)isScaning
{
    _isScaning = isScaning;
    if (isScaning) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(CallBack_BeginSearch)]) {
            [self.delegate CallBack_BeginSearch];
        }
    }else{
        if (self.delegate && [self.delegate respondsToSelector:@selector(CallBack_FinishSearch)]) {
            [self.delegate CallBack_FinishSearch];
        }
    }
}


+(void)resetBLE
{
    manager -> beginDate = DNow;
    manager -> num = 0;
    manager.connetNumber = 100000000;
    manager.connetInterval = 1;
    manager.dicConnected = [[NSMutableDictionary alloc] init];
    manager.isFailToConnectAgain = YES;
    manager.isSendRepeat = NO;
    manager.isBeginOK = NO;
}


-(void)startScan
{
    if (!self.Bluetooth)
    {
        dispatch_queue_t centralQueue = dispatch_queue_create("com.xinyi.Coasters", DISPATCH_QUEUE_SERIAL);
        self.Bluetooth = [[CBCentralManager alloc] initWithDelegate:self queue:centralQueue];
    }
    if (!self.isScaning)
    {
        self.Bluetooth.delegate = self;
        dic = [[NSMutableDictionary alloc]init];
        [self.Bluetooth scanForPeripheralsWithServices:nil options:@{CBCentralManagerScanOptionAllowDuplicatesKey: @YES}];
        DDWeakVV
        NextWaitInCurrentTheard(
                DDStrongVV
                [self stopScan];, DDSearchTime);
    }
    self.isScaning = YES;
}

- (void)stopScan
{
    if (self.Bluetooth)
    {
        if (self.isScaning) {
            [self.Bluetooth stopScan];
        }
        self.isScaning = NO;
    }
}

- (void)connect:(NSString *)uuidString
{
    if (uuidString) {
        CBPeripheral *peripheral = [dic objectForKey:uuidString];
        if (peripheral) {
            [_Bluetooth connectPeripheral:peripheral options:nil];
        }
    }
}

-(void)stopLink:(NSString *)uuidString
{
    self.isFailToConnectAgain = NO;
    [_Bluetooth cancelPeripheralConnection:self.per];
    self.per = nil;
}

/**
 *  自动连接
 *
 *  @param uuidString uuidString
 */
-(void)retrievePeripheral:(NSString *)uuidString
{
    NSUUID *nsUUID = [[NSUUID UUID] initWithUUIDString:uuidString];
    if(!nsUUID) return;
    BOOL isResStart = NO;
    if(nsUUID)
    {
        NSArray *peripheralArray = [self.Bluetooth retrievePeripheralsWithIdentifiers:@[nsUUID]];
        NSLog(@"NSUUID=%@", @(peripheralArray.count));
        if([peripheralArray count] > 0)
        {
            for(CBPeripheral *peripheral in peripheralArray)
            {
                [self stopScan];
                peripheral.delegate = self;
                [_Bluetooth connectPeripheral:peripheral options:nil];
            }
        }else{
            isResStart = YES;
        }
    }
    CBUUID *cbUUID = [CBUUID UUIDWithNSUUID:nsUUID];
    if (cbUUID)
    {
        NSArray *connectedPeripheralArray = [self.Bluetooth retrieveConnectedPeripheralsWithServices:@[cbUUID]];
        NSLog(@"CBUUID=%@", @(connectedPeripheralArray.count));
        if([connectedPeripheralArray count] > 0)
        {
            for(CBPeripheral *peripheral in connectedPeripheralArray)
            {
                [self stopScan];
                peripheral.delegate = self;
                [_Bluetooth connectPeripheral:peripheral options:nil];
            }
        }else{
            isResStart = YES;
        }
    }
    
    if (isResStart)
    {
        //NSLog(@"自动连接--- 重新扫描");
        [self startScan];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if ([dic.allKeys containsObject:uuidString]) {
                [self connect:uuidString];
            }
        });
    }
}
#pragma mark - CBCentralManagerDelegate 中心设备代理

/**
 *  当Central Manager被初始化，我们要检查它的状态，以检查运行这个App的设备是不是支持BLE
 *
 *  @param central 中心设备
 */
-(void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    dispatch_barrier_async(__syncQueueMangerDidUpdate, ^
    {
        if (![self isMemberOfClass:[BLEManager class]])return;
        switch (_Bluetooth.state)
        {
            case CBCentralManagerStatePoweredOff:
            case CBCentralManagerStateUnknown:
            case CBCentralManagerStateResetting:
            case CBCentralManagerStateUnsupported:
            case CBCentralManagerStateUnauthorized:
            {
                self.isBeginOK = NO;
                self.isLink    = NO;
                self.isOn      = NO;
                [self.dicConnected removeAllObjects];
                self.per = nil;
                if(self.delegate && [self.delegate respondsToSelector:@selector(CallBack_ManageStateChange:)]){
                    [self.delegate CallBack_ManageStateChange:NO];
                }
            }
                break;
            case CBCentralManagerStatePoweredOn:
            {
                self.isOn = YES;
                [_Bluetooth scanForPeripheralsWithServices:nil options:@{CBCentralManagerScanOptionAllowDuplicatesKey: @YES}];
                if(self.delegate && [self.delegate respondsToSelector:@selector(CallBack_ManageStateChange:)]){
                    [self.delegate CallBack_ManageStateChange:YES];
                }
                
            }
                break;
        }
    });
}


/**
 *  扫描到设备的回调
 *
 *  @param central           中心设备
 *  @param peripheral        扫描到的外设
 *  @param advertisementData 外设的数据集
 *  @param RSSI              信号
 */
-(void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI
{
//    float distance = powf(10, (abs([RSSI intValue]) - 59) / (10 * 2.0));
//    NSLog(@"设备名称 : %@ %@  距离 %.1f米", peripheral.name, [peripheral.identifier UUIDString], distance);
    
    if (peripheral.name && (([peripheral.name rangeOfString:Filter_Name].length) || ([peripheral.name rangeOfString:OtherFilter_Name].length)))
    {
        [dic setObject:peripheral forKey:[peripheral.identifier UUIDString]];
    }
    
    if (dic.count > 0 && [self.delegate respondsToSelector:@selector(Found_CBPeripherals:)])
    {
        [self.delegate Found_CBPeripherals:dic];
    }
    
    if (self.isLink) {
        [self stopScan];
    }
}


/**
 *  连接设备成功的方法回调
 *
 *  @param central    中央设备
 *  @param peripheral 外设
 */
- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
    peripheral.delegate = self;
    [peripheral discoverServices:nil];
    NSString *uuidString = [peripheral.identifier UUIDString];
    [self.dicConnected setObject:peripheral forKey:uuidString];
    self.per = peripheral;
    self.isLink = YES;
    [self.Bluetooth stopScan];
    SetUserDefault(DefaultUUIDString, uuidString);
    NSLog(@"连接成功了, 当前个数：%@  地址: %@", @(self.dicConnected.count), self);
    [self.delegate CallBack_ConnetedPeripheral:uuidString];
}


/**
 *  连接失败的回调
 *
 *  @param central    中心设备
 *  @param peripheral 外设
 *  @param error      error
 */
- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    NSLog(@"无法连接");
    if (self.isFailToConnectAgain)
        [self beginLinkAgain:peripheral];
}


/**
 *  被动断开
 *
 *  @param central    中心设备
 *  @param peripheral 外设
 *  @param error      error
 */
- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    NSLog(@"------------- > 连接被断开了");
    NSString *uuidString = [[peripheral identifier] UUIDString];
    
    self.isLink = NO;
    self.isLock = NO;
    self.isBeginOK = NO;
    
    [self.dicConnected removeObjectForKey:uuidString];
    self.per = nil;
    [self.delegate CallBack_DisconnetedPerpheral:uuidString];
    
    if (self.isFailToConnectAgain)
        [self beginLinkAgain:peripheral];
}

/**
 *  发现服务 扫描特性
 *
 *  @param peripheral 外设
 *  @param error      error
 */
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error
{
    if (!error)
    {
        peripheral.delegate = self;
        for (CBService *service in peripheral.services)
        {
            [peripheral discoverCharacteristics:nil forService:service];  // 扫描特性
        }
    }
    else
    {
        //NSLog(@"error:%@",error);
    }
}

/**
 *  发现特性 订阅特性    
 *
 *  @param peripheral 外设
 *  @param service    服务
 *  @param error      error
 */
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error//4
{
    //
//    if (!error)
//    {
//        for (CBCharacteristic *chara in [service characteristics])
//        {
//            
//            NSString *uuidString = [chara.UUID UUIDString];
//            if ([Arr_R_UUID containsObject:uuidString]) {
//                [peripheral setNotifyValue:YES forCharacteristic:chara];   // 订阅特性
//            }
//        }
//    }
}


/**
 *  订阅结果回调，我们订阅和取消订阅是否成功
 *
 *  @param peripheral     外设
 *  @param characteristic 特性
 *  @param error          error
 */
-(void)peripheral:(CBPeripheral *)peripheral didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    if (error)
    {
        //NSLog(@"error  %@",error.localizedDescription);
    }
    else
    {
        [peripheral readValueForCharacteristic:characteristic];
        //读取服务 注意：不是所有的特性值都是可读的（readable）。通过访问 CBCharacteristicPropertyRead 可以知道特性值是否可读。如果一个特性的值不可读，使用 peripheral:didUpdateValueForCharacteristic:error:就会返回一个错误。
    }
    
//    NSString *uuidString = [characteristic.UUID UUIDString];
//      如果不是我们要特性就退出
//    if (![uuidString isEqualToString:FeiTu_TIANYIDIAN_ReadUUID] &&
//        ![uuidString isEqualToString:FeiTu_YUNZU_ReadUUID] &&
//        ![uuidString isEqualToString:FeiTu_YUNDONG_ReadUUID] &&
//        ![uuidString isEqualToString:FeiTu_YUNCHENG_ReadUUID] &&
//        ![uuidString isEqualToString:FeiTu_YUNHUAN_ReadUUID])
//    {
//        return;
//    }
    
    if (characteristic.isNotifying)
    {
        //NSLog(@"外围特性通知开始");
    }
    else
    {
        //NSLog(@"外围设备特性通知结束，也就是用户要下线或者离开%@",characteristic);
    }
}


/**
 *  当我们订阅的特性值发生变化时 （ 就是， 外设向我们发送数据 ）
 *
 *  @param peripheral     外设
 *  @param characteristic 特性
 *  @param error          error
 */
- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error//6
{
    NSData *data = characteristic.value;   // 数据集合   长度和协议匹配
    NSString *uu = [characteristic.UUID UUIDString];
    if ([Arr_R_UUID containsObject:uu])
    {
        [self setData:data peripheral:peripheral charaUUID:uu];
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    NSString *uu = [characteristic.UUID UUIDString];
    uu = uu;
    countWriteSuccess ++;
    NSLog(@"写入成功的次数:%d", countWriteSuccess);
    [self.delegate CallBack_Data:10 uuidString:uu obj:nil];
}

-(void)readChara:(NSString *)uuidString charUUID:(NSString *)charUUID
{
     CBPeripheral * cbp = self.dicConnected[uuidString];
     NSArray *arry = [cbp services];
     if (!arry.count) NSLog(@"这里为空   charUUID:%@", charUUID);
     for (CBService *ser in arry)
     {
         NSString *serverUUIDTag = ServerUUID;
         if ([[ser.UUID UUIDString] isEqualToString:serverUUIDTag])
         {
             for (CBCharacteristic *chara in [ser characteristics])
             {
                 if ([[chara.UUID UUIDString] isEqualToString:charUUID])
                 {
                     NSLog(@"开始读  %@", charUUID);
                     [cbp readValueForCharacteristic:chara];
                     break;
                 }
             }
         }
     }
}


/**
 *  写入数据
 *
 *  @param data      数据集
 *  @param charaUUID  写入的特性值
 */
-(void)Command:(NSData *)data uuidString:(NSString *)uuidString charaUUID:(NSString *)charaUUID
{
    self.per = self.dicConnected[uuidString];
    if(!self.per || !data) return;
    NSArray *arry = [self.per services];
    for (CBService *ser in arry)
    {
        NSString *serverUUID = [ser.UUID UUIDString];
        NSString *serverUUIDTag = ServerUUID;
        if ([serverUUID isEqualToString:serverUUIDTag])
        {
            for (CBCharacteristic*chara in [ser characteristics])
            {
                if ([[chara.UUID UUIDString] isEqualToString:charaUUID])
                {
                    NSString *uuid = [[self.per identifier] UUIDString];
                    countWrite ++;
                    [data LogDataAndPrompt:uuid promptOther:[NSString stringWithFormat:@"%@ -- > 第%d次写入", charaUUID, countWrite]];
                    [self.per writeValue:data
                       forCharacteristic:chara
                                    type:CBCharacteristicWriteWithResponse];
                    break;
                }
            }
            break;
        }
    }
}

         
-(void)setData:(NSData *)data peripheral:(CBPeripheral *)peripheral charaUUID:(NSString *)charaUUID
{
    NSString *uuid = [[peripheral identifier] UUIDString];
    Byte *bytes = (Byte *)data.bytes;
    
    [data LogData];
    
    if ([self checkData:data])
    {
        //  A3
        if ([charaUUID isEqualToString:RW_Control_UUID])
        {
            self.isBeginOK = YES;
            /*
             HEAD[1], sMode[1], sSpeed[1], sLight[1], sPWM_R[1], sPWM_G[1], sPWM_B[1], sPWM_W[1], SUM [1]
             */
            int shead  = bytes[0];
            int sMode  = bytes[1];
            int sSpeed = bytes[2];
            sSpeed = sSpeed < 20 ? 20 : sSpeed;
            sSpeed = sSpeed > 100 ? 100 : sSpeed;
            double sPWM_R = bytes[4] * 255.0 / 250.0;
            double sPWM_G = bytes[5] * 255.0 / 250.0;
            double sPWM_B = bytes[6] * 255.0 / 250.0;
            int sPWM_W = bytes[7];
            int sLight = Bigger(Bigger(sPWM_R, sPWM_G), sPWM_B);
            if (sMode == 1) {
                sLight = (bytes[3]) * 255.0 / 250.0;
            }
            
            self.arrValue = @[@(sMode),@(sSpeed),@(sLight),@(sPWM_R),@(sPWM_G),@(sPWM_B),@(sPWM_W)];
            
            [self.delegate CallBack_Data:1 uuidString:uuid obj:self.arrValue];
            [self.delegate CallBack_Data:98 uuidString:uuid obj:[data ToString]];
            
//            NSArray *arrOld = GetUserDefault(DefaultDeviceValue);
//            if (!arrOld) {
//                [self.delegate CallBack_Data:1 uuidString:uuid obj:self.arrValue];
//            }
            
//            static BOOL isFirstInstall = NO; // 是否是第一次输入秘钥
            
            // 0:静态颜色模式, 1:渐变模式 0x7F :待机模式 0xFE:输入密匙模式
            if(shead == 0xF7)       //已经输入过密匙
            {
            }
            else//  需要输入密匙
            {
                [self setInit:uuid];
                DDWeakVV
                NextWaitInCurrentTheard(
                                        [weakself readChara:uuid charUUID:RW_Control_UUID];
                                        , 1);
            }
        }
    }
}


// ------------------------------------------------------------------------------

// ----------------------------- 私有方法 ----------------------------------------

// ------------------------------------------------------------------------------

/**
 *  开始断开重连
 *
 *  @param peripheral 要重新连接的设备
 */
-(void)beginLinkAgain:(CBPeripheral *)peripheral
{
    [self retrievePeripheral:[peripheral.identifier UUIDString]];
}

-(void)link:(NSTimer *)timerR
{
    NSLog(@"被动断开后，重新");
    CBPeripheral *cp = timerR.userInfo;
    [self retrievePeripheral:[cp.identifier UUIDString]];
}


// ------------------------------------------------------------------------------

// ----------------------------- 帮助方法 ----------------------------------------

// ------------------------------------------------------------------------------



- (void)begin:(NSString *)uuid
{
    if (!uuid || !uuid.length || self.Bluetooth.state != CBCentralManagerStatePoweredOn) return;
    NSLog(@"----------  开始了， uuid:%@", uuid);
    _isLock = YES;
    if (!_isBeginOK && self.isLink) {
        [self readChara:uuid charUUID:RW_Control_UUID];
    }
    
    // 这里开始读的时候， 可能链接还不稳定，  如果在一定时间内，没有返回数据，  应该再次读取    2秒
    DDWeak(self)
    NextWaitInCurrentTheard(
        DDStrong(self)
        if(self){
            if(!self.isBeginOK){
                [self begin:uuid];
            };
        }, 2);
}


////
-(void)setInit:(NSString *)uuidString
{
    // HEAD, 0xFE, 0x89, 0x78, 0x56, 0x41, 0x03, 0x21,SUM [1]
    self.arrValue = @[ @(0xFE),@(0x89),@(0x78),@(0x56),@(0x41),@(0x03),@(0x21) ];
    [self set:uuidString isInit:YES];
}



- (void)swithStandbyOrWorking:(BOOL)isStandby
{
    if (!self.per) {
        return;
    }
    NSString *uuidString = self.per.identifier.UUIDString;
    
    //0:模式 1:速度 2:亮度 3:R 4:G 5:B 6:W
    NSMutableArray *arrTag = [self.arrValue mutableCopy];
    arrTag[0] = @(!isStandby ? 1:127);
    arrTag[1] = @100;
    arrTag[2] = @50;
    
    double light = [self.arrValue[2] doubleValue];
    double newLight = 50.0;
    double r = [self.arrValue[3] doubleValue];
    double g = [self.arrValue[4] doubleValue];
    double b = [self.arrValue[5] doubleValue];
    
    double R,G,B;
    double percent = newLight / light;
    if (r >= g && r >= b)
    {
        R = newLight;
        G = g * percent;
        B = b * percent;
    }
    else if (g >= r && g >= b)
    {
        R = r * percent;
        G = newLight;
        B = b * percent;
    }
    else if (b >= r && b >= g)
    {
        R = r * percent;
        G = g * percent;
        B = newLight;
    }
    
    arrTag[3] = @(R);
    arrTag[4] = @(G);
    arrTag[5] = @(B);
    
    self.arrValue = [arrTag mutableCopy];
    [self set:uuidString isInit:NO];
}



- (void)swithDynamicOrStatic:(BOOL)isDynamic
{
    if (!self.per) {
        return;
    }
    NSString *uuidString = self.per.identifier.UUIDString;
    //0:模式 1:速度 2:亮度 3:R 4:G 5:B 6:W
    NSMutableArray *arrTag = [self.arrValue mutableCopy];
    arrTag[0] = @(isDynamic ? 1:0);
    self.arrValue = [arrTag mutableCopy];
    [self set:uuidString isInit:NO];
}


- (void)setRGB:(NSArray*)RGB
         isNow:(BOOL)isNow{
    if (!self.per) {
        return;
    }
    NSDate *now = [NSDate date];
    if(!isNow){
        if(fabs([now timeIntervalSinceDate:lastSetRGB]) < 0.1){
            NSLog(@"设置RGB间隔太短了");
            return;
        }
    }
    
    lastSetRGB = now;
    
    NSString *uuidString = self.per.identifier.UUIDString;
    double R_old = [self.arrValue[3] doubleValue];
    double G_old = [self.arrValue[4] doubleValue];
    double B_old = [self.arrValue[5] doubleValue];
    
    double R,G,B;
    double light = Bigger(Bigger(R_old, G_old), B_old);  // 当前亮度
    if (light == 255)  // 最大亮度，说明不用缩放
    {
        R = [RGB[0] doubleValue];
        G = [RGB[1] doubleValue];
        B = [RGB[2] doubleValue];
    }
    else    // 当前亮度不是255， 就要缩放
    {
        double r = [RGB[0] doubleValue];;
        double g = [RGB[1] doubleValue];;
        double b = [RGB[2] doubleValue];;
        
        double percent = 0;
        if (r >= g && r >= b)
        {
            percent = light / r;
            R = light;
            G = g * percent;
            B = b * percent;
        }
        else if (g >= r && g >= b)
        {
            percent = light / g;
            R = r * percent;
            G = light;
            B = b * percent;
        }
        else if (b >= r && b >= g)
        {
            percent = light / b;
            R = r * percent;
            G = g * percent;
            B = light;
        }
    }
    
//    
//    NSLog(@"原始的RGB:%.0f,%.0f,%.0f,")
    
    //0:模式 1:速度 2:亮度 3:R 4:G 5:B

    NSMutableArray *arrTag = [self.arrValue mutableCopy];
    arrTag[3] = @(R);
    arrTag[4] = @(G);
    arrTag[5] = @(B);
    arrTag[2] = @(Bigger(Bigger(R, G), B));
    
    self.arrValue = [arrTag mutableCopy];
    
    [self set:uuidString isInit:NO];
}


- (void)setBrightness:(int)brightness
                isNow:(BOOL)isNow{
    if (!self.per) {
        return;
    }
    
    NSDate *now = [NSDate date];
    if(!isNow){
        if(fabs([now timeIntervalSinceDate:lastSetBrightnessDate]) < 0.1){
            NSLog(@"设置亮度间隔太短了");
            return;
        }
    }
    lastSetBrightnessDate = now;
    
    NSString *uuidString = self.per.identifier.UUIDString;
    //0:模式 1:速度 2:亮度 3:R 4:G 5:B 6:W
    NSMutableArray *arrTag = [self.arrValue mutableCopy];
    
    int model = [arrTag[0] intValue];
    
    double R_old = [arrTag[3] doubleValue];
    double G_old = [arrTag[4] doubleValue];
    double B_old = [arrTag[5] doubleValue];
    
    double light_old;
    if (model == 0) {
        light_old = Bigger(Bigger(R_old, G_old), B_old);
    }else if(model == 1){
        light_old = [arrTag[2] intValue];
    }
    
    // 新/久
    double percent = (double)brightness / (double)light_old;
    
    double newR = R_old * percent;
    double newG = G_old * percent;
    double newB = B_old * percent;
    
    if (newR >= newG && newR >= newB) {
        newR = brightness;
    }else if (newG >= newR && newG >= newB){
        newG = brightness;
    }else if (newB >= newR && newB >= newR){
        newB = brightness;
    }
    
    
    newR = newR > 255.0 ? 255.0 : newR;
    newG = newG > 255.0 ? 255.0 : newG;
    newB = newB > 255.0 ? 255.0 : newB;
    
    arrTag[3] = @(newR);
    arrTag[4] = @(newG);
    arrTag[5] = @(newB);
    
    
    if (model == 0) {
        arrTag[2] = @(Bigger(Bigger(newR, newG), newB));
    }else if(model == 1){
        arrTag[2] = @(brightness);;
    }
    
    NSLog(@"设置亮度前 %@-%@-%@-%@,", self.arrValue[2],self.arrValue[3],self.arrValue[4],self.arrValue[5]);
    
    
    self.arrValue = [arrTag mutableCopy];
    
    NSLog(@"设置亮度后 %@-%@-%@-%@,", self.arrValue[2],self.arrValue[3],self.arrValue[4],self.arrValue[5]);
    
    [self set:uuidString isInit:NO];
}
// 设置速度
- (void)setSpeed:(int)speed
           isNow:(BOOL)isNow{
    if (!self.per) {
        return;
    }
    NSDate *now = [NSDate date];
    if(!isNow){
        if(fabs([now timeIntervalSinceDate:lastSetSpeedDate]) < 0.1){
            NSLog(@"设置亮度间隔太短了");
            return;
        }
    }
    lastSetSpeedDate = now;
    
    NSString *uuidString = self.per.identifier.UUIDString;
    //0:模式 1:速度 2:亮度 3:R 4:G 5:B 6:W
    NSMutableArray *arrTag = [self.arrValue mutableCopy];
    arrTag[1] = @(speed);
    self.arrValue = [arrTag mutableCopy];
    [self set:uuidString isInit:NO];
}


- (void)set:(NSString *)uuidString isInit:(BOOL)isInit
{
    // HEAD[1], sMode[1], sSpeed[1], sLight[1], sPWM_R[1], sPWM_G[1], sPWM_B[1], sPWM_W[1], SUM [1]
    // 0头， 1模式，2速度， 3亮度，4R, 5G, 6B， 7W, 8总和
    // 模式  静态：0x00 动态：0x01  待机：F7
    // 速度   5- 250
    // 亮度   后面的RGB总和
    // RGB,  0~250
    //
    //  0:模式 1:速度 2:亮度 3:R 4:G 5:B 6:W
    
    
    
    int model = [self.arrValue[0] intValue];
    int speed = [self.arrValue[1] intValue];
    int light, R, G, B, W;
    if(isInit)
    {
        light = [self.arrValue[2] intValue];
        R = [self.arrValue[3] intValue];
        G = [self.arrValue[4] intValue];
        B = [self.arrValue[5] intValue];
        W = [self.arrValue[6] intValue];
    }
    else
    {
        W = 0;
        if (model == 1) {
            light = [self.arrValue[2] intValue] / 255.0 * 250;
            R = G = B = 0;
            
            light = light < 50 ? 50 : light;
            light = light > 250 ?250: light;
            
            speed = speed < 20 ? 20 : speed;
            speed = speed > 100 ? 100:speed;
            
        }else{
            R = [self.arrValue[3] doubleValue] / 255.0 * 250;
            G = [self.arrValue[4] doubleValue] / 255.0 * 250;
            B = [self.arrValue[5] doubleValue] / 255.0 * 250;
            light = speed = 0;
        }
    }
    
    NSLog(@"%d,%d,%d,%d,%d", light, speed, R, G, B);
    
    // 0头， 1模式，2速度， 3亮度，4R, 5G, 6B， 7W, 8总和
    
    char data[9];
    data[0] = DataFirst;
    data[1] = model & 0xFF;
    data[2] = speed & 0xFF;
    data[3] = light & 0xFF;;
    data[4] = R & 0xFF;
    data[5] = G & 0xFF;
    data[6] = B & 0xFF;
    data[7] = W & 0xFF;
    
    int sum = 0;
    for (int i = 1; i < 8; i++) {
        sum += (data[i]) ^ i;
    }
    data[8] = sum & 0xFF;
    
    
    [self.delegate CallBack_Data:1 uuidString:uuidString obj:self.arrValue];
    
    NSData *dataPush = [NSData dataWithBytes:data length:9];
    
    [self.delegate CallBack_Data:99 uuidString:uuidString obj:[dataPush ToString]];
    
    [self Command:dataPush
       uuidString:uuidString
        charaUUID:RW_Control_UUID];
}

- (void)test:(NSString *)uuidString
{
    //0:模式 1:速度 2:亮度 3:R 4:G 5:B 6:W
    // F7 00 00 00 0xE0，00 00 00 sum
    
    static int test = 1;
    test ++;
//    test = 0;
    if (test % 3 == 0) {
        self.arrValue = @[@0,@0,@0,@255,@0,@0,@0 ];
    }else if(test % 3 == 1) {
        self.arrValue = @[@0,@0,@0,@0,@255,@0,@0 ];
    }else if(test % 3 == 2) {
        self.arrValue = @[@0,@0,@0,@0,@0,@255,@0 ];
    }
    
    [self set:uuidString isInit:NO];
}




@end
