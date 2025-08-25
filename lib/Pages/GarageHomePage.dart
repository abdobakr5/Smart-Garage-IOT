import 'package:flutter/material.dart';
import '../Widgets/MenuButton.dart';
import 'DashBoard.dart';
import 'ControlPage.dart';
import 'NotificationPage.dart';

class GarageHomePage extends StatelessWidget {
  final String userName;

  const GarageHomePage({super.key, required this.userName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    "Welcome, $userName To Your Garage!",
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF271C14),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),


            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  child: Divider(
                    color: Colors.blueAccent,
                    thickness: 1.5,
                  ),
                ),
                Image.asset(
                  "assets/images/car1.png",
                  height: 30,
                ),
              ],
            ),

            const SizedBox(height: 30),

            buildMenuButton(context, "DASHBOARD", () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Dashboard()),
              );
            }),
            const SizedBox(height: 35),
            buildMenuButton(context, "CONTROL", () {
              Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ControlPanelMQTT()),
              );
            }),
            const SizedBox(height: 35),
            buildMenuButton(context,"NOTIFICATION", () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const NotificationsPage()),
              );
            }),

            const Spacer(),

            Align(
              alignment: Alignment.bottomLeft,
              child: Image.asset(
                "assets/images/car.png",
                height: 60,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
