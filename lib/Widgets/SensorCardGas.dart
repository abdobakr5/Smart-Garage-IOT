import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:percent_indicator/circular_percent_indicator.dart';

class SensorCardGas extends StatelessWidget {
  final IconData icon;
  final String title;
  final Future<Map<String, dynamic>?> future;
  final String valueKey;
  final String timeKey;

  const SensorCardGas({
    super.key,
    required this.icon,
    required this.title,
    required this.future,
    required this.valueKey,
    required this.timeKey,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      height: 300,
      child: FutureBuilder<Map<String, dynamic>?>(
        future: future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Card(
              child: Center(child: CircularProgressIndicator()),
            );
          }
          if (snapshot.hasError) {
            return Card(
              child: Center(child: Text("Error: ${snapshot.error}")),
            );
          }
          if (!snapshot.hasData || snapshot.data == null) {
            return const Card(
              child: Center(child: Text("No data")),
            );
          }

          final data = snapshot.data!;
          final dateTime = DateTime.tryParse(data[timeKey].toString());
          final timeAgo = dateTime != null
              ? timeago.format(dateTime)
              : "Unknown time";

          final value = (data[valueKey] as num).clamp(0, 100); // تأكد من 0-100

          return Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 4,
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(icon, size: 40, color: Colors.black),
                  const SizedBox(height: 10),
                  Text(
                    title,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  CircularPercentIndicator(
                    radius: 60,
                    lineWidth: 8,
                    percent: value / 100,
                    center: Text(
                      "${value.toInt()}%",
                      style: const TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                    progressColor: value > 75
                        ? Colors.green
                        : value > 50
                        ? Colors.yellow
                        : Colors.red,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    timeAgo,
                    style: const TextStyle(fontSize: 12, color: Colors.black),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
