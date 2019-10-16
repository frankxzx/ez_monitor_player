//
//  EzMonitorPlayer.h
//  ez_monitor_player
//
//  Created by Xuzixiang on 2019/10/16.
//

#import <Flutter/Flutter.h>

NS_ASSUME_NONNULL_BEGIN

@interface EzMonitorPlayer : NSObject<FlutterPlatformView>

- (instancetype)initWithFrame:(CGRect)frame
               viewIdentifier:(int64_t)viewId
                    arguments:(id _Nullable)args
              binaryMessenger:(NSObject<FlutterBinaryMessenger>*)messenger;
    
- (UIView*)view;

@end

@interface EzMonitorPlayerFactory : NSObject<FlutterPlatformViewFactory>
- (instancetype)initWithMessenger:(NSObject<FlutterBinaryMessenger>*)messenger;
@end


NS_ASSUME_NONNULL_END
