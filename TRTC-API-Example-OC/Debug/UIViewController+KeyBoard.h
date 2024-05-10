//
//  UIViewController+KeyBoard.h
//  TRTC-API-Example-OC
//
//  Created by janejntang on 2022/7/28.
//  Copyright © 2022 Tencent. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (KeyBoard)
- (void)addKeyboardObserver;
- (void)removeKeyboardObserver;
@end

NS_ASSUME_NONNULL_END
