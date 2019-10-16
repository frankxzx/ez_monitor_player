#import "EzMonitorPlayerPlugin.h"
#import "EzMonitorPlayer.h"
#import <EZUIKit/EZUIKit.h>

@implementation EzMonitorPlayerPlugin

+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
//  FlutterMethodChannel* channel = [FlutterMethodChannel
//      methodChannelWithName:@"plugins.xzx/ez_monitor_player"
//            binaryMessenger:[registrar messenger]];
//  EzMonitorPlayerPlugin* instance = [[EzMonitorPlayerPlugin alloc] init];
//  [registrar addMethodCallDelegate:instance channel:channel];
    
    [EZUIKit initWithAppKey:@"6e9f8a8c05cb4e57843a85afdf49ff57"];
    [EZUIKit setAccessToken:@"at.9bkf61je8xypdnj03ho1aj1sdfub8612-2dmoh97t8w-04mdr2y-lbphujgu4"];

  EzMonitorPlayerFactory* playerFactory =
  [[EzMonitorPlayerFactory alloc] initWithMessenger:registrar.messenger];
  [registrar registerViewFactory:playerFactory withId:@"plugins.xzx/ez_monitor_player"];
}

//- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
//  if ([@"setKey" isEqualToString:call.method]) {
//    NSString *key = call.arguments;
//    [AMapServices sharedServices].enableHTTPS = YES;
//    // 配置高德地图的key
//    [AMapServices sharedServices].apiKey = key;
//    result(@YES);
//  } else {
//    result(FlutterMethodNotImplemented);
//  }
//}


@end
