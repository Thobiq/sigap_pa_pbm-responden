import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sigap_pa_pbm/features/home/viewmodel/home_viewmodel.dart';

import 'package:sigap_pa_pbm/features/home/view/beranda_content_view.dart'; 
import 'package:sigap_pa_pbm/features/emergency_report/view/report_emergency_view.dart'; 
import 'package:sigap_pa_pbm/features/profile/view/profile_view.dart'; 
import 'package:sigap_pa_pbm/features/setting/view/setting_view.dart'; 



class HomeView extends StatefulWidget { 
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int _selectedIndex = 0; 

  final List<Widget> _widgetOptions = <Widget>[
    const BerandaContentView(), 
    const ReportEmergencyView(),         
    const ProfileView(),     
    const SettingView(),    
  ];

  @override
  void initState() {
    super.initState();
    Provider.of<HomeViewModel>(context, listen: false).loadUserDataAndToken();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final homeViewModel = Provider.of<HomeViewModel>(context); 

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: Colors.transparent, 
        elevation: 0,
        title: Text(
          _selectedIndex == 0 ? "Beranda" : _selectedIndex == 1 ? "SOS" : "Profil",
          style: const TextStyle(color: Colors.black) 
        ),
        actions: [
         
          if (_selectedIndex == 0)
            const Padding(
              padding: EdgeInsets.only(right: 16.0),
              child: Icon(Icons.notifications, color: Colors.black),
            ),
          
        ],
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.red,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped, 
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Beranda'),
          BottomNavigationBarItem(icon: Icon(Icons.info_outline), label: 'SOS'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Profil'),
          BottomNavigationBarItem(icon: Icon(Icons.settings_accessibility_outlined), label: 'Setting'),

        ],
      ),
    );
  }
}