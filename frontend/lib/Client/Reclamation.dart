import 'package:flutter/material.dart';
import 'package:frontend/models/Reclamation.dart';
import 'package:frontend/models/Utilisateur.dart'; // Assuming you have a current user model available
import 'package:frontend/services/ClientService.dart';

class ReclamationPage extends StatefulWidget {
  @override
  _ReclamationPageState createState() => _ReclamationPageState();
}

class _ReclamationPageState extends State<ReclamationPage> {
  final _descriptionController = TextEditingController();
  String? _selectedReclamationType;
  final List<String> _reclamationTypes = [
    'Problème de carte',
    'Problème de compte',
    'Demande de prêt',
    'Litige de transaction',
    'Autre'
  ];

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _submitReclamation() async {
    if (_selectedReclamationType != null && _descriptionController.text.isNotEmpty) {
      // Assuming you have access to the current user
      Utilisateur currentUser = Utilisateur(
        idUtilisateur: 1, // Replace with actual user ID
        cin: "", // Replace with actual user CIN
        nom: "", // Replace with actual user last name
        prenom: "", // Replace with actual user first name
        numerotelephone: "", // Replace with actual user phone number
        email: "", // Replace with actual user email
        adresse: "", // Replace with actual user address
        age: "", // Replace with actual user age
      );

      Reclamation reclamation = Reclamation(
        idReclamation: 0, // Set to 0 or a placeholder, the backend should handle this
        date: DateTime.now().toIso8601String(), // Use the current date/time
        description: _descriptionController.text,
        type: _selectedReclamationType!,
        status: "En attente", // Default status for a new reclamation
        utilisateur: currentUser, // Pass the current user object
      );

      try {
        await ClientService.sendReclamation(reclamation);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Réclamation soumise avec succès !')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Échec de la soumission de la réclamation : $e')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Veuillez remplir tous les champs')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text('Réclamation'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Description',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            TextField(
              controller: _descriptionController,
              maxLines: 4,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Entrez votre description',
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Type de réclamation',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: _selectedReclamationType,
              onChanged: (value) {
                setState(() {
                  _selectedReclamationType = value;
                });
              },
              items: _reclamationTypes
                  .map((type) => DropdownMenuItem<String>(
                value: type,
                child: Text(type),
              ))
                  .toList(),
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Sélectionnez le type de réclamation',
              ),
            ),
            Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _submitReclamation,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: EdgeInsets.symmetric(vertical: 16),
                  textStyle: TextStyle(fontSize: 18),
                ),
                child: Text('Soumettre'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
