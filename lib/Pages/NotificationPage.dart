import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:timeago/timeago.dart' as timeago;

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  final SupabaseClient supabase = Supabase.instance.client;
  late Stream<List<Map<String, dynamic>>> alertsStream;

  @override
  void initState() {
    super.initState();
    alertsStream = supabase
        .from('alerts')
        .stream(primaryKey: ['id'])
        .order('happened_at')
        .map((event) => event);
  }

  Future<void> _deleteAlert(int id) async {
    await supabase.from('alerts').delete().eq('id', id);
  }

  Widget _buildAlertCard(Map<String, dynamic> alert) {
    final String alertType = alert['alert_type'] ?? "Unknown";
    final DateTime? dateTime = DateTime.tryParse(alert['happened_at'].toString());
    final String timeAgo = dateTime != null ? timeago.format(dateTime) : "Unknown";

    final bool isDoorAlert = alertType == "Car wants to enter garage!" ||
        alertType == "Car wants to leave garage!";

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: const Color(0xFF192A56),
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            const Icon(Icons.warning_amber_rounded, color: Colors.orange, size: 32),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    alertType,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    timeAgo,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                    ),
                  ),
                  if (isDoorAlert) ...[
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("Accepted: $alertType")),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: const Text("ACCEPT"),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: () {
                            _deleteAlert(alert['id']);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: const Text("REJECT"),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.close, color: Colors.white),
              onPressed: () => _deleteAlert(alert['id']),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("ALERTS"),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: alertsStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }
          final alerts = snapshot.data ?? [];
          if (alerts.isEmpty) {
            return const Center(
              child: Text("No alerts right now"),
            );
          }
          return ListView.builder(
            itemCount: alerts.length,
            itemBuilder: (context, index) {
              return _buildAlertCard(alerts[index]);
            },
          );
        },
      ),
    );
  }
}
