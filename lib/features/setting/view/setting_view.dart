import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sigap_pa_pbm/features/home/viewmodel/home_viewmodel.dart';
import 'package:sigap_pa_pbm/core/services/auth_service.dart'; 

class SettingView extends StatelessWidget {
  const SettingView({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
          backgroundColor: Colors.grey.shade100,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: const Text('Halaman Setting'),
            centerTitle: false,
          ),
          body: Padding(padding: EdgeInsets.all(12),
          child: const Text('Setting'),)
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