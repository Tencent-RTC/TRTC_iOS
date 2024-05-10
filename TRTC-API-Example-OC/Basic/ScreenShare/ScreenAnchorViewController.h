//
//  ScreenAnchorViewController.h
//  TRTC-API-Example-OC
//
//  Created by bluedang on 2021/4/15.
//  Copyright © 2021 Tencent. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

//MARK: Screen recording live broadcast example - anchor interface
@interface ScreenAnchorViewController : UIViewController
@property (assign, nonatomic) UInt32 roomId;
@property (strong, nonatomic) NSString* userId;
@end

NS_ASSUME_NONNULL_END
