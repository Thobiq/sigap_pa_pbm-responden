import 'package:flutter/material.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  bool isVolunteer = false;
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: Icon(Icons.notifications, color: Colors.black),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Hai!", style: TextStyle(fontSize: 20, color: Colors.grey)),
            const Text("Nutan Khangar", style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
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
                onTap: () => showDialog(
                  context: context,
                  builder: (_) => const AlertDialog(title: Text("SOS berhasil dikirim!")),
                ),
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
                  child: const Center(
                    child: Text("SOS", style: TextStyle(fontSize: 32, color: Colors.white, fontWeight: FontWeight.bold)),
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
                    onChanged: (val) => setState(() => isVolunteer = val),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.red,
        unselectedItemColor: Colors.grey,
        onTap: (index) => setState(() => _selectedIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Beranda'),
          BottomNavigationBarItem(icon: Icon(Icons.info_outline), label: 'SOS'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Profil'),
        ],
      ),
    );
  }
}
