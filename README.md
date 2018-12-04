# react-native-ipaynow

### 功能：

通过使用现在支付SDK实现微信支付(简洁版)、支付宝支付功能。

### 使用步骤：

#### 一、链接Ipaynow库

参考：https://reactnative.cn/docs/0.50/linking-libraries-ios.html#content

##### 手动添加：

1、添加`react-native-ipaynow`插件到你工程的`node_modules`文件夹下

2、添加`Ipaynow`库中的`.xcodeproj`文件在你的工程中

3、点击你的主工程文件，选择`Build Phases`，然后把刚才所添加进去的`.xcodeproj`下的`Products`文件夹中的静态库文件（.a文件），拖到`Link Binary With Libraries`组内。

##### 自动添加：

```
npm install react-native-ipaynow --save 
或
yarn add react-native-ipaynow

react-native link
```

由于`AppDelegate`中使用`Ipaynow`库，所以我们需要打开你的工程文件，选择`Build Settings`，然后搜索`Header Search Paths`，然后添加库所在的目录`$(SRCROOT)/../node_modules/react-native-ipaynow/ios/Ipaynow/IpaynowPlugin`

#### 二、开发环境配置

参考：https://payment2.ipaynow.cn/centerForDeveloper/mobileDocument?terminalId=02

##### 1、引入系统库

左侧目录中选中工程名，在`TARGETS->Build Phases-> Link Binary With Libaries`中点击`“+”`按钮，在弹出的窗口中查找并选择所需的库（见下图），单击`“Add”`按钮，将库文件添加到工程中。

- libz.tbd
- libsqlite3.0.tbd
- CoreGraphics.framework
- CoreTelephony.framework
- QuartzCore.framework
- SystemConfiguration.framework
- Security.framework
- Foundation.framework
- UIKit.framework

![](http://upload-images.jianshu.io/upload_images/2093433-31615a57a2663203.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

##### 2、环境配置
在`Xcode`中，选择你的工程设置项，选中`“TARGETS”`一栏，在`“info”`标签栏的`“URL type”`添加`“URL scheme”`为自定义`URL Scheme`

![](http://upload-images.jianshu.io/upload_images/2093433-08847026986ac434.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

在工程的`Build Settings`中找到`Other Linker Flags `中添加`-ObjC`宏。
![](http://upload-images.jianshu.io/upload_images/2093433-646edf9003030b3b.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

`bitcode`设置为`NO`

![](http://upload-images.jianshu.io/upload_images/2093433-aa43031b42658041.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

#### 三、简单使用

##### 方法

Event Name | Returns | Notes 
------ | ---- | -------
getPresignStr | string | 根据订单信息获取未签名字符串
pay | string | 根据待签名串与服务器生成的签名串进行支付

##### 1、重写AppDelegate的openURL方法：
```
#import "IpaynowPluginApi.h"

- (void)applicationWillEnterForeground:(UIApplication *)application{
[IpaynowPluginApi willEnterForeground];
}

//iOS9之后使用
-(BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options{

NSString *sourceApplication = options[@"UIApplicationOpenURLOptionSourceApplicationKey"];

return [IpaynowPluginApi application:app openURL:url sourceApplication:sourceApplication annotation: [[NSNull alloc]init]];
}

//iOS9之前使用
-(BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
return  [IpaynowPluginApi application:application openURL:url sourceApplication:sourceApplication annotation:annotation];
}

```
##### 2、js文件
```
/**
* Sample React Native App
* https://github.com/facebook/react-native
* @flow
*/

import React, { Component } from 'react';

import Ipaynow from 'react-native-ipaynow';

function show(title, msg) {
Alert.alert(title+'', msg+'');
}

let md5 = 'mhtSignType=MD5&mhtSignature=d866ed04e7568254b94a75c8c586fcfa';
let scheme = 'ipaynow';

import {
AppRegistry,
StyleSheet,
Text,
View,
Dimensions,
Alert,
ScrollView,
TouchableHighlight,
NativeAppEventEmitter
} from 'react-native';

export default class TextReactNative extends Component {

componentDidMount() {

}

getPresignStr() {
Ipaynow.getPresignStr({
'appId': '1408709961320306',
'consumerId': 'IPN00001',
'consumerName': 'IPaynow',
'mhtOrderName': 'IOS插件测试用例',
'mhtOrderAmt':'10',
'mhtOrderDetail': '关于订单验证接口的测试',
'notifyUrl': 'http://localhost:10802/',
'payChannelType':'12',
},(res) => {
show('getPresignStr', res);
});

}


pay() {
Ipaynow.pay(md5,scheme)
.then(result => {
console.log("result is ", result);
show("result is ", result);
})
.catch(error => {
console.log(error);
show(error);
});
}


render() {
return (
<ScrollView contentContainerStyle={styles.wrapper}>

<Text style={styles.pageTitle}>Ipaynow SDK for React Native (iOS)</Text>

<TouchableHighlight 
style={styles.button} underlayColor="#f38"
onPress={this.getPresignStr}>
<Text style={styles.buttonTitle}>getPresignStr</Text>
</TouchableHighlight>

<TouchableHighlight 
style={styles.button} underlayColor="#f38"
onPress={this.pay}>
<Text style={styles.buttonTitle}>pay</Text>
</TouchableHighlight>

</ScrollView>
);
}
}

const styles = StyleSheet.create({
wrapper: {
paddingTop: 60,
paddingBottom: 20,
alignItems: 'center',
},
pageTitle: {
paddingBottom: 40
},
button: {
width: 200,
height: 40,
marginBottom: 10,
borderRadius: 6,
backgroundColor: '#f38',
alignItems: 'center',
justifyContent: 'center',
},
buttonTitle: {
fontSize: 16,
color: '#fff'
}

});

```

现在支付文档链接：
https://payment2.ipaynow.cn/centerForDeveloper/mobileDocument?terminalId=02
