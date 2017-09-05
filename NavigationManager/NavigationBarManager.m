/***********************************************************
 
 File name: NavigationBarManager.m
 Author:    zouweifang
 Description:
 导航栏渐变效果
 
 History:
 2017/8/2: Created
 
 ************************************************************/

#import "NavigationBarManager.h"

static const CGFloat kNavigationBarHeight  = 64.0f;//导航栏高度
static const CGFloat kDefaultFullOffset    = 200.0f;//默认偏移
static const float   kMaxAlphaValue        = 0.995f;//最大透明度
static const float   kMinAlphaValue        = 0.0f;//最小透明度
static const float   kDefaultAnimationTime = 0.35f;//默认动画时长

#define SCREEN_RECT [UIScreen mainScreen].bounds
#define BACKGROUNDVIEW_FRAME CGRectMake(0, -20, CGRectGetWidth(SCREEN_RECT), kNavigationBarHeight)

@interface NavigationBarManager ()
/** 导航栏 */
@property (nonatomic, strong) UINavigationBar *selfNavigationBar;
/** 导航控制器 */
@property (nonatomic, strong) UINavigationController *selfNavigationController;
/** 导航栏透明度为1 */
@property (nonatomic, assign) BOOL setFull;
/** 导航栏透明度为0 */
@property (nonatomic, assign) BOOL setZero;
/** 导航栏透明度在改变 */
@property (nonatomic, assign) BOOL setChange;

@end

@implementation NavigationBarManager
#pragma mark - Public Method 公开方法（头文件声明的方法）

/**
 NavigationBarManager初始化方法

 @param viewController 传入的VC
 */
+ (void)managerWithController:(UIViewController *)viewController {
    UINavigationBar *navigationBar = viewController.navigationController.navigationBar;
    [self sharedManager].selfNavigationController = viewController.navigationController;
    [self sharedManager].selfNavigationBar = navigationBar;
    [navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [navigationBar setShadowImage:[UIImage new]];
}

/**
 控制导航栏透明度

 @param currentOffset 偏移量
 @param titleView 导航栏上的自定义View
 */
+ (void)changeAlphaWithCurrentOffset:(CGFloat)currentOffset TitleView:(UIView *)titleView {
    NavigationBarManager *manager = [self sharedManager];
    
    float currentAlpha = [self curretAlphaForOffset:currentOffset];
    
    if (![manager.barColor isEqual:[UIColor clearColor]]) {
        if (!manager.continues) {
            if (currentAlpha == manager.minAlphaValue) {
                [self setNavigationBarColorWithAlpha:manager.minAlphaValue];
                titleView.hidden = YES;
            } else if (currentAlpha == manager.maxAlphaValue) {
                [UIView animateWithDuration:kDefaultAnimationTime animations:^{
                    [self setNavigationBarColorWithAlpha:manager.maxAlphaValue];
                    titleView.hidden = NO;
                }];
                manager.setChange = YES;
            } else {
                if (manager.setChange) {
                    [UIView animateWithDuration:kDefaultAnimationTime animations:^{
                        [self setNavigationBarColorWithAlpha:manager.minAlphaValue];
                        titleView.hidden = YES;

                    }];
                    manager.setChange = NO;
                }
            }
        } else {
            [self setNavigationBarColorWithAlpha:currentAlpha];
        }
    }
    
    if (manager.allChange) [self changeTintColorWithOffset:currentAlpha];
}


#pragma mark - Private Method 私有方法

/**
 计算当前透明度

 @param offset 偏移量
 @return 当前透明度
 */
+ (float)curretAlphaForOffset:(CGFloat)offset {
    NavigationBarManager *manager = [self sharedManager];
    float currentAlpha = (offset - manager.zeroAlphaOffset) / (float)(manager.fullAlphaOffset - manager.zeroAlphaOffset);
    currentAlpha = currentAlpha < manager.minAlphaValue ? manager.minAlphaValue : (currentAlpha > manager.maxAlphaValue ? manager.maxAlphaValue : currentAlpha);
    currentAlpha = manager.reversal ? manager.maxAlphaValue + manager.minAlphaValue - currentAlpha : currentAlpha;
    return currentAlpha;
}

/**
 改变tintColor

 @param currentAlpha 当前透明度
 */
+ (void)changeTintColorWithOffset:(float)currentAlpha {
    NavigationBarManager *manager = [self sharedManager];
    if (currentAlpha >= manager.maxAlphaValue && manager.fullAlphaTintColor != nil) {
        if (manager.setFull) {
            manager.setFull = NO;
            manager.setZero  = YES;
        } else {
            if (manager.reversal) {
                manager.setFull = YES;
            }
            return;
        }
        manager.selfNavigationBar.tintColor = manager.fullAlphaTintColor;
        [self setTitleColorWithColor:manager.fullAlphaTintColor];
        [self setUIStatusBarStyle:manager.fullAlphaBarStyle];
    } else if (manager.tintColor != nil) {
        if (manager.setZero) {
            manager.setZero = NO;
            manager.setFull = YES;
        } else {
            return;
        }
        manager.selfNavigationBar.tintColor = manager.tintColor;
        [self setTitleColorWithColor:manager.tintColor];
        [self setUIStatusBarStyle:manager.statusBarStyle];
    }
}

/**
 创建单例

 @return NavigationBarManager
 */
+ (NavigationBarManager *)sharedManager {
    static NavigationBarManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[NavigationBarManager alloc] init];
        [self initBaseData:manager];
    });
    return manager;
}

