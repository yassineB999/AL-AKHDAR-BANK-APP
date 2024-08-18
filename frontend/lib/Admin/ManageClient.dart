import 'package:flutter/material.dart';
import 'package:frontend/models/Utilisateur.dart';
import 'package:frontend/services/AdminService.dart';

class ManageClient extends StatefulWidget {
  @override
  _ManageClientState createState() => _ManageClientState();
}

class _ManageClientState extends State<ManageClient> {
  late Future<List<Utilisateur>> _clients;
  List<Utilisateur> _filteredClients = [];
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchClients();
    _searchController.addListener(_filterClients);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _fetchClients() {
    setState(() {
      _clients = AdminService.getClients();
      _clients.then((clients) {
        _filteredClients = clients;
      });
    });
  }

  void _filterClients() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _clients.then((clients) {
        _filteredClients = clients.where((client) {
          return client.email.toLowerCase().contains(query);
        }).toList();
      });
    });
  }

  void _showClientDialog({Utilisateur? client}) {
    final _formKey = GlobalKey<FormState>();
    final _cinController = TextEditingController(text: client?.cin ?? '');
    final _nomController = TextEditingController(text: client?.nom ?? '');
    final _prenomController = TextEditingController(text: client?.prenom ?? '');
    final _emailController = TextEditingController(text: client?.email ?? '');
    final _telephoneController = TextEditingController(text: client?.numerotelephone ?? '');
    final _adresseController = TextEditingController(text: client?.adresse ?? '');
    final _ageController = TextEditingController(text: client?.age ?? '');
    final _passwordController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(client == null ? 'Ajouter un Client' : 'Modifier un Client'),
          content: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildTextField(controller: _cinController, label: 'CIN'),
                  _buildTextField(controller: _nomController, label: 'Nom'),
                  _buildTextField(controller: _prenomController, label: 'Prénom'),
                  _buildTextField(controller: _emailController, label: 'Email', keyboardType: TextInputType.emailAddress),
                  _buildTextField(controller: _telephoneController, label: 'Téléphone'),
                  _buildTextField(controller: _adresseController, label: 'Adresse'),
                  _buildTextField(controller: _ageController, label: 'Âge'),
                  if (client == null)
                    _buildTextField(
                      controller: _passwordController,
                      label: 'Mot de passe',
                      keyboardType: TextInputType.visiblePassword,
                      obscureText: true,
                    ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Annuler'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (_formKey.currentState?.validate() ?? false) {
                  final newClient = Utilisateur(
                    idUtilisateur: client?.idUtilisateur ?? 0,
                    cin: _cinController.text,
                    nom: _nomController.text,
                    prenom: _prenomController.text,
                    email: _emailController.text,
                    numerotelephone: _telephoneController.text,
                    adresse: _adresseController.text,
                    age: _ageController.text,
                    password: client == null ? _passwordController.text : null,
                  );

                  if (client == null) {
                    await AdminService.addClient(newClient);
                  } else {
                    await AdminService.updateClient(client.idUtilisateur, newClient);
                  }

                  Navigator.of(context).pop();
                  _fetchClients();
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green, // Button color set to green
              ),
              child: Text(client == null ? 'Ajouter' : 'Modifier'),
            ),
          ],
        );
      },
    );
  }

  void _deleteClient(int id) async {
    await AdminService.deleteClient(id);
    _fetchClients();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gérer les Clients'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      labelText: 'Rechercher par Email',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () => _showClientDialog(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green, // Button color set to green
                  ),
                  child: Text('Ajouter un Client'),
                ),
              ],
            ),
            SizedBox(height: 20),
            Expanded(
              child: FutureBuilder<List<Utilisateur>>(
                future: _clients,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Erreur : ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text('Aucun client disponible.'));
                  } else {
                    return _buildClientTable(_filteredClients);
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildClientTable(List<Utilisateur> clients) {
    return Center(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.green), // Border color set to green
            borderRadius: BorderRadius.circular(10),
          ),
          columnSpacing: 16.0,
          columns: const [
            DataColumn(label: Text('ID', style: TextStyle(fontWeight: FontWeight.bold))),
            DataColumn(label: Text('CIN', style: TextStyle(fontWeight: FontWeight.bold))),
            DataColumn(label: Text('Nom', style: TextStyle(fontWeight: FontWeight.bold))),
            DataColumn(label: Text('Prénom', style: TextStyle(fontWeight: FontWeight.bold))),
            DataColumn(label: Text('Email', style: TextStyle(fontWeight: FontWeight.bold))),
            DataColumn(label: Text('Téléphone', style: TextStyle(fontWeight: FontWeight.bold))),
            DataColumn(label: Text('Adresse', style: TextStyle(fontWeight: FontWeight.bold))),
            DataColumn(label: Text('Âge', style: TextStyle(fontWeight: FontWeight.bold))),
            DataColumn(label: Text('Actions', style: TextStyle(fontWeight: FontWeight.bold))),
          ],
          rows: clients.map((client) {
            return DataRow(cells: [
              DataCell(Text(client.idUtilisateur.toString())),
              DataCell(Text(client.cin)),
              DataCell(Text(client.nom)),
              DataCell(Text(client.prenom)),
              DataCell(Text(client.email)),
              DataCell(Text(client.numerotelephone)),
              DataCell(Text(client.adresse)),
              DataCell(Text(client.age)),
              DataCell(Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.edit, color: Colors.blue),
                    onPressed: () => _showClientDialog(client: client),
                  ),
                  IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _deleteClient(client.idUtilisateur),
                  ),
                ],
              )),
            ]);
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    TextInputType keyboardType = TextInputType.text,
    bool obscureText = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
        keyboardType: keyboardType,
        obscureText: obscureText,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Veuillez entrer $label';
          }
          return null;
        },
      ),
    );
  }
}
