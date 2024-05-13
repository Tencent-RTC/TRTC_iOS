//
//  SetBGMViewController.m
//  TRTC-API-Example-OC
//
//  Created by adams on 2021/4/20.
//  Copyright © 2021 Tencent. All rights reserved.
//
/*
 * Module:   GenerateTestUserSig
 *
 * Function: Used to generate UserSig for testing. UserSig is a security protection signature designed by Tencent Cloud for its cloud services.
 * The calculation method is to encrypt SDKAppID, UserID and EXPIRETIME, and the encryption algorithm is HMAC-SHA256.
 *
 * Attention: Please do not publish the following code into your online official version of the App for the following reasons:
 *
 *            Although the code in this file can correctly calculate UserSig, it is only suitable for quickly adjusting the basic functions of the SDK and is not suitable for online products.
 *            This is because the SDKSECRETKEY in the client code is easily decompiled and reverse-engineered, especially the web-side code, which is almost zero difficulty in cracking.
 *            Once your key is compromised, an attacker can calculate the correct UserSig to steal your Tencent Cloud traffic.
 *
 *            The correct approach is to put the UserSig calculation code and encryption key on your business server, and then have the App obtain the real-time calculated UserSig from your server on demand.
 *            Since it's more expensive to hack a server than a client app, a server-computed approach better protects your encryption keys.
 *
 * Reference：https://cloud.tencent.com/document/product/647/17275#Server
 */

/*
 * Module:   GenerateTestUserSig
 *
 * Description: generates UserSig for testing. UserSig is a security signature designed by Tencent Cloud for its cloud services.
 *           It is calculated based on `SDKAppID`, `UserID`, and `EXPIRETIME` using the HMAC-SHA256 encryption algorithm.
 *
 * Attention: do not use the code below in your commercial app. This is because:
 *
 *            The code may be able to calculate UserSig correctly, but it is only for quick testing of the SDK’s basic features, not for commercial apps.
 *            `SDKSECRETKEY` in client code can be easily decompiled and reversed, especially on web.
 *             Once your key is disclosed, attackers will be able to steal your Tencent Cloud traffic.
 *
 *            The correct method is to deploy the `UserSig` calculation code and encryption key on your project server so that your app can request from your server a `UserSig` that is calculated whenever one is needed.
 *           Given that it is more difficult to hack a server than a client app, server-end calculation can better protect your key.
 *
 * Reference: https://cloud.tencent.com/document/product/647/17275#Server
 */

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


/**
 * CDN publishing function mixed flow CDN_URL
 */
/**
 * Domain name for CDN publishing and stream mixing
 */
static NSString * const kCDN_URL = @"";

/**
 * CDN publishing function mixed streaming appId
 */
/**
 * `appId` for CDN publishing and stream mixing
 */
static const int CDNAPPID = 0;

/**
 * CDN publishing function mixed bizId
 */
/**
 * `bizId` for CDN publishing and stream mixing
 */
static const int CDNBIZID = 0;

/**
 * Tencent Cloud SDKAppId needs to be replaced with the SDKAppId under your own account.
 *
 * Enter Tencent Cloud Real-time Audio and Video [Console] (https://console.cloud.tencent.com/rav) to create an application and you will see the SDKAppId.
 * It is the unique identifier used by Tencent Cloud to distinguish customers.
 */
/**
 * Tencent Cloud `SDKAppID`. Set it to the `SDKAppID` of your account.
 *
 * You can view your `SDKAppID` after creating an application in the [TRTC console](https://console.cloud.tencent.com/rav).
 * `SDKAppID` uniquely identifies a Tencent Cloud account.
 */
static const int SDKAppID = 0;

/**
 *  It is recommended not to set the signature expiration time too short.
 *
 *  Time unit: seconds
 *  Default time: 7 x 24 x 60 x 60 = 604800 = 7 days
 */
/**
 * Signature validity period, which should not be set too short
 * <p>
 * Unit: second
 * Default value: 604800 (7 days)
 */
static const int EXPIRETIME = 604800;

/**
 * The encryption key used to calculate the signature, the steps to obtain are as follows:
 *
 * step1. Enter Tencent Cloud Real-time Audio and Video [Console] (https://console.cloud.tencent.com/rav), if there is no application yet, create one.
 * step2. Click on your app and further find the "Get Started" section.
 * step3. Click the "View Key" button to see the encrypted key used to calculate UserSig. Please copy it to the following variable
 *
 * Note: This solution is only suitable for debugging Demo. Please migrate the UserSig calculation code and key to your backend server before official launch to avoid traffic theft caused by encryption key leakage.
 * Document: https://cloud.tencent.com/document/product/647/17275#Server
 */
/**
 * Follow the steps below to obtain the key required for UserSig calculation.
 *
 * Step 1. Log in to the [TRTC console](https://console.cloud.tencent.com/rav), and create an application if you don’t have one.
 * Step 2. Find your application, click “Application Info”, and click the “Quick Start” tab.
 * Step 3. Copy and paste the key to the code, as shown below.
 *
 * Note: this method is for testing only. Before commercial launch, please migrate the UserSig calculation code and key to your backend server to prevent key disclosure and traffic stealing.
 * Reference: https://cloud.tencent.com/document/product/647/17275#Server
 */
static NSString * const SDKSECRETKEY = @"";


@interface GenerateTestUserSig : NSObject
/**
 * Compute UserSig signature
 *
 * The HMAC-SHA256 asymmetric encryption algorithm is used inside the function to encrypt SDKAPPID, userId and EXPIRETIME.
 *
 * @note: Please do not publish the following code into your online official version of the App for the following reasons:
 *
 * Although the code in this file can correctly calculate UserSig, it is only suitable for quickly adjusting the basic functions of the SDK and is not suitable for online products.
 * This is because the SDKSECRETKEY in the client code is easily decompiled and reverse-engineered, especially the web-side code, which is almost zero difficulty in cracking.
 * Once your key is compromised, an attacker can calculate the correct UserSig to steal your Tencent Cloud traffic.
 *
 * The correct approach is to put the UserSig calculation code and encryption key on your business server, and then have the App obtain the real-time calculated UserSig from your server on demand.
 * Since it's more expensive to hack a server than a client app, a server-computed approach better protects your encryption keys.
 *
 * Document: https://cloud.tencent.com/document/product/647/17275#Server
 */
/**
 * Calculating UserSig
 *
 * The asymmetric encryption algorithm HMAC-SHA256 is used in the function to calculate UserSig based on `SDKAppID`, `UserID`, and `EXPIRETIME`.
 *
 * @note: do not use the code below in your commercial app. This is because:
 *
 * The code may be able to calculate UserSig correctly, but it is only for quick testing of the SDK’s basic features, not for commercial apps.
 * `SDKSECRETKEY` in client code can be easily decompiled and reversed, especially on web.
 * Once your key is disclosed, attackers will be able to steal your Tencent Cloud traffic.
 *
 * The correct method is to deploy the `UserSig` calculation code on your project server so that your app can request from your server a `UserSig` that is calculated whenever one is needed.
 * Given that it is more difficult to hack a server than a client app, server-end calculation can better protect your key.
 *
 * Reference: https://cloud.tencent.com/document/product/647/17275#Server
 */
+ (NSString *)genTestUserSig:(NSString *)identifier;
@end

NS_ASSUME_NONNULL_END
