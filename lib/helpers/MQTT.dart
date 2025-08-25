import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'dart:io';

class MQTTService {
  static final MQTTService _instance = MQTTService._internal();
  factory MQTTService() => _instance;
  MQTTService._internal();

  late MqttServerClient client;
  Function(Map<String, dynamic>)? onMessageReceived;

  bool _isConnecting = false;

  Future<void> connect() async {
    // ✅ أول حاجة نعملها قبل أي شرط
    client = MqttServerClient.withPort(
      '4449115bd1ad4c178ff93869c6df3086.s1.eu.hivemq.cloud',
      'flutter_client_${DateTime.now().millisecondsSinceEpoch}',
      8883,
    );

    if (client.connectionStatus?.state == MqttConnectionState.connected || _isConnecting) {
      print("🔌 Already connected to HiveMQ Cloud ✅");
      return;
    }

    _isConnecting = true;
    try {
      client.secure = true;
      client.securityContext = SecurityContext.defaultContext;
      client.keepAlivePeriod = 20;
      client.logging(on: false);

      client.onDisconnected = onDisconnected;
      client.onConnected = onConnected;

      print("🔄 Connecting to HiveMQ...");
      await client.connect("Abdelrhman", "Aa3824895");

      if (client.connectionStatus?.state == MqttConnectionState.connected) {
        print("✅ Connected to HiveMQ Cloud!");
        _subscribeToDefaultTopics();
      } else {
        print("❌ Connection failed. Status: ${client.connectionStatus}");
        client.disconnect();
      }
    } catch (e) {
      print("❌ Exception: $e");
      client.disconnect();
    }

    _isConnecting = false;
  }

  void _subscribeToDefaultTopics() {
    final topics = [
      'home/entrydoor',
      'home/exitdoor',
      'home/led',
      'home/buzzer',
    ];

    for (var topic in topics) {
      client.subscribe(topic, MqttQos.atLeastOnce);
      print("📡 Subscribed to $topic");
    }

    client.updates!.listen((List<MqttReceivedMessage<MqttMessage>> event) {
      final recMess = event[0].payload as MqttPublishMessage;
      final message = MqttPublishPayload.bytesToStringAsString(recMess.payload.message);
      final topic = event[0].topic;

      print("📨 Received: '$message' on '$topic'");
      if (onMessageReceived != null) {
        onMessageReceived!({"topic": topic, "message": message});
      }
    });
  }

  void publishMessage(String topic, String message) {
    if (client.connectionStatus?.state == MqttConnectionState.connected) {
      final builder = MqttClientPayloadBuilder();
      builder.addString(message);
      client.publishMessage(topic, MqttQos.atLeastOnce, builder.payload!);
      print("📤 Published '$message' to '$topic'");
    } else {
      print("❌ Cannot publish - MQTT disconnected");
    }
  }

  void onConnected() => print("🔗 Connected to HiveMQ Cloud");
  void onDisconnected() => print("🔌 Disconnected from HiveMQ Cloud");

  bool get isConnected => client.connectionStatus?.state == MqttConnectionState.connected;
}

