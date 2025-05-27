import 'package:flutter/material.dart';
import 'booking_detail_screen.dart';

class SlotSelectionScreen extends StatelessWidget {
  const SlotSelectionScreen({super.key});

  final List<String> slots = const [
    "A-1", "A-2", "A-3", "A-4", "A-5", "A-6", "A-7", "A-8"
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "SMART CAR PARKING",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
      ),
      backgroundColor: Colors.grey[100],
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            Text(
              "Parking Slots",
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple.shade700,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              "1 Floor",
              style: theme.textTheme.titleMedium?.copyWith(
                color: Colors.deepPurpleAccent,
                fontWeight: FontWeight.w600,
              ),
            ),
            const Divider(height: 30, thickness: 1.2),
            Center(
              child: Text(
                "SELECT SLOT",
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: Colors.deepPurple,
                  letterSpacing: 1.1,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: GridView.builder(
                padding: EdgeInsets.zero,
                itemCount: slots.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 3.2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                itemBuilder: (context, index) {
                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 4,
                    shadowColor: Colors.deepPurple.withOpacity(0.3),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(14),
                      onTap: () async {
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => BookingDetailsScreen(
                              slotName: slots[index],
                            ),
                          ),
                        );

                        if (result != null) {
                          Navigator.pop(context, result);
                        }
                      },
                      splashColor: Colors.deepPurpleAccent.withOpacity(0.2),
                      child: Center(
                        child: Text(
                          slots[index],
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.deepPurple.shade800,
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
