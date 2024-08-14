import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Admin/Profile.dart'; // Import Admin Profile Page
import '../Client/Profile.dart'; // Import Client Profile Page
import '../services/auth_provider.dart';

class ProfileWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: _getUserRole(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return CircularProgressIndicator(); // or some other loading widget
        }

        final userRole = snapshot.data;

        if (userRole == 'A') {
          return ProfilePage1(); // Admin profile page
        } else if (userRole == 'C') {
          return ProfilePage2(); // Client profile page
        } else {
          return Center(child: Text('Unexpected role: $userRole')); // Handle unexpected role
        }
      },
    );
  }

  Future<String?> _getUserRole() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('role');
  }
}
