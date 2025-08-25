import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;

class SensorCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final Future<Map<String, dynamic>?> future;
  final String valueKey;
  final String timeKey;

  const SensorCard({
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

          final cardColor = data[valueKey] == "No_Detection"
              ? Colors.green
              : data[valueKey] == "Car_Detected"
              ? Colors.red
              : const Color(0xFFFFFFFF); // Off White
          return Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 4,
            color: cardColor,
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(icon,
                      size: 40,
                      color: data[valueKey] == "No_Detection"
                          ? Colors.white
                          : data[valueKey] == "Car_Detected"
                          ? Colors.white
                          : Colors.black), // Off White,
                  const SizedBox(height: 10),
                  Text(
                    title,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "${data[valueKey]}",
                    style: TextStyle(
                        fontSize: 22,
                        color: data[valueKey] == "No_Detection"
                            ? Colors.white
                            : data[valueKey] == "Car_Detected"
                            ? Colors.white
                            : Color(0xFF000000)
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                      timeAgo,
                      style: TextStyle(fontSize: 12,
                          color: data[valueKey] == "No_Detection"
                          ? Colors.white
                              : data[valueKey] == "Car_Detected"
                          ? Colors.white
                          : const Color(0xFF000000)),
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
