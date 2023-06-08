## Third-Party Beauty SDK

_[简体中文](README-zh_CN.md) | English_

1. Download the dependent third-party beauty SDK: https://www.faceunity.com/sdk/FaceUnity-SDK-iOS-v7.4.0.zip

2. Import SDK
    - After downloading and decompressing, drag the folder into the project and check "Copy items if needed."
    - libCNamaSDK.framework is a dynamic library, which needs to be added to the dependency relationship in General->Framworks, Libraries, and Embedded Content, and set Embed to Embed&Sign, otherwise it will lead to a crash due to the library not being found.

3. Download FUTRTCDemo: https://github.com/Faceunity/FUTRTCDemo

4. Drag the following files from the FaceUnity directory in the FUTRTCDemo project into your project and check "Copy items if needed":
	- authpack.h
	- FUBeautyParam.h
	- FUBeautyParam.m
	- FUDateHandle.h
	- FUDateHandle.m
	- FUManager.h
	- FUManager.m
5. Add certificate: For the certificate key in authpack.h, please contact Faceunity to obtain a test certificate and replace it here (after replacing, please comment out or delete this error warning).

6. Cancel the following comments in the ThirdBeautyFaceunityViewController.m file:
	```
	//#import "FUManager.h"
	```

	```
	//@property (strong, nonatomic) FUBeautyParam *beautyParam;
	```

	```
	//- (FUBeautyParam *)beautyParam {
	//    if (!_beautyParam) {
	//        _beautyParam = [[FUBeautyParam alloc] init];
	//        _beautyParam.type = FUDataTypeBeautify;
	//        _beautyParam.mParam = @"blur_level";
	//    }
	//    return _beautyParam;
	//}
	```

	```
	//    [[FUManager shareManager] loadFilter];
	//    [FUManager shareManager].isRender = YES;
	//    [FUManager shareManager].flipx = YES;
	//    [FUManager shareManager].trackFlipx = YES;
	```

	```
	//    self.beautyParam.mValue = sender.value;
	//    [[FUManager shareManager] filterValueChange:self.beautyParam];
	```

	```
	//    [[FUManager shareManager] renderItemsToPixelBuffer:frame.pixelBuffer];
	```

	```
	//    [[FUManager shareManager] destoryItems];
	```
7. Command + R to run