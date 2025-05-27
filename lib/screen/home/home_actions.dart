import 'package:flutter/material.dart';
import 'home_controller.dart';

class HomeActions extends StatelessWidget {
  final HomeController controller;

  const HomeActions({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 20,
      left: 10,
      right: 10,
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton(
              onPressed: () => controller.confirmAction(
                "Cancel Booking", "Your booking has been cancelled.", "cancelled",
              ),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text("Cancel Booking"),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: ElevatedButton(
              onPressed: () => controller.confirmAction(
                "Reached Destination", "You have reached your spot.", "completed",
              ),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              child: const Text("Reached Destination"),
            ),
          ),
        ],
      ),
    );
  }
}
