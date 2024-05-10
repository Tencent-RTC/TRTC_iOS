//
//  VideoCallingEnterViewController.m
//  TRTC-API-Example-OC
//
//  Created by bluedang on 2021/4/12.
//  Copyright © 2021 Tencent. All rights reserved.
//
// TRTC video call entrance interface
// Contains the following functions:
// 1. Enter the room and generate the audio call interface

#import "VideoCallingEnterViewController.h"
#import "VideoCallingViewController.h"

@interface VideoCallingEnterViewController ()
@property (weak, nonatomic) IBOutlet UITextField *userIdTextField;
@property (weak, nonatomic) IBOutlet UITextField *roomIdTextField;
@property (weak, nonatomic) IBOutlet UILabel *inputRoomLabel;
@property (weak, nonatomic) IBOutlet UILabel *inputUserLabel;
@property (weak, nonatomic) IBOutlet UIButton *startButton;
@end

@implementation VideoCallingEnterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupDefaultUIConfig];
    [self setupRandomId];
}

- (void)setupDefaultUIConfig {
    self.title = localize(@"TRTC-API-Example.VideoCallingEnter.Title");
    _inputRoomLabel.text = localize(@"TRTC-API-Example.VideoCallingEnter.EnterRoomNumber");
    _inputUserLabel.text = localize(@"TRTC-API-Example.VideoCallingEnter.EnterUserName");
    [_startButton setTitle:localize(@"TRTC-API-Example.VideoCallingEnter.EnterRoom") forState:UIControlStateNormal];
}

- (void)setupRandomId {
    _roomIdTextField.text = @"1356732";
    _userIdTextField.text = [NSString generateRandomUserId];
}

- (IBAction)onStartClick:(id)sender {
    VideoCallingViewController *videoCallingVC = [[VideoCallingViewController alloc]
                                                  initWithRoomId:[_roomIdTextField.text intValue]
                                                  userId:_userIdTextField.text];
    [self.navigationController pushViewController:videoCallingVC animated:YES];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    [self.view endEditing:true];
}

@end
