# TRTC API-Example Swift
[中文](README.md) | English

## Background
This open-source demo shows how to use some APIs of the [TRTC SDK](https://www.tencentcloud.com/document/product/647/34615) to help you better understand the APIs and use them to implement some basic TRTC features. 

## Contents
This demo covers the following features (click to view the details of a feature):

- Basic Features
  - [Audio Call](./Basic/AudioCall)
  - [Video Call](./Basic/VideoCall)
  - [Interactive Live Video Streaming](./Basic/Live)
  - [Interactive Live Audio Streaming](./Basic/VoiceChatRoom)
  - [Screen Sharing Live Streaming](./Basic/ScreenShare)
- Advanced Features
  - [String-type Room IDs](./Advanced/StringRoomId)
  - [Video Quality Setting](./Advanced/SetVideoQuality)
  - [Audio Quality Setting](./Advanced/SetAudioQuality)
  - [Rendering Control](./Advanced/SetRenderParams)
  - [Network Speed Testing](./Advanced/SpeedTest)
  - [CDN Publishing](./Advanced/PushCDN)
  - [Custom Video Capturing & Rendering](./Advanced/CustomCamera)
  - [Audio Effect Setting](./Advanced/SetAudioEffect)
  - [Background Music Setting](./Advanced/SetBackgroundMusic)
  - [Local Video Recording](./Advanced/LocalRecord)
  - [Multiple Room Entry](./Advanced/JoinMultipleRoom)
  - [SEI Message Receiving/Sending](./Advanced/SEIMessage)
  - [Room Switching](./Advanced/SwitchRoom)
  - [Cross-Room Competition](./Advanced/RoomPk)
  - [Picture-In-Picture](./Advanced/PictureInPicture)

## Environment Requirements
- Xcode 11.0 and above
- Please make sure that your project has set a valid developer signature


## Demo Run Example

#### Prerequisites
You have [signed up for a Tencent Cloud account](https://intl.cloud.tencent.com/document/product/378/17985) and completed [identity verification](https://intl.cloud.tencent.com/document/product/378/3629).


### Obtaining `SDKAPPID` and `SECRETKEY`
1. Log in to the TRTC console and select **Application Management** > **[Create application](https://console.tencentcloud.com/trtc/app/create)**.
2. Enter an application name such as `TestTRTC`, and click **Next**.

![ #900px](https://qcloudimg.tencent-cloud.cn/raw/51c73a617e69a76ed26e6f74b0071ec9.png)
3. Click **Next** to view your `SDKAppID` and key.


### Configuring demo project files
1. Open the [GenerateTestUserSig.swift](Debug/GenerateTestUserSig.swift) file in the Debug directory.
2. Configure two parameters in the `GenerateTestUserSig.swift` file:
  - `SDKAPPID`: `PLACEHOLDER` by default. Set it to the actual `SDKAppID`.
  - `SECRETKEY`: left empty by default. Set it to the actual key.
 ![ #900px](https://qcloudimg.tencent-cloud.cn/raw/79a57d5e09bb050d8798492732cfd33b/TRTC-sdkAppId-iOS.png)

3. Return to the TRTC console and click **Next**.
4. Click **Return to Overview Page**.

>!The method for generating `UserSig` described in this document involves configuring `SECRETKEY` in client code. In this method, `SECRETKEY` may be easily decompiled and reversed, and if your key is disclosed, attackers can steal your Tencent Cloud traffic. Therefore, **this method is suitable only for the local execution and debugging of the demo**.
>The correct `UserSig` distribution method is to integrate the calculation code of `UserSig` into your server and provide an application-oriented API. When `UserSig` is needed, your application can make a request to the business server for dynamic `UserSig`. For more information, please see [How to Calculate UserSig](https://www.tencentcloud.com/document/product/647/35166).

## Configuring CDN parameters (optional)
To use CDN services, which are needed for co-anchoring, CDN playback, etc., you need to configure three **live streaming** parameters.

For detailed instructions, see [CDN Relayed Live Streaming](https://www.tencentcloud.com/document/product/647/47858).


### Compiling and running the project
Use XCode (11.0 and above) to open TRTC-API-Example-OC.xcodeproj in the source directory


## Contact Us
- If you have questions, see [FAQs](https://www.tencentcloud.com/document/product/647/36057).

- To learn about how the TRTC SDK can be used in different scenarios, see [Sample Code](https://www.tencentcloud.com/document/product/647/42963).

- For complete API documentation, see [SDK API Documentation](https://www.tencentcloud.com/document/product/647/35119).

- Communication & Feedback   
Welcome to join our Telegram Group to communicate with our professional engineers! We are more than happy to hear from you~
Click to join: [https://t.me/+EPk6TMZEZMM5OGY1](https://t.me/+EPk6TMZEZMM5OGY1)   
Or scan the QR code   
  <img src="https://qcloudimg.tencent-cloud.cn/raw/79cbfd13877704ff6e17f30de09002dd.jpg" width="300px">    
