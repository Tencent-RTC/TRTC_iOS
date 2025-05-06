/*
 * Module: GenerateTestUserSig
 *
 * Function: used to generate UserSig for testing. UserSig is a security protection signature designed by Tencent Cloud for its cloud services.
 * The calculation method is to encrypt SDKAppID, UserID and EXPIRETIME, and the encryption algorithm is HMAC-SHA256.
 *
 * Attention: Please do not publish the following code into your online official version of the App for the following reasons:
 *
 * Although the code in this file can correctly calculate UserSig,
 * it is only suitable for quickly adjusting the basic functions of the SDK and is not suitable for online products.
 * This is because the SDKSECRETKEY in the client code is easily decompiled and reverse-engineered, especially the web-side code,
 * which is almost zero difficulty in cracking.
 * Once your key is leaked, an attacker can calculate the correct UserSig to steal your Tencent Cloud traffic.
 *
 * The correct approach is to put the UserSig calculation code and encryption key on your business server,
 * and then have the App obtain the real-time calculated UserSig from your server on demand.
 * Since it is more expensive to crack a server than a client app, a server-computed approach better protects your encryption keys.
 *
 * Reference: https://cloud.tencent.com/document/product/269/32688#Server
 */

import Foundation
import CommonCrypto
import zlib

/**
 * Tencent Cloud Live License Management Page (https://console.cloud.tencent.com/live/license)
 * Currently applied License LicenseUrl
 *
 * License Management View (https://console.cloud.tencent.com/live/license)
 * License URL of your application
 */
let LICENSEURL = ""

/**
 * Tencent Cloud Live License Management Page (https://console.cloud.tencent.com/live/license)
 * Currently applied License Key
 *
 * License Management View (https://console.cloud.tencent.com/live/license)
 * License key of your application
 */
let LICENSEURLKEY = ""

/**
 * Tencent Cloud SDKAppId needs to be replaced with the SDKAppId under your own account.
 *
 * Enter Tencent Cloud Communication [Console] (https://console.cloud.tencent.com/avc) to create an application and you will see the SDKAppId.
 * It is the unique identifier used by Tencent Cloud to distinguish customers.
 */
let SDKAPPID: Int = 0

/**
 * It is recommended not to set the signature expiration time too short.
 *
 * Time unit: seconds
 *Default time: 7 x 24 x 60 x 60 = 604800 = 7 days
 */
let EXPIRETIME: Int = 0

/**
 * CDN publishing function mixed streaming appId
 */
let CDNAPPID = 0

/**
 * CDN publishing function mixed bizId
 */
let CDNBIZID = 0

/**
 * CDN publishing function mixed flow CDN_URL
 */
let kCDN_URL: String = ""

/**
 * The encryption key used to calculate the signature, the steps to obtain are as follows:
 *
 * step1. Enter Tencent Cloud Communication [Console](https://console.cloud.tencent.com/avc), if there is no application yet, create one.
 * step2. Click "Application Configuration" to enter the basic configuration page, and further find the "Account System Integration" section.
 * step3. Click the "View Key" button to see the encrypted key used to calculate UserSig. Please copy it to the following variable
 *
 * Note: This solution is only suitable for debugging Demo.
 * Please migrate the UserSig calculation code and key to your backend server before official launch to
 * avoid traffic theft caused by encryption key leakage.
 * Document: https://cloud.tencent.com/document/product/269/32688#Server
 */
let SDKSECRETKEY = ""

/**
 * Calculate UserSig signature
 *
 * The HMAC-SHA256 asymmetric encryption algorithm is used internally to encrypt SDKAPPID, userId and EXPIRETIME.
 *
 * @note: Please do not publish the following code into your online official version of the App for the following reasons:
 * Although the code in this file can correctly calculate UserSig,
 * it is only suitable for quickly adjusting the basic functions of the SDK and is not suitable for online products.
 * This is because the SDKSECRETKEY in the client code is easily decompiled and reverse-engineered, especially the web-side code,
 * which is almost zero difficulty in cracking.
 * Once your key is compromised, an attacker can calculate the correct UserSig to steal your Tencent Cloud traffic.
 *
 * The correct approach is to put the UserSig calculation code and encryption key on your business server,
 * and then have the App obtain the real-time calculated UserSig from your server on demand.
 * Since it is more expensive to crack a server than a client app, a server-computed approach better protects your encryption keys.
 *
 * Document: https://cloud.tencent.com/document/product/269/32688#Server
 */

let PUSHURL = ""

/**
 * Configured streaming address
 *
 * Tencent Cloud domain name management page: https://console.cloud.tencent.com/live/domainmanage
 */
let PLAY_DOMAIN: String = ""

/**
 * Configured background service domain name, similar to: https://service-3vscss6c-xxxxxxxxxxx.gz.apigw.tencentcs.com"
 * The small live broadcast backend provides services such as login and room list.
 * For more details, please see the document: https://cloud.tencent.com/document/product/454/38625
 */
let SERVERLESSURL = ""


let SDKAppID = 0

class GenerateTestUserSig {
    
