//
//  TTPSuspendView.m
//  TtPaiPersonal
//
//  Created by Ayler on 2017/2/24.
//  Copyright © 2017年 ttpai. All rights reserved.
//

#import "TTPSuspendView.h"

NSString * const TTPSuspendViewXibName = @"TTPSuspendView";
NSInteger TTPSuspendViewSellcarButtonTag = 1003;

@implementation TTPSuspendView

- (void)drawRect:(CGRect)rect {

    self.cityButoon.imageEdgeInsets = UIEdgeInsetsMake(0, self.cityButoon.titleLabel.frame.size.width +10, 0, -10);
}

- (void)loomingAnimationWithDuration:(CGFloat)duration {
    
    self.alpha = 0.0;
    [UIView animateWithDuration:duration animations:^{
        self.alpha = 1.0;
    }];
}
@end
