import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sigap_pa_pbm/features/home/viewmodel/home_viewmodel.dart';
import 'package:sigap_pa_pbm/core/services/auth_service.dart'; 

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {

    return Consumer<HomeViewModel>(
      builder: (consumerContext, homeViewModel, child) { 
        if (homeViewModel.currentUser == null) {
          return const Scaffold(
            backgroundColor: Colors.grey,
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        final currentUser = homeViewModel.currentUser!;

        return Scaffold(
          backgroundColor: Colors.grey.shade100,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: const Text('Profil'),
            centerTitle: false,
          ),
          body: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundImage: (currentUser.avatarUrl != null && currentUser.avatarUrl!.isNotEmpty)
                            ? NetworkImage(currentUser.avatarUrl!) as ImageProvider<Object>?
                            : null,
                        child: (currentUser.avatarUrl == null || currentUser.avatarUrl!.isEmpty)
                            ? Icon(Icons.person, size: 50, color: Colors.grey[700])
                            : null,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        currentUser.name ?? 'Nama Pengguna',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      Text(
                        currentUser.email ?? 'email pengguna', 
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
                      ),
                      Text(
                        currentUser.phoneNumber ?? 'Nomor HP: Belum diatur',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
                
                _buildMenuItem(title: "Detail Akun", onTap: () {
                  ScaffoldMessenger.of(consumerContext).showSnackBar( 
                    const SnackBar(content: Text('Detail Akun akan datang!')),
                  );
                }),
                _buildMenuItem(title: "Pengaturan SOS", onTap: () {
                  ScaffoldMessenger.of(consumerContext).showSnackBar( 
                    const SnackBar(content: Text('Pengaturan SOS akan datang!')),
                  );
                }),
                _buildMenuItem(title: "Pengaturan", onTap: () {
                  ScaffoldMessenger.of(consumerContext).showSnackBar( 
                    const SnackBar(content: Text('Pengaturan akan datang!')),
                  );
                }),
                _buildMenuItem(title: "Tentang", onTap: () {
                  ScaffoldMessenger.of(consumerContext).showSnackBar( 
                    const SnackBar(content: Text('Tentang Aplikasi akan datang!')),
                  );
                }),
                const Spacer(),
                Center(
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.red,
                      side: const BorderSide(color: Colors.red),
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    onPressed: () async {
                      await homeViewModel.signOut(consumerContext); 
                    },
                    child: const Text(
                      "Keluar",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildMenuItem({required String title, required VoidCallback onTap}) {
    return Column(
      children: [
        ListTile(
          title: Text(title),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          onTap: onTap,
        ),
        const Divider(height: 1)
      ],
    );
  }
}