//
//  AudioCallingViewController.h
//  TRTC-API-Example-OC
//
//  Created by bluedang on 2021/4/14.
//  Copyright © 2021 Tencent. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

//MARK: Voice call example - call interface
@interface AudioCallingViewController : UIViewController
- (instancetype)initWithRoomId:(UInt32)roomId userId:(NSString *)userId;
@end

NS_ASSUME_NONNULL_END
