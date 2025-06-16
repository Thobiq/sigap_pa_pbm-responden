// Lokasi file: lib/features/sos/view/report_emergency_view.dart

import 'package:flutter/material.dart';

class ReportEmergencyView extends StatefulWidget {
  const ReportEmergencyView({super.key});

  @override
  State<ReportEmergencyView> createState() => _ReportEmergencyViewState();
}

class _ReportEmergencyViewState extends State<ReportEmergencyView> {
  String selectedType = 'Kecelakaan';
  final List<String> types = [
    'Kecelakaan', 'Kebakaran', 'Medis', 'Banjir', 'Gempa', 'Perampokan', 'Penyerangan', 'Lainnya'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
        title: const Text("Laporkan Keadaan Darurat"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Pilih Jenis Keadaan Darurat", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: types.map((type) {
                final bool isSelected = selectedType == type;
                return GestureDetector(
                  onTap: () => setState(() => selectedType = type),
                  child: Container(
                    width: 80,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.red : Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Text(
                        type,
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Lokasi", style: TextStyle(fontWeight: FontWeight.bold)),
                TextButton(
                  onPressed: () {},
                  child: const Text("Ubah", style: TextStyle(color: Colors.red)),
                )
              ],
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Row(
                children: [
                  Icon(Icons.location_on, color: Colors.red),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text("Kothrud, Pune, 411038")
                  )
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Text("Lampirkan Bukti", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _proofTile(Icons.camera_alt, "Ambil Foto"),
                _proofTile(Icons.videocam, "Rekam Video"),
                _proofTile(Icons.mic, "Rekam Suara"),
              ],
            ),
            const SizedBox(height: 24),
            const Text("Deskripsikan keadaan darurat secara singkat", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            TextFormField(
              maxLines: 4,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                hintText: "Tulis di sini...",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {},
                child: const Text("Kirim Laporan"),
              ),
            )
          ],
        ),
      ),
      backgroundColor: Colors.grey.shade100,
    );
  }

  Widget _proofTile(IconData icon, String label) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: Colors.white,
          ),
          child: Icon(icon, color: Colors.red, size: 28),
        ),
        const SizedBox(height: 8),
        Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500))
      ],
    );
  }
}