    class func genTestUserSig(identifier: String) -> String {
        let current = CFAbsoluteTimeGetCurrent() + kCFAbsoluteTimeIntervalSince1970
        let TLSTime: CLong = CLong(floor(current))
        var obj: [String: Any] = [
            "TLS.ver": "2.0",
            "TLS.identifier": identifier,
            "TLS.sdkappid":SDKAppID,
            "TLS.expire": EXPIRETIME,
            "TLS.time": TLSTime
        ]
        let keyOrder = [
            "TLS.identifier",
            "TLS.sdkappid",
            "TLS.time",
            "TLS.expire"
        ]
        var stringToSign = ""
        keyOrder.forEach { (key) in
            if let value = obj[key] {
                stringToSign += "\(key):\(value)\n"
            }
        }
        print("string to sign: \(stringToSign)")
        if let sig = hmac(stringToSign) {
            obj["TLS.sig"] = sig
            print("sig: \(String(describing: sig))")
        }
        guard let jsonData = try? JSONSerialization.data(withJSONObject: obj, options: .sortedKeys) else { return "" }
        
        let bytes = jsonData.withUnsafeBytes { (result) -> UnsafePointer<Bytef> in
            if let baseAddress = result.bindMemory(to: Bytef.self).baseAddress {
                return baseAddress
            }
            return UnsafePointer<Bytef>.init("")
        }
        let srcLen: uLongf = uLongf(jsonData.count)
        let upperBound: uLong = compressBound(srcLen)
        let capacity: Int = Int(upperBound)
        let dest: UnsafeMutablePointer<Bytef> = UnsafeMutablePointer<Bytef>.allocate(capacity: capacity)
        var destLen = upperBound
        let ret = compress2(dest, &destLen, bytes, srcLen, Z_BEST_SPEED)
        if ret != Z_OK {
            print("[Error] Compress Error \(ret), upper bound: \(upperBound)")
            dest.deallocate()
            return ""
        }
        let count = Int(destLen)
        let result = self.base64URL(data: Data.init(bytesNoCopy: dest, count: count, deallocator: .free))
        return result
    }
    
    class func hmac(_ plainText: String) -> String? {
        let cData = plainText.cString(using: String.Encoding.ascii)
        
        let cKeyLen = SDKSECRETKEY.lengthOfBytes(using: .ascii)
        let cDataLen = plainText.lengthOfBytes(using: .ascii)
        
        var cHMAC = [CUnsignedChar].init(repeating: 0, count: Int(CC_SHA256_DIGEST_LENGTH))
        let pointer = cHMAC.withUnsafeMutableBufferPointer { (unsafeBufferPointer) in
            return unsafeBufferPointer
        }
        guard let cKey = SDKSECRETKEY.cString(using: String.Encoding.ascii) else { return "" }
        CCHmac(CCHmacAlgorithm(kCCHmacAlgSHA256), cKey, cKeyLen, cData, cDataLen, pointer.baseAddress)
        guard let baseAddress = pointer.baseAddress else { return "" }
        let data = Data.init(bytes: baseAddress, count: cHMAC.count)
        return data.base64EncodedString(options: [])
    }
    
    class func base64URL(data: Data) -> String {
        let result = data.base64EncodedString(options: Data.Base64EncodingOptions.init(rawValue: 0))
        var final = ""
        result.forEach { (char) in
            switch char {
            case "+":
                final += "*"
            case "/":
                final += "-"
            case "=":
                final += "_"
            default:
                final += "\(char)"
            }
        }
        return final
    }
    
    class func generatePushPullStreamAddress(handler: @escaping ((String, String)?) -> Void) {
        guard let url = URL.init(string: PUSHURL) else {
            debugPrint("Invalid url address")
            return
        }
        var urlRequest = URLRequest.init(url: url)
        urlRequest.httpMethod = "GET"
        urlRequest.setValue("application/json; charset=UTF-8", forHTTPHeaderField: "Content-Type")
        urlRequest.timeoutInterval = 30
        let task = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            if let error = error {
                debugPrint("internalSendRequest failed，NSURLSessionDataTask return error des:\(error.localizedDescription)")
                DispatchQueue.main.async {
                    handler(nil)
                }
                return
            }
            guard let data = data else {
                debugPrint("response data is nil")
                DispatchQueue.main.async {
                    handler(nil)
                }
                return
            }
            guard let jsonStr = String.init(data: data, encoding: .utf8) else {
                debugPrint("data convert utf8 string error")
                DispatchQueue.main.async {
                    handler(nil)
                }
                return
            }
            guard let jsonData = jsonStr.data(using: .utf8) else {
                debugPrint("string convert utf8 data error")
                DispatchQueue.main.async {
                    handler(nil)
                }
                return
            }
            if let jsonDic = try? JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers) as? [String : String] {
                guard let pushURL = jsonDic["url_push"], let playURL = jsonDic["url_play_flv"] else {
                    debugPrint("url is nil")
                    DispatchQueue.main.async {
                        handler(nil)
                    }
                    return
                }
                DispatchQueue.main.async {
                    debugPrint("_____push URL = \(pushURL), play URL = \(playURL)")
                    handler((pushURL,playURL))
                }
            } else {
                DispatchQueue.main.async {
                    handler(nil)
                }
            }
        }
        task.resume()
    }
}
