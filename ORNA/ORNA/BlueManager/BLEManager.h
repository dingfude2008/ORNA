//
//  BLEManager.h
//  BLE
//
//  Created by 丁付德 on 15/5/24.
//  Copyright (c) 2015年 丁付德. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "NSData+ToString.h"

// 蓝牙协议
@protocol BLEManagerDelegate <NSObject>  // 回调函数


@optional // -------------------------------------------------------  根据需要实现的代理方法（ 可以不实现 ）
/**
 *  扫描到的设备字典
 */
-(void)Found_CBPeripherals:(NSMutableDictionary *)recivedTxt;

// ------------------------------------------------------- 蓝牙的系统回调

/**
 *  连接上设备的回调
 */
-(void)CallBack_ConnetedPeripheral:(NSString *)uuidString;


/**
 *  断开了设备的回调
 */
-(void)CallBack_DisconnetedPerpheral:(NSString *)uuidString;


// ------------------------------------------------------- 根据业务的需要，自定义的回调

/**
 *  业务回调
 */
-(void)CallBack_Data:(int)type uuidString:(NSString *)uuidString obj:(NSObject *)obj;


/**
 *  业务回调
 */
-(void)CallBack_BeginSearch;

/**
 *  业务回调
 */
-(void)CallBack_FinishSearch;

/**
 *  业务回调
 */
-(void)CallBack_;

/**
 *  业务回调
 */
-(void)CallBack_ManageStateChange:(BOOL)isON;


@end

@interface BLEManager : NSObject
{
    NSDate *beginDate;                       //  私有时间日期，用于记录重发，和重连  时间比较
    
    NSInteger num;                           //  私有次数变量，用于记录重发，和重连  次数比较
    
    BOOL isRest;
}

@property (nonatomic, weak) id<BLEManagerDelegate>    delegate;

@property (nonatomic, strong) CBCentralManager *        Bluetooth;              // 中心设备实例

@property (nonatomic, strong) NSMutableDictionary *     dicConnected;           // 连接中的设备集合  key:uuidString  value:连接的对象

@property (nonatomic, strong) NSMutableDictionary *     dic;                    // 连接中的设备集合  key:uuidString  value:连接的对象

@property (nonatomic, strong) CBPeripheral *            per;                    // 当前的设备处理对象

@property (nonatomic, copy)   NSString *                filter;                 //  过滤条件 （名字）

@property (nonatomic, assign) NSInteger                 connetNumber;           //  重连的次数

@property (nonatomic, assign) NSInteger                 connetInterval;         //  重连的时间间隔 （单位：秒）

@property (nonatomic, assign) NSInteger                 sendNumber;             //  重发的次数

@property (nonatomic, assign) NSInteger                 sendInterval;           //  重发的时间间隔 （单位：秒）

@property (nonatomic, assign) BOOL                      isFailToConnectAgain;   //  是否断开重连

@property (nonatomic, assign) BOOL                      isSendRepeat;           //  是否在没收到回复的时候 重新发送指令

@property (nonatomic, assign) BOOL                      isLock;                 //   加锁  用于读取数据过程中

@property (nonatomic, assign) BOOL                      isBeginOK;              //   是否正常开始了 （ 读时间是否有回来 ）

@property (nonatomic ,assign) BOOL                       isLink;                // 当前是否连接上  nonatomic

@property (nonatomic ,assign) BOOL                       isOn;                  // 蓝牙是否开启

@property (nonatomic ,assign) BOOL                       isScaning;             // 蓝牙是否正在扫描

@property (nonatomic ,strong) NSArray *arrValue;  // 0:模式 1:速度 2:亮度 3:R 4:G 5:B 6:W
                                                  // 速度  150-5
                                                  // 亮度范围这里面存的RGB的均值 50 - 250 如果求最大亮度是RGB中最大的那个
                                                  // RGB     0 - 255  这个在写入的时候，还有读出的时候转化






/**
 *  实例化 单例方法
 */
+ (BLEManager *)sharedManager;

/**
 *  重置所有状态
 */
+ (void)resetBLE;

/**
 *  开始扫描 （ 初始化中心设备，会导致已经连接的设备断开 ）
 */
-(void)startScan;

/**
 *  连接设备
 */
- (void)connect:(NSString *)uuidString;

/**
 *  主动断开的设备。如果为nil，会断开所有已经连接的设备
 */
-(void)stopLink:(NSString *)uuidString;

/**
 *  停止扫描
 */
- (void)stopScan;

/**
 *  自动重连
 */
-(void)retrievePeripheral:(NSString *)uuidString;


/**
 *  测试
 */
-(void)readChara:(NSString *)uuidString charUUID:(NSString *)charUUID;

/**
 *  开始
 */
- (void)begin:(NSString *)uuid;

// 设置是否待机
- (void)swithStandbyOrWorking:(NSString *)uuidString
                    isStandby:(BOOL)isStandby;

// 设置是否渐变
- (void)swithDynamicOrStatic:(NSString *)uuidString
                   isDynamic:(BOOL)isDynamic;
// 设置是否颜色
- (void)setRGB:(NSString *)uuidString
           RGB:(NSArray*)RGB;
// 设置亮度
- (void)setBrightness:(NSString *)uuidString
           brightness:(int)brightness;
// 设置速度
- (void)setSpeed:(NSString *)uuidString
           speed:(int)speed;

// 设置速度
- (void)test:(NSString *)uuidString;



@end
