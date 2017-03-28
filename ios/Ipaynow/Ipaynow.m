//
//  Ipaynow.m
//  Ipaynow
//
//  Created by zmt on 2017/3/24.
//  Copyright © 2017年 cn.com.jiuqi. All rights reserved.
//

#import "Ipaynow.h"

#import "IPNPreSignMessageUtil.h"
#import "IpaynowPluginApi.h"

static RCTPromiseResolveBlock _resolve;
static RCTPromiseRejectBlock _reject;

@implementation Ipaynow
{
    
    NSString *_presignStr;
}

RCT_EXPORT_MODULE();


RCT_EXPORT_METHOD(getPresignStr:(NSDictionary *)dict
                  :(RCTResponseSenderBlock)callback){
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyyMMddHHmmss"];
    
    // 订单拼接
    IPNPreSignMessageUtil *preSign = [[IPNPreSignMessageUtil alloc] init];
    preSign.appId = dict[@"appId"];
    preSign.consumerId = dict[@"consumerId"];
    preSign.consumerName = dict[@"consumerName"];
    preSign.mhtOrderNo = [formatter stringFromDate:[NSDate date]];
    preSign.mhtOrderName = dict[@"mhtOrderName"];
    preSign.mhtOrderType = @"01";//普通消费
    preSign.mhtCurrencyType = @"156";//人民币
    preSign.mhtOrderAmt = dict[@"mhtOrderAmt"];//单位分
    preSign.mhtOrderDetail = dict[@"mhtOrderDetail"];
    preSign.mhtOrderStartTime = [formatter stringFromDate:[NSDate date]];
    preSign.notifyUrl = dict[@"notifyUrl"];
    preSign.mhtCharset = @"UTF-8";
    preSign.mhtOrderTimeOut = @"3600";
    preSign.payChannelType = dict[@"payChannelType"];//选择支付方式  支付宝支付:12、微信支付:13;
    
    _presignStr = [preSign generatePresignMessage];
    
    callback(@[_presignStr]);
    
}


RCT_EXPORT_METHOD(pay:(NSString *)md5 Scheme:(NSString *)scheme resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject)
{
    
    NSString *payData = [_presignStr stringByAppendingFormat:@"&%@",md5];
    
    UIViewController *root = [[[[UIApplication sharedApplication] delegate] window] rootViewController];
    
    _resolve = resolve;
    _reject = reject;
    
    [IpaynowPluginApi pay:payData AndScheme:scheme viewController:root delegate:self];
    
}

#pragma mark - SDK的回调方法
- (void)iPaynowPluginResult:(IPNPayResult)result errorCode:(NSString *)errorCode errorInfo:(NSString *)errorInfo{
    NSString *resultString = @"";
    switch (result) {
        case IPNPayResultFail:
            resultString = [NSString stringWithFormat:@"支付失败:\r\n错误码:%@,异常信息:%@",errorCode, errorInfo];
            _resolve(resultString);
            break;
        case IPNPayResultCancel:
            resultString = @"支付被取消";
            _resolve(resultString);
            break;
        case IPNPayResultSuccess:
            resultString = @"支付成功";
            _resolve(resultString);
            break;
        case  IPNPayResultUnknown:
            resultString = [NSString stringWithFormat:@"支付结果未知:%@",errorInfo];
            _resolve(resultString);
        default:
            break;
    }
    
    
}

@end
