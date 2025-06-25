// lib/features/home/view/beranda_content_view.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sigap_pa_pbm/features/home/viewmodel/home_viewmodel.dart';

class BerandaContentView extends StatefulWidget {
  const BerandaContentView({super.key});

  @override
  State<BerandaContentView> createState() => _BerandaContentViewState();
}

class _BerandaContentViewState extends State<BerandaContentView> {
  bool isVolunteer = false;

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeViewModel>(
      builder: (context, homeViewModel, child) {
        if (homeViewModel.sosErrorMessage != null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(homeViewModel.sosErrorMessage!),
                backgroundColor: homeViewModel.sosErrorMessage!.contains('berhasil') ? Colors.green : Colors.red,
              ),
            );
            homeViewModel.clearSOSMessage(); 
          });
        }

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Hai!", style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.grey)),
              Text(
                homeViewModel.userName ?? homeViewModel.userEmail ?? "Pengguna SIGAP",
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 32),
              const Text.rich(
                TextSpan(
                  children: [
                    TextSpan(text: "Bantuan hanya sejauh satu klik!\n", style: TextStyle(fontSize: 16)),
                    TextSpan(text: "Klik ", style: TextStyle(fontSize: 16)),
                    TextSpan(text: "tombol SOS", style: TextStyle(fontSize: 16, color: Colors.red, fontWeight: FontWeight.bold)),
                    TextSpan(text: " untuk memanggil bantuan.", style: TextStyle(fontSize: 16))
                  ]
                ),
              ),
              const SizedBox(height: 32),
              Center(
                child: GestureDetector(
                  onTap: homeViewModel.isSendingSOS 
                      ? null 
                      : () async {
                          final bool success = await homeViewModel.sendSOSReport();
                          
                        },
                  child: Container(
                    width: 240,
                    height: 240,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.red,
                      boxShadow: List.generate(4, (i) => BoxShadow(
                        color: Colors.red.withOpacity(0.15),
                        blurRadius: (20.0 * (i + 1)),
                        spreadRadius: 1,
                      )),
                    ),
                    child: Center(
                      child: homeViewModel.isSendingSOS
                          ? const CircularProgressIndicator(color: Colors.white) // Tampilkan loading
                          : const Text("SOS", style: TextStyle(fontSize: 32, color: Colors.white, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 32),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Sukarelawan untuk membantu", style: TextStyle(fontSize: 16)),
                    Switch(
                      value: isVolunteer,
                      activeColor: Colors.red,
                      onChanged: homeViewModel.isSendingSOS 
                          ? null
                          : (val) => setState(() => isVolunteer = val),
                    ),
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }
}