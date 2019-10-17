import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ez_monitor_player/ez_monitor_player.dart';

void main() {
  const MethodChannel channel = MethodChannel('ez_monitor_player');

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    // expect(await EzMonitorPlayer.platformVersion, '42');
  });
}
