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
          title: Text(client == null ? 'Add Client' : 'Update Client'),
          content: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildTextField(controller: _cinController, label: 'CIN'),
                  _buildTextField(controller: _nomController, label: 'Nom'),
                  _buildTextField(controller: _prenomController, label: 'Prenom'),
                  _buildTextField(controller: _emailController, label: 'Email', keyboardType: TextInputType.emailAddress),
                  _buildTextField(controller: _telephoneController, label: 'Téléphone'),
                  _buildTextField(controller: _adresseController, label: 'Adresse'),
                  _buildTextField(controller: _ageController, label: 'Age'),
                  if (client == null)
                    _buildTextField(
                      controller: _passwordController,
                      label: 'Password',
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
              child: Text('Cancel'),
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
              child: Text(client == null ? 'Add' : 'Update'),
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
        title: Text('Manage Clients'),
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
                      labelText: 'Search by Email',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () => _showClientDialog(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                  ),
                  child: Text('Add Client'),
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
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text('No clients available.'));
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
          columns: const [
            DataColumn(label: Text('ID')),
            DataColumn(label: Text('CIN')),
            DataColumn(label: Text('Nom')),
            DataColumn(label: Text('Prenom')),
            DataColumn(label: Text('Email')),
            DataColumn(label: Text('Téléphone')),
            DataColumn(label: Text('Adresse')),
            DataColumn(label: Text('Age')),
            DataColumn(label: Text('Actions')),
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
                    icon: Icon(Icons.edit),
                    onPressed: () => _showClientDialog(client: client),
                  ),
                  IconButton(
                    icon: Icon(Icons.delete),
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
            return 'Please enter $label';
          }
          return null;
        },
      ),
    );
  }
}
