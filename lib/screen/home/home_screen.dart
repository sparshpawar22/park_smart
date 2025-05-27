import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'home_map.dart';
import 'home_actions.dart';
import 'home_controller.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final controller = HomeController();

  @override
  void initState() {
    super.initState();
    controller.init(context, setState);
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: Text("Welcome, ${user?.displayName ?? 'User'}"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: controller.handleLogout,
          ),
        ],
      ),
      body: controller.currentLocation == null
          ? const Center(child: CircularProgressIndicator())
          : Stack(
        children: [
          HomeMap(controller: controller),
          if (controller.bookingActive)
            HomeActions(controller: controller),
        ],
      ),
    );
  }
}
