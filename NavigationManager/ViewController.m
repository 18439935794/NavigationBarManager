//
//  ViewController.m
//  NavigationManager
//
//  Created by weifangzou on 2017/9/5.
//  Copyright © 2017年 Ttpai. All rights reserved.
//

#import "ViewController.h"
#import "NavigationBarManager.h"
#import "TTPSuspendView.h"
#define kScaleLength(length) (length) * [UIScreen mainScreen].bounds.size.width / 320

#define kSpace 0

@interface ViewController ()<UIScrollViewDelegate>
@property(nonatomic,strong)UIScrollView *scrollView;
@property (nonatomic, strong) TTPSuspendView *titleView;

@property (nonatomic, strong) TTPSuspendView *searchBarView;

@property (nonatomic, strong) UIButton *backBtn;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.view addSubview:self.scrollView];
    [self.view addSubview:self.backBtn];
    [self.navigationController.navigationBar addSubview:self.searchBarView];
    
    [self.navigationItem setHidesBackButton:YES];
    [self initBarManager];

}
//以下三种方式设置导航栏的变化方式：突现、渐变、反转（只能设置一种）
//突现
- (void)initBarManager {
    
    [NavigationBarManager managerWithController:self];
    [NavigationBarManager setBarColor:[UIColor colorWithRed:0.5 green:0.5 blue:1 alpha:1]];
    [NavigationBarManager setTintColor:[UIColor colorWithRed:0.15 green:0.15 blue:0.15 alpha:1]];
    [NavigationBarManager setStatusBarStyle:UIStatusBarStyleDefault];
    [NavigationBarManager setFullAlphaTintColor:[UIColor whiteColor]];
    [NavigationBarManager setFullAlphaBarStyle:UIStatusBarStyleLightContent];
    
    //if you don't want to change anytime, set continues = NO
    [NavigationBarManager setContinues:NO];
}
//渐变
//- (void)initBarManager {
//    [NavigationBarManager managerWithController:self];
//
//    [NavigationBarManager setBarColor:[UIColor colorWithRed:0.5 green:0.5 blue:1 alpha:1]];
//    [NavigationBarManager setTintColor:[UIColor colorWithRed:0.15 green:0.15 blue:0.15 alpha:1]];
//    [NavigationBarManager setStatusBarStyle:UIStatusBarStyleDefault];
//    [NavigationBarManager setZeroAlphaOffset:-64];
//    [NavigationBarManager setFullAlphaOffset:200];
//    [NavigationBarManager setFullAlphaTintColor:[UIColor whiteColor]];
//    [NavigationBarManager setFullAlphaBarStyle:UIStatusBarStyleLightContent];
//}
//反转
//- (void)initBarManager {
//
//    [NavigationBarManager managerWithController:self];
//    [NavigationBarManager setBarColor:[UIColor colorWithRed:0.5 green:0.5 blue:1 alpha:1]];
//    [NavigationBarManager setTintColor:[UIColor colorWithRed:0.15 green:0.15 blue:0.15 alpha:1]];
//    [NavigationBarManager setStatusBarStyle:UIStatusBarStyleDefault];
//    [NavigationBarManager setFullAlphaTintColor:[UIColor whiteColor]];
//    [NavigationBarManager setFullAlphaBarStyle:UIStatusBarStyleLightContent];
//    [NavigationBarManager setContinues:NO];
//
//    //if you want the opposite visual, set reversal = YES
//    [NavigationBarManager setReversal:YES];
//
//}

- (UIButton *)backBtn {
    if (!_backBtn) {
        _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _backBtn.frame = CGRectMake(0, 0, 50,40);
        _backBtn.center = self.view.center;
        [_backBtn setTitle:@"返回" forState:0];
        [_backBtn addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backBtn;
}
- (void)back:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self scrollViewDidScroll:self.scrollView];
    
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [NavigationBarManager reStoreToSystemNavigationBar];
    
}

- (UIScrollView *)scrollView {
    
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        _scrollView.backgroundColor = [UIColor lightGrayColor];
        _scrollView.delegate = self;
        _scrollView.contentSize = CGSizeMake(self.view.frame.size.width, 2000);
        
    }
    return _scrollView;
}

- (TTPSuspendView *)searchBarView {
    if (!_searchBarView) {
        _searchBarView = [[[NSBundle mainBundle] loadNibNamed:TTPSuspendViewXibName owner:nil options:nil] firstObject];
        _searchBarView.frame = CGRectMake(10, -20, self.view.frame.size.width-20, 64);
        _searchBarView.hidden = YES;
    }
    return _searchBarView;
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [NavigationBarManager changeAlphaWithCurrentOffset:scrollView.contentOffset.y TitleView:self.searchBarView];
    
    NSLog(@"======%f",scrollView.contentOffset.y);
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
