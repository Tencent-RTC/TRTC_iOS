//
//  UIViewController+KeyBoard.m
//  TRTC-API-Example-OC
//
//  Created by 唐佳宁 on 2022/7/28.
//  Copyright © 2022 Tencent. All rights reserved.
//

#import "UIViewController+KeyBoard.h"

@implementation UIViewController (KeyBoard)

- (void)addKeyboardObserver {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)removeKeyboardObserver {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (BOOL)keyboardWillShow:(NSNotification *)noti {
    CGFloat animationDuration = [[[noti userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    CGRect keyboardBounds = [[[noti userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGAffineTransform transform = CGAffineTransformIdentity;
    [UIView animateWithDuration:animationDuration animations:^{
        self.view.transform = CGAffineTransformTranslate(transform, 0, keyboardBounds.origin.y - self.view.frame.size.height);
    }];
    return YES;
}

- (BOOL)keyboardWillHide:(NSNotification *)noti {
     CGFloat animationDuration = [[[noti userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
     [UIView animateWithDuration:animationDuration animations:^{
         self.view.transform =  CGAffineTransformIdentity;
     }];
     return YES;
}
@end
