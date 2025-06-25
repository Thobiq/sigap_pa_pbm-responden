import 'package:flutter/material.dart';

class LanjutanView extends StatelessWidget {
  const LanjutanView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Halaman Lanjutan'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Center(
        child: Text('Halaman Lanjutan'),
     ),
);
  }}