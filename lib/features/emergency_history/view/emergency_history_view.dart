import 'package:flutter/material.dart';

class EmergencyHistoryView extends StatefulWidget {
  const EmergencyHistoryView({super.key});

  @override
  State<EmergencyHistoryView> createState() => _EmergencyHistoryViewState();
}

class _EmergencyHistoryViewState extends State<EmergencyHistoryView> {
  bool reportedByYou = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text('Keadaan Darurat'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => reportedByYou = true),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: reportedByYou ? Colors.red.shade100 : Colors.transparent,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Center(
                        child: Text(
                          'Dilaporkan Oleh Anda',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => reportedByYou = false),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: !reportedByYou ? Colors.red.shade100 : Colors.transparent,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Center(
                        child: Text(
                          'Dilaporkan Oleh Orang Lain',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            _buildEmergencyCard(),
          ],
        ),
      ),
    );
  }

  Widget _buildEmergencyCard() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.location_on, color: Colors.red),
                    SizedBox(width: 4),
                    Text("Kothrud, Pune, 411038"),
                  ],
                ),
                Icon(Icons.delete, color: Colors.red)
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Container(
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.red,
                  ),
                  padding: const EdgeInsets.all(12),
                  child: const Icon(Icons.car_crash, color: Colors.white, size: 20),
                ),
                const SizedBox(width: 12),
                const Text("Kecelakaan Lalu Lintas", style: TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 12),
            const Text(
              "Insiden melibatkan kendaraan MH 41 AK 6543, yang bertabrakan antara mobil dan sepeda motor. Kecelakaan ini menyebabkan cedera kepala serius pada pengendara motor. Layanan darurat segera dibutuhkan di lokasi ini.",
              style: TextStyle(color: Colors.black87),
            ),
          ],
        ),
      ),
    );
  }
}