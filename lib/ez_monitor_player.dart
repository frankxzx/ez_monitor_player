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

class EzMonitorPlayer extends StatefulWidget {
  final EzMonitorPlayerCreatedCallback onPlayerCreated;
  final EzMonitorPlayerDidPlayCallback onDidPlay;
  final EzMonitorPlayerDidPauseCallback onDidPause;

  EzMonitorPlayer(
      {Key key, this.onPlayerCreated, this.onDidPlay, this.onDidPause})
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
  ) : _channel = MethodChannel('plugins.xzx/ez_monitor_player$id') {
    _channel.setMethodCallHandler(_handleMethod);
  }
  final MethodChannel _channel;

  EzMonitorPlayer _widget;

  Future<dynamic> _handleMethod(MethodCall call) async {
    String method = call.method;
    switch (method) {
      case "play":
        {
          _widget.onDidPlay(this);
          return new Future.value("");
        }

      case "pause":
        {
          _widget.onDidPause(this);
          return new Future.value("");
        }
    }
    return new Future.value("");
  }

  Future<void> play(String ezOpenUrl) async {
    return await _channel.invokeMethod("play", <String, dynamic>{
      'ezOpenUrl': ezOpenUrl,
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
