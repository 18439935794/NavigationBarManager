//
//  TTPSuspendView.h
//  TtPaiPersonal
//
//  Created by Ayler on 2017/2/24.
//  Copyright © 2017年 ttpai. All rights reserved.
//

#import <UIKit/UIKit.h>

UIKIT_EXTERN NSString * const TTPSuspendViewXibName;
UIKIT_EXTERN NSInteger TTPSuspendViewSellcarButtonTag;
@interface TTPSuspendView : UIView
@property (weak, nonatomic) IBOutlet UIButton *cityButoon;
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UIButton *sellcarButton;
- (void)loomingAnimationWithDuration:(CGFloat)duration;
@end
