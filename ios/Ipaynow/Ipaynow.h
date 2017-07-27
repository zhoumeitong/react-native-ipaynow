//
//  Ipaynow.h
//  Ipaynow
//
//  Created by zmt on 2017/3/24.
//  Copyright © 2017年 cn.com.jiuqi. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <UIKit/UIKit.h>
#if __has_include("RCTBridgeModule.h")
#import "RCTBridgeModule.h"
#else
#import <React/RCTBridgeModule.h>
#endif
#import "IpaynowPluginDelegate.h"

@interface Ipaynow : NSObject<RCTBridgeModule,IpaynowPluginDelegate>

@end