/**
 设置初始值

 @param manager NavigationBarManager
 */
+ (void)initBaseData:(NavigationBarManager *)manager {
    manager.maxAlphaValue = kMaxAlphaValue;
    manager.minAlphaValue = kMinAlphaValue;
    manager.fullAlphaOffset = kDefaultFullOffset;
    manager.zeroAlphaOffset = -kNavigationBarHeight;
    manager.setZero = YES;
    manager.setFull = YES;
    manager.allChange = YES;
    manager.continues = YES;
}

/**
 设置tintColor

 @param color color
 */
+ (void)setTitleColorWithColor:(UIColor *)color {
    NSMutableDictionary *textAttr = [NSMutableDictionary dictionaryWithDictionary:[self sharedManager].selfNavigationBar.titleTextAttributes];
    [textAttr setObject:color forKey:NSForegroundColorAttributeName];
    [self sharedManager].selfNavigationBar.titleTextAttributes = textAttr;
}

/**
 根据透明度设置设置导航栏BarColor

 @param alpha 透明度
 */
+ (void)setNavigationBarColorWithAlpha:(float)alpha {
    NavigationBarManager *manager = [self sharedManager];
    NSLog(@"alpha = %f", alpha);
    [self setBackgroundImage:[self imageWithColor:[manager.barColor colorWithAlphaComponent:alpha]]];
}

/**
 设置状态栏style

 @param style UIStatusBarStyle
 */
+ (void)setUIStatusBarStyle:(UIStatusBarStyle)style {
    [[UIApplication sharedApplication] setStatusBarStyle:style];
}

/**
 颜色转化UIImage

 @param color 颜色值
 @return UIImage
 */
+ (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0, 0, 1, 1);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [color setFill];
    CGContextFillRect(context, rect);
    UIImage *imgae = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return imgae;
}
#pragma mark - Getters and Setters Method getter和setter方法
+ (void)setBarColor:(UIColor *)color {
    [self sharedManager].barColor = color;
}
+ (void)setTintColor:(UIColor *)color {
    [self sharedManager].tintColor = color;
    [self sharedManager].selfNavigationBar.tintColor = color;
    [self setTitleColorWithColor:color];
}
+ (void)setBackgroundImage:(UIImage *)image {
    [[self sharedManager].selfNavigationBar setBackgroundImage:image
                                                 forBarMetrics:UIBarMetricsDefault];
}
+ (void)setStatusBarStyle:(UIStatusBarStyle)style {
    [self sharedManager].statusBarStyle = style;
    [[UIApplication sharedApplication] setStatusBarStyle:style];
}
+ (void)setZeroAlphaOffset:(float)offset {
    [self sharedManager].zeroAlphaOffset = offset;
}

+ (void)setFullAlphaOffset:(float)offset {
    [self sharedManager].fullAlphaOffset = offset;
}

+ (void)setMinAlphaValue:(float)value {
    value = value < kMinAlphaValue ? kMinAlphaValue : value;
    [self sharedManager].minAlphaValue = value;
}

+ (void)setMaxAlphaValue:(float)value {
    value = value > kMaxAlphaValue ? kMaxAlphaValue : value;
    [self sharedManager].maxAlphaValue = value;
}

+ (void)setFullAlphaTintColor:(UIColor *)color {
    [self sharedManager].fullAlphaTintColor = color;
}

+ (void)setFullAlphaBarStyle:(UIStatusBarStyle)style {
    [self sharedManager].fullAlphaBarStyle = style;
}

+ (void)setAllChange:(BOOL)allChange {
    [self sharedManager].allChange = allChange;
}

+ (void)setReversal:(BOOL)reversal {
    [self sharedManager].reversal = reversal;
}

+ (void)setContinues:(BOOL)continues {
    [self sharedManager].continues = continues;
}


+ (void)reStoreToSystemNavigationBar {
    [[self sharedManager].selfNavigationController setValue:[UINavigationBar new] forKey:@"navigationBar"];
}


@end
