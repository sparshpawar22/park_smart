import 'package:flutter/material.dart';

class BookingDetailsScreen extends StatefulWidget {
  final String slotName;

  const BookingDetailsScreen({super.key, required this.slotName});

  @override
  State<BookingDetailsScreen> createState() => _BookingDetailsScreenState();
}

class _BookingDetailsScreenState extends State<BookingDetailsScreen> {
  final TextEditingController _nameController = TextEditingController();
  double _duration = 1;
  final double _ratePerHour = 20.0;

  @override
  Widget build(BuildContext context) {
    final double totalCost = _duration * _ratePerHour;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Confirm Booking"),
        backgroundColor: Colors.deepPurple,
        elevation: 0,
      ),
      backgroundColor: Colors.grey[100],
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Name Field
            Text(
              "Name",
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
                color: Colors.deepPurple.shade700,
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                hintText: "Enter your name",
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
                contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(color: Colors.deepPurple.shade100),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide:
                  BorderSide(color: Colors.deepPurple.shade400, width: 2),
                ),
              ),
            ),

            const SizedBox(height: 30),

            // Duration Slider
            Text(
              "Duration (in hours)",
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
                color: Colors.deepPurple.shade700,
              ),
            ),
            const SizedBox(height: 10),
            Slider(
              value: _duration,
              min: 1,
              max: 24,
              divisions: 23,
              label:
              "${_duration.toInt()} hr${_duration.toInt() > 1 ? 's' : ''}",
              activeColor: Colors.deepPurple,
              onChanged: (val) => setState(() => _duration = val),
            ),
            Center(
              child: Text(
                "Selected duration: ${_duration.toInt()} hour${_duration.toInt() > 1 ? 's' : ''}",
                style: theme.textTheme.bodyMedium
                    ?.copyWith(color: Colors.grey[600]),
              ),
            ),

            const SizedBox(height: 30),

            // Slot Info
            Row(
              children: [
                const Icon(Icons.local_parking, color: Colors.deepPurple),
                const SizedBox(width: 12),
                Text(
                  "Selected Slot: ${widget.slotName}",
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: Colors.deepPurple.shade800,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 30),

            // Cost Info
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
              decoration: BoxDecoration(
                color: Colors.deepPurple.shade50,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.deepPurple.shade200),
                boxShadow: [
                  BoxShadow(
                    color: Colors.deepPurple.withOpacity(0.1),
                    offset: const Offset(0, 5),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Total Cost:",
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.deepPurple.shade700,
                    ),
                  ),
                  Text(
                    "₹${totalCost.toStringAsFixed(2)}",
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.deepPurple.shade700,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  final name = _nameController.text.trim();
                  if (name.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Please enter your name")),
                    );
                    return;
                  }
                  Navigator.pop(context, {
                    'name': name,
                    'time': _duration.toInt(),
                    'price': totalCost,
                  });
                },
                icon: const Icon(Icons.check_circle_outline),
                label: const Text("Confirm Booking"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  textStyle: const TextStyle(fontSize: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
