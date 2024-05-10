//
//  VideoCallingViewController.h
//  TRTC-API-Example-OC
//
//  Created by bluedang on 2021/4/12.
//  Copyright © 2021 Tencent. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

//MARK: Video call example - call interface
@interface VideoCallingViewController : UIViewController
- (instancetype)initWithRoomId:(UInt32)roomId userId:(NSString *)userId;
@end

NS_ASSUME_NONNULL_END
