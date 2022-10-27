//
//  LiveAnchorViewController.h
//  TRTC-API-Example-OC
//
//  Created by adams on 2021/4/14.
//  Copyright (c) adams Tencent. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LiveAnchorViewController : UIViewController

- (instancetype)initWithRoomId:(UInt32)roomId userId:(NSString *)userId;

@end

NS_ASSUME_NONNULL_END
