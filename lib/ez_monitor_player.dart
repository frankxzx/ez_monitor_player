import 'dart:async';

import 'package:flutter/services.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

typedef void EzMonitorPlayerCreatedCallback(
    EzMonitorPlayerController controller);
typedef void EzMonitorPlayerDidPlayCallback(
    EzMonitorPlayerController controller);
typedef void EzMonitorPlayerDidPauseCallback(
    EzMonitorPlayerController controller);
typedef void EzMonitorPlayerDidFailedCallback(
    EzMonitorPlayerController controller);

class EzMonitorPlayer extends StatefulWidget {
  final EzMonitorPlayerCreatedCallback onPlayerCreated;
  final EzMonitorPlayerDidPlayCallback onDidPlay;
  final EzMonitorPlayerDidPauseCallback onDidPause;
  final EzMonitorPlayerDidFailedCallback onDidFail;

  EzMonitorPlayer(
      {Key key,
      this.onPlayerCreated,
      this.onDidPlay,
      this.onDidPause,
      this.onDidFail})
      : super(key: key);

  _EzMonitorPlayerState createState() => _EzMonitorPlayerState();
}

class _EzMonitorPlayerState extends State<EzMonitorPlayer> {
  final Completer<EzMonitorPlayerController> _controller =
      Completer<EzMonitorPlayerController>();

  void _onPlatformViewCreated(int id) {
    final EzMonitorPlayerController controller =
        EzMonitorPlayerController._(id, widget);
    _controller.complete(controller);
    if (widget.onPlayerCreated != null) {
      widget.onPlayerCreated(controller);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (defaultTargetPlatform == TargetPlatform.android) {
      return AndroidView(
        viewType: "plugins.xzx/ez_monitor_player",
        onPlatformViewCreated: _onPlatformViewCreated,
        creationParams: _CreationParams.fromWidget(widget).toMap(),
        creationParamsCodec: const StandardMessageCodec(),
      );
    } else if (defaultTargetPlatform == TargetPlatform.iOS) {
      return UiKitView(
        viewType: "plugins.xzx/ez_monitor_player",
        onPlatformViewCreated: _onPlatformViewCreated,
        creationParams: _CreationParams.fromWidget(widget).toMap(),
        creationParamsCodec: const StandardMessageCodec(),
      );
    }
    return Text(
        '$defaultTargetPlatform is not yet supported by the flutter_2d_amap plugin');
  }
}

class EzMonitorPlayerController {
  EzMonitorPlayerController._(
    int id,
    this._widget,
  ) : _channel = MethodChannel('plugins.xzx/ez_monitor_player_$id') {
    _channel.setMethodCallHandler(_handleMethod);
  }
  final MethodChannel _channel;

  EzMonitorPlayer _widget;

  Future<dynamic> _handleMethod(MethodCall call) async {
    debugPrint('oc call back');
    String method = call.method;
    switch (method) {
      case "didPlay":
        {
          debugPrint('flutter receive oc call back didPlay');
          _widget.onDidPlay(this);
          return new Future.value("");
        }
      case "didPause":
        {
          _widget.onDidPause(this);
          return new Future.value("");
        }
      case "didFailed":
        {
          _widget.onDidFail(this);
          return new Future.value("");
        }
    }
    return new Future.value("");
  }

  //"ezopen://open.ys7.com/D01590415/1.hd.live"
  //_accessToken	@"at.9bkf61je8xypdnj03ho1aj1sdfub8612-2dmoh97t8w-04mdr2y-lbphujgu4"
  //_appKey @"6e9f8a8c05cb4e57843a85afdf49ff57"
  Future<void> play(String ezOpenUrl) async {
    return await _channel.invokeMethod("play", <String, dynamic>{
      'ezOpenUrl': ezOpenUrl.length > 0
          ? ezOpenUrl
          : 'ezopen://open.ys7.com/D01590415/5.hd.live',
    });
  }

  Future<void> pause() async {
    return await _channel.invokeMethod("pause");
  }
}

/// 需要更多的初始化配置，可以在此处添加
class _CreationParams {
  _CreationParams({this.param});

  static _CreationParams fromWidget(EzMonitorPlayer widget) {
    return _CreationParams(
      param: 'foo',
    );
  }

  final String param;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'foo': param,
    };
  }
}
