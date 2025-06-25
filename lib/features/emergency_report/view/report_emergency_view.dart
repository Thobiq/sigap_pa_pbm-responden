import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Import Provider
import 'package:image_picker/image_picker.dart'; // Untuk ImageSource
import 'package:sigap_pa_pbm/features/emergency_report/viewmodel/report_emergency_viewmodel.dart'; // Import ViewModel
import 'dart:io';

import 'package:sigap_pa_pbm/features/lanjutan/view/lanjutan_view.dart'; 

class ReportEmergencyView extends StatefulWidget {
  const ReportEmergencyView({super.key});

  @override
  State<ReportEmergencyView> createState() => _ReportEmergencyViewState();
}

class _ReportEmergencyViewState extends State<ReportEmergencyView> {
  final TextEditingController _descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ReportEmergencyViewModel>(
      builder: (context, viewModel, child) {
        if (viewModel.errorMessage != null || viewModel.successMessage != null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(viewModel.errorMessage ?? viewModel.successMessage!),
                backgroundColor: viewModel.errorMessage != null ? Colors.red : Colors.green,
              ),
            );
            viewModel.clearMessages(); 
          });
        }

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
                  children: viewModel.reportTypes.map((type) { 
                    final bool isSelected = viewModel.selectedReportType == type;
                    return GestureDetector(
                      onTap: () => viewModel.setSelectedReportType(type), 
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

                // --- Bagian Lokasi ---
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Lokasi", style: TextStyle(fontWeight: FontWeight.bold)),
                    viewModel.isGettingLocation
                        ? const SizedBox(
                            width: 20, height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2) // Loading lokasi
                          )
                        : TextButton(
                            onPressed: viewModel.refreshLocation, // Panggil refreshLocation dari ViewModel
                            child: const Text("Ubah", style: TextStyle(color: Colors.red)),
                          ),
                  ],
                ),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.location_on, color: Colors.red),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          viewModel.currentLocation == null
                              ? 'Lokasi belum didapatkan.'
                              : 'Lat: ${viewModel.currentLocation!.latitude?.toStringAsFixed(6)}, Lon: ${viewModel.currentLocation!.longitude?.toStringAsFixed(6)}',
                          style: TextStyle(color: viewModel.currentLocation == null ? Colors.grey : Colors.black),
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // --- Bagian Lampirkan Bukti ---
                const Text("Lampirkan Bukti", style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _proofTile(context, Icons.camera_alt, "Ambil Foto", () => viewModel.pickAndUploadProof(source: ImageSource.camera)),
                    _proofTile(context, Icons.photo_library, "Pilih Foto", () => viewModel.pickAndUploadProof(source: ImageSource.gallery)),
                   
                  ],
                ),
                const SizedBox(height: 12),
                if (viewModel.isUploadingProof)
                  const LinearProgressIndicator(),
                if (viewModel.selectedProofFile != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Image.file(
                      File(viewModel.selectedProofFile!.path),
                      height: 100,
                      fit: BoxFit.cover,
                    ),
                  ),
                if (viewModel.uploadedImageUrl != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text('URL Gambar: ${viewModel.uploadedImageUrl!}', style: const TextStyle(fontSize: 10, color: Colors.green)),
                  ),

                const SizedBox(height: 24),

                const Text("Deskripsikan keadaan darurat secara singkat", style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _descriptionController, // Hubungkan dengan Controller
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
                const SizedBox(height: 8),

                SizedBox(
                  width: double.infinity,
                  height: 46,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: viewModel.isSendingReport || viewModel.isGettingLocation || viewModel.isUploadingProof
                        ? null // Nonaktifkan tombol jika sedang loading
                        : () async {
                            final bool success = await viewModel.sendEmergencyReport(
                              description: _descriptionController.text,
                            );
                            if (success) {
                              _descriptionController.clear(); // Bersihkan field setelah sukses
                            }
                          },
                    child: viewModel.isSendingReport
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text("Kirim Laporan", style: TextStyle(color: Colors.white)),
                  ),
                ),
                
                // SizedBox(
                //   width: double.infinity,
                //   height: 46,
                //   child: ElevatedButton(
                //     style: ElevatedButton.styleFrom(
                //       backgroundColor: Colors.red,
                //       shape: RoundedRectangleBorder(
                //         borderRadius: BorderRadius.circular(12),
                //       ),
                //     ),
                //     onPressed: viewModel.isSendingReport || viewModel.isGettingLocation || viewModel.isUploadingProof
                //         ? null // Nonaktifkan tombol jika sedang loading
                //         : () async {
                //             final bool success = await viewModel.sendEmergencyReport(
                //               description: _descriptionController.text,
                //             );
                //             if (success) {
                //               _descriptionController.clear(); // Bersihkan field setelah sukses
                //             }
                //           },
                //     child: viewModel.isSendingReport
                //         ? const CircularProgressIndicator(color: Colors.white)
                //         : const Text("Kirim Laporan", style: TextStyle(color: Colors.white)),
                //   ),
                // ),
                SizedBox(height: 8,),
                SizedBox(
                  height: 48,
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: (){
                      Navigator.push(context, 
                      MaterialPageRoute(builder: (context) => const LanjutanView()));
                    }, 
                  child: Text('Lanjutan')),
                )
              ],
            ),
          ),
          backgroundColor: Colors.grey.shade100,
        );
      },
    );
  }

  // Mengubah _proofTile menjadi metode di dalam _ReportEmergencyViewState
  // agar bisa mengakses context
  Widget _proofTile(BuildContext context, IconData icon, String label, VoidCallback onTap) {
    return Expanded( // Gunakan Expanded agar 3 item bisa dibagi rata
      child: GestureDetector(
        onTap: onTap,
        child: Column(
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
            Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500), textAlign: TextAlign.center,)
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }
}