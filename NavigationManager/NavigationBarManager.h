
/***********************************************************
 
 File name: NavigationBarManager.h
 Author:    zouweifang
 Description:
 导航栏渐变效果
 
 History:
 2017/8/2: Created
 
 ************************************************************/

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NavigationBarManager : NSObject
/** 导航栏背景色 default is white */
@property (nonatomic, strong) UIColor *barColor;
/** NavigationBar subviews color */
@property (nonatomic, strong) UIColor *tintColor;
/** 背景Image default is nil */
@property (nonatomic, strong) UIImage *backgroundImage;
/**  状态栏风格 default is UIStatusBarStyleDefault */
@property (nonatomic, assign) UIStatusBarStyle statusBarStyle;
/** 此刻偏移时alpha为0  color will changed begin this offset, default is -64 */
@property (nonatomic, assign) float zeroAlphaOffset;
/** 此刻偏移时alpha为1  color alpha will be 1 in this offset, default is 200 */
@property (nonatomic, assign) float fullAlphaOffset;
/** 导航栏最小透明度 default is 0 */
@property (nonatomic, assign) float minAlphaValue;
/** 导航栏最大透明度 default is 1 */
@property (nonatomic, assign) float maxAlphaValue;
/** if you set this property, the tintColor will changed in fullAlphaOffset */
@property (nonatomic, strong) UIColor *fullAlphaTintColor;
/** if you set this property, the barStyle will changed in fullAlphaOffset */
@property (nonatomic, assign) UIStatusBarStyle fullAlphaBarStyle;
/** if allchange = yes, the tintColor will changed with the barColor change, default is yes, if you only want to change barColor, set allChange = NO */
@property (nonatomic, assign) BOOL allChange;
/** this will cause that if currentAlpha = 0.3,it will be 1 - 0.3 = 0.7 */
@property (nonatomic, assign) BOOL reversal;
/** when continues = YES, bar color will changed whenever you scroll, if you set continues = NO,it only be changed in the fullAlphaOffset */
@property (nonatomic, assign) BOOL continues;

/** 
 以下几个方法均为属性的setter方法  
 
 */
+ (void)setBarColor:(UIColor *)color;
+ (void)setTintColor:(UIColor *)color;
+ (void)setBackgroundImage:(UIImage *)image;
+ (void)setStatusBarStyle:(UIStatusBarStyle)style;

+ (void)setZeroAlphaOffset:(float)offset;
+ (void)setFullAlphaOffset:(float)offset;
+ (void)setMaxAlphaValue:(float)value;
+ (void)setMinAlphaValue:(float)value;

+ (void)setFullAlphaTintColor:(UIColor *)color;
+ (void)setFullAlphaBarStyle:(UIStatusBarStyle)style;

+ (void)setAllChange:(BOOL)allChange;
+ (void)setReversal:(BOOL)reversal;
+ (void)setContinues:(BOOL)continues;

/**
 NavigationBarManager初始化方法
 
 @param viewController 传入的VC
 */
+ (void)managerWithController:(UIViewController *)viewController;

/**
 控制导航栏透明度（implemention this method in @selectot(scrollView: scrollViewDidScroll)）
 
 @param currentOffset 偏移量
 @param titleView 导航栏上的自定义View
 */
+ (void)changeAlphaWithCurrentOffset:(CGFloat)currentOffset TitleView:(UIView *)titleView;
/**
 设置为系统导航栏
 */
+ (void)reStoreToSystemNavigationBar;

@end
