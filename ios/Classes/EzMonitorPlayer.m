//
//  EzMonitorPlayer.m
//  ez_monitor_player
//
//  Created by Xuzixiang on 2019/10/16.
//

#import "EzMonitorPlayer.h"
#import "EZUIKit.h"
#import "EZUIPlayer.h"
#import "EZUIError.h"

@implementation EzMonitorPlayer {
    UIView* _view;
    int64_t _viewId;
    FlutterMethodChannel* _channel;
    NSString *_param;
    EZUIPlayer *_ezPlayer;
}

- (instancetype)initWithFrame:(CGRect)frame
               viewIdentifier:(int64_t)viewId
                    arguments:(id _Nullable)args
              binaryMessenger:(NSObject<FlutterBinaryMessenger>*)messenger {
    if ([super init]) {
        _view = [[UIView alloc]initWithFrame:frame];
        _viewId = viewId;
        NSString* channelName = [NSString stringWithFormat:@"plugins.weilu/flutter_2d_amap_%lld", viewId];
        _channel = [FlutterMethodChannel methodChannelWithName:channelName binaryMessenger:messenger];
        __weak __typeof__(self) weakSelf = self;
        [_channel setMethodCallHandler:^(FlutterMethodCall* call, FlutterResult result) {
            [weakSelf onMethodCall:call result:result];
        }];
        _param = args[@"foo"];
    }
    return self;
}

- (void)onMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    if ([[call method] isEqualToString:@"play"]) {
       NSString *ezOpenUrl = [call arguments][@"ezOpenUrl"];
        
    } else if ([[call method] isEqualToString:@"pause"]) {

    } else {

    }
}

-(void)resumePlay {
    if (!_ezPlayer) { return; }
    [_ezPlayer startPlay];
}

#pragma mark - player delegate

- (void) EZUIPlayerFinished:(EZUIPlayer*) player
{
    [player stopPlay];
}

- (void) EZUIPlayerPrepared:(EZUIPlayer*) player
{
    [player startPlay];
}

- (void) EZUIPlayerPlaySucceed:(EZUIPlayer *)player
{
}

- (void) EZUIPlayer:(EZUIPlayer *)player didPlayFailed:(EZUIError *) error
{
    [player stopPlay];
    NSString *message = @"";
    if ([error.errorString isEqualToString:UE_ERROR_INNER_VERIFYCODE_ERROR])
    {
        message = [NSString stringWithFormat:@"%@(%@[%ld])",LocalizedString(@"verify_code_wrong"),
                   error.errorString,
                   error.internalErrorCode];
    }
    else if ([error.errorString isEqualToString:UE_ERROR_TRANSF_DEVICE_OFFLINE])
    {
        message = [NSString stringWithFormat:@"%@(%@[%d])",
                   LocalizedString(@"device_offline"),
                   error.errorString,
                   error.internalErrorCode];
    }
    else if ([error.errorString isEqualToString:UE_ERROR_DEVICE_NOT_EXIST])
    {
        message = [NSString stringWithFormat:@"%@(%@[%d])",
                   LocalizedString(@"device_not_exist"),
                   error.errorString,
                   error.internalErrorCode];
    }
    else if ([error.errorString isEqualToString:UE_ERROR_CAMERA_NOT_EXIST])
    {
        message = [NSString stringWithFormat:@"%@(%@[%d])",
                   LocalizedString(@"camera_not_exist"),
                   error.errorString,
                   error.internalErrorCode];
    }
    else if ([error.errorString isEqualToString:UE_ERROR_INNER_STREAM_TIMEOUT])
    {
        message = [NSString stringWithFormat:@"%@(%@[%d])",
                   LocalizedString(@"connect_out_time"),
                   error.errorString,error.internalErrorCode];
    }
    else if ([error.errorString isEqualToString:UE_ERROR_CAS_MSG_PU_NO_RESOURCE])
    {
        message = [NSString stringWithFormat:@"%@(%@[%d])",
                   LocalizedString(@"connect_device_limit"),
                   error.errorString,
                   error.internalErrorCode];
    }
    else if ([error.errorString isEqualToString:UE_ERROR_NOT_FOUND_RECORD_FILES])
    {
        message = [NSString stringWithFormat:@"%@(%@[%d])",
                   LocalizedString(@"not_find_file"),
                   error.errorString,
                   error.internalErrorCode];
    }
    else if ([error.errorString isEqualToString:UE_ERROR_PARAM_ERROR])
    {
        message = [NSString stringWithFormat:@"%@(%@[%d])",
                   LocalizedString(@"param_error"),
                   error.errorString,
                   error.internalErrorCode];
    }
    else if ([error.errorString isEqualToString:UE_ERROR_URL_FORMAT_ERROR])
    {
        message = [NSString stringWithFormat:@"%@(%@[%d])",
                   LocalizedString(@"play_url_format_wrong"),
                   error.errorString,
                   error.internalErrorCode];
    }
    else
    {
        message = [NSString stringWithFormat:@"%@(%@[%d])",
                   LocalizedString(@"play_fail"),
                   error.errorString,
                   error.internalErrorCode];
    }
    [Toast error:message];
}

- (void) EZUIPlayer:(EZUIPlayer *)player previewWidth:(CGFloat)pWidth previewHeight:(CGFloat)pHeight
{
}

#pragma mark - player

- (void) playWithEzOpenUrl:(NSString *)ezOpenUrl
{
    if (_ezPlayer)
    {
        [_ezPlayer startPlay];
        return;
    }
    
    _ezPlayer = [EZUIPlayer createPlayerWithUrl:ezOpenUrl];
    [_ezPlayer setEZOpenUrl:ezOpenUrl];
    _ezPlayer.mDelegate = self;
    _ezPlayer.previewView.frame = self.view.bounds;
    [_view addSubview:_ezPlayer.previewView];
}

- (void) stop
{
    if (_ezPlayer)
    {
        [_ezPlayer stopPlay];
    }
}

- (void) releasePlayer
{
    if (_ezPlayer)
    {
        [_ezPlayer.previewView removeFromSuperview];
        [_ezPlayer releasePlayer];
        _ezPlayer= nil;
    }
}

- (UIView*)view {
    return _view;
}

@end

@implementation EzMonitorPlayerFactory {
    NSObject<FlutterBinaryMessenger>* _messenger;
}

- (instancetype)initWithMessenger:(NSObject<FlutterBinaryMessenger>*)messenger {
    self = [super init];
    if (self) {
        _messenger = messenger;
    }
    return self;
}

- (NSObject<FlutterMessageCodec>*)createArgsCodec {
    return [FlutterStandardMessageCodec sharedInstance];
}

- (NSObject<FlutterPlatformView>*)createWithFrame:(CGRect)frame
                                   viewIdentifier:(int64_t)viewId
                                        arguments:(id _Nullable)args {
    EzMonitorPlayer* player = [[EzMonitorPlayer alloc] initWithFrame:frame
                                                                                viewIdentifier:viewId
                                                                                     arguments:args
                                                                               binaryMessenger:_messenger];
    return player;
}

@end

