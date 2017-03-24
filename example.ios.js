//index.ios.js
import React, { Component } from 'react';

import Ipaynow from 'react-native-ipaynow';

function show(title, msg) {
    Alert.alert(title+'', msg+'');
}

let md5 = 'mhtSignType=MD5&mhtSignature=d866ed04e7568254b94a75c8c586fcfa';

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

class TextReactNative extends Component {

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
      Ipaynow.pay(md5)
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

AppRegistry.registerComponent('test', () => TextReactNative);