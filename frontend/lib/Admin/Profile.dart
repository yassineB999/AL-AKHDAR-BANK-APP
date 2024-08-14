import 'package:flutter/material.dart';
import 'package:frontend/models/Utilisateur.dart';
import 'package:frontend/services/AdminService.dart';

class ProfilePage1 extends StatefulWidget {
  const ProfilePage1({Key? key}) : super(key: key);

  @override
  _ProfilePage1State createState() => _ProfilePage1State();
}

class _ProfilePage1State extends State<ProfilePage1> {
  final TextEditingController _nomController = TextEditingController();
  final TextEditingController _prenomController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _cinController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  bool _isLoading = false;
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  Utilisateur? _user;

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    setState(() {
      _isLoading = true;
    });
    try {
      Utilisateur? user = await AdminService.getProfile();
      setState(() {
        _user = user;
        _nomController.text = user?.nom ?? '';
        _prenomController.text = user?.prenom ?? '';
        _emailController.text = user?.email ?? '';
        _phoneController.text = user?.numerotelephone ?? '';
        _addressController.text = user?.adresse ?? '';
        _cinController.text = user?.cin ?? '';
      });
    } catch (e) {
      print('Error loading profile: $e');
    }
    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _updateUserProfile() async {
    if (_user == null) return;

    if (_passwordController.text.isNotEmpty &&
        _passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Passwords do not match!')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    Utilisateur updatedUser = Utilisateur(
      idUtilisateur: _user!.idUtilisateur,
      nom: _nomController.text,
      prenom: _prenomController.text,
      email: _emailController.text,
      numerotelephone: _phoneController.text,
      adresse: _addressController.text,
      cin: _cinController.text,
      age: _user!.age,
      password: _passwordController.text.isNotEmpty ? _passwordController.text : null,
    );

    try {
      await AdminService.updateProfile(updatedUser);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Profile updated successfully!')),
      );
    } catch (e) {
      print('Error updating profile: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update profile: $e')),
      );
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile"),
        backgroundColor: Colors.green, // Green color for the AppBar
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text(
                "Profile Information",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.green, // Green color for the title
                ),
              ),
              const SizedBox(height: 16),
              _buildTextField(_nomController, 'First Name'),
              _buildTextField(_prenomController, 'Last Name'),
              _buildTextField(_emailController, 'Email'),
              _buildTextField(_phoneController, 'Phone'),
              _buildTextField(_addressController, 'Address'),
              _buildTextField(_cinController, 'CIN'),
              _buildPasswordField(_passwordController, 'Password', _isPasswordVisible, () {
                setState(() {
                  _isPasswordVisible = !_isPasswordVisible;
                });
              }),
              _buildPasswordField(_confirmPasswordController, 'Confirm Password', _isConfirmPasswordVisible, () {
                setState(() {
                  _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                });
              }),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _updateUserProfile,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green, // Green color for the button
                  padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
                ),
                child: const Text('Update Profile', style: TextStyle(fontSize: 16)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
          filled: true,
          fillColor: Colors.grey[200],
        ),
      ),
    );
  }

  Widget _buildPasswordField(TextEditingController controller, String label, bool isVisible, VoidCallback toggleVisibility) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        obscureText: !isVisible,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
          filled: true,
          fillColor: Colors.grey[200],
          suffixIcon: IconButton(
            icon: Icon(
              isVisible ? Icons.visibility : Icons.visibility_off,
              color: Colors.green, // Green color for the eye icon
            ),
            onPressed: toggleVisibility,
          ),
        ),
      ),
    );
  }
}
