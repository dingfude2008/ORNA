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

#import <UIKit/UIKit.h>

@interface BaseController: UIViewController

@property (nonatomic, weak) UIWindow *            windowView;

@property (nonatomic, weak) AppDelegate *         appDelegate;

-(void)initLeftButton:(NSString *)imgName
                 text:(NSString *)text;

-(void)initRightButton:(NSString *)imgName
                  text:(NSString *)text
                 isGif:(BOOL)isGif;

-(void)setNavTitle:(NSString *)title;

//点击按钮旋转到横屏或者竖屏
- (void)switchToLandscapeOrPortrait:(BOOL)isLandscape;

-(void)CallBack_ConnetedPeripheral:(NSString *)uuidString;

-(void)CallBack_DisconnetedPerpheral:(NSString *)uuidString;

@end
