import 'package:flutter/material.dart';
import '../helpers/MQTT.dart';
import '../Widgets/build_control_item.dart';

class ControlPanelMQTT extends StatefulWidget {
  const ControlPanelMQTT({super.key});

  @override
  State<ControlPanelMQTT> createState() => _ControlPanelMQTTState();
}

class _ControlPanelMQTTState extends State<ControlPanelMQTT> {
  final mqttService = MQTTService();

  bool entryDoorOpen = false;
  bool exitDoorOpen = false;
  bool ledOn = false;
  bool buzzerOn = false;

  @override
  void initState() {
    super.initState();

    // ✅ اسمع الرسائل أول ما الصفحة تفتح
    mqttService.onMessageReceived = (data) {
      final topic = data["topic"];
      final message = data["message"];

      setState(() {
        switch (topic) {
          case "home/entrydoor":
            entryDoorOpen = message == "open";
            break;
          case "home/exitdoor":
            exitDoorOpen = message == "open";
            break;
          case "home/led":
            ledOn = message == "on";
            break;
          case "home/buzzer":
            buzzerOn = message == "on";
            break;
        }
      });
    };
  }

  void _toggleDevice({
    required String topic,
    required bool currentState,
    required String onMessage,
    required String offMessage,
  }) {
    final message = currentState ? offMessage : onMessage;
    mqttService.publishMessage(topic, message);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Control Panel"),
      ),
      body: ListView(
        children: [
          buildControlItem(
            label: "Entry Door",
            isOn: entryDoorOpen,
            onToggle: () => _toggleDevice(
              topic: "home/entrydoor",
              currentState: entryDoorOpen,
              onMessage: "open",
              offMessage: "close",
            ),
          ),
          buildControlItem(
            label: "Exit Door",
            isOn: exitDoorOpen,
            onToggle: () => _toggleDevice(
              topic: "home/exitdoor",
              currentState: exitDoorOpen,
              onMessage: "open",
              offMessage: "close",
            ),
          ),
          buildControlItem(
            label: "LED",
            isOn: ledOn,
            onToggle: () => _toggleDevice(
              topic: "home/led",
              currentState: ledOn,
              onMessage: "on",
              offMessage: "off",
            ),
          ),
          buildControlItem(
            label: "Buzzer",
            isOn: buzzerOn,
            onToggle: () => _toggleDevice(
              topic: "home/buzzer",
              currentState: buzzerOn,
              onMessage: "on",
              offMessage: "off",
            ),
          ),
        ],
      ),
    );
  }
}
