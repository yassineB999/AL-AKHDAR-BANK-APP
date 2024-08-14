import 'package:flutter/material.dart';
import 'package:frontend/services/AdminService.dart';
import '../models/Offre.dart';
import 'package:intl/intl.dart'; // Import the intl package

class ManageOffre extends StatefulWidget {
  @override
  _ManageOffreState createState() => _ManageOffreState();
}

class _ManageOffreState extends State<ManageOffre> {
  late Future<List<Offre>> _offres;
  List<Offre> _filteredOffres = [];
  TextEditingController _searchController = TextEditingController();
  final DateFormat _dateFormat = DateFormat('yyyy-MM-dd');

  @override
  void initState() {
    super.initState();
    _fetchOffres();
    _searchController.addListener(_filterOffres);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _fetchOffres() {
    setState(() {
      _offres = AdminService.getOffres();
      _offres.then((offres) {
        _filteredOffres = offres;
      });
    });
  }

  void _filterOffres() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _offres.then((offres) {
        _filteredOffres = offres.where((offre) {
          return offre.libelle.toLowerCase().contains(query);
        }).toList();
      });
    });
  }

  void _showOffreDialog({Offre? offre}) {
    final _formKey = GlobalKey<FormState>();
    final _dateDebutController = TextEditingController(text: offre?.dateDebut ?? '');
    final _libelleController = TextEditingController(text: offre?.libelle ?? '');
    final _descriptionController = TextEditingController(text: offre?.description ?? '');
    final _dateFinController = TextEditingController(text: offre?.dateFin ?? '');

    Future<void> _selectDate(BuildContext context, TextEditingController controller) async {
      final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2000),
        lastDate: DateTime(2101),
      );
      if (picked != null && picked != DateTime.now()) {
        setState(() {
          controller.text = _dateFormat.format(picked);
        });
      }
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(offre == null ? 'Add Offer' : 'Update Offer'),
          content: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  GestureDetector(
                    onTap: () => _selectDate(context, _dateDebutController),
                    child: AbsorbPointer(
                      child: _buildTextField(
                        controller: _dateDebutController,
                        label: 'Date Debut',
                      ),
                    ),
                  ),
                  _buildTextField(controller: _libelleController, label: 'Libelle'),
                  _buildTextField(controller: _descriptionController, label: 'Description'),
                  GestureDetector(
                    onTap: () => _selectDate(context, _dateFinController),
                    child: AbsorbPointer(
                      child: _buildTextField(
                        controller: _dateFinController,
                        label: 'Date Fin',
                      ),
                    ),
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
                  final newOffre = Offre(
                    idOffre: offre?.idOffre ?? 0,
                    dateDebut: _dateDebutController.text,
                    libelle: _libelleController.text,
                    description: _descriptionController.text,
                    dateFin: _dateFinController.text,
                  );

                  if (offre == null) {
                    await AdminService.addOffre(newOffre);
                  } else {
                    await AdminService.updateOffre(offre.idOffre, newOffre);
                  }

                  Navigator.of(context).pop();
                  _fetchOffres();
                }
              },
              child: Text(offre == null ? 'Add' : 'Update'),
            ),
          ],
        );
      },
    );
  }

  void _deleteOffre(int id) async {
    await AdminService.deleteOffre(id);
    _fetchOffres();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Manage Offers'),
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
                      labelText: 'Search by Libelle',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () => _showOffreDialog(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                  ),
                  child: Text('Add Offer'),
                ),
              ],
            ),
            SizedBox(height: 20),
            Expanded(
              child: FutureBuilder<List<Offre>>(
                future: _offres,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text('No offers available.'));
                  } else {
                    return _buildOffreTable(_filteredOffres);
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOffreTable(List<Offre> offres) {
    return Center(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columns: const [
            DataColumn(label: Text('ID')),
            DataColumn(label: Text('Date Debut')),
            DataColumn(label: Text('Libelle')),
            DataColumn(label: Text('Description')),
            DataColumn(label: Text('Date Fin')),
            DataColumn(label: Text('Actions')),
          ],
          rows: offres.map((offre) {
            return DataRow(cells: [
              DataCell(Text(offre.idOffre.toString())),
              DataCell(Text(offre.dateDebut)),
              DataCell(Text(offre.libelle)),
              DataCell(Text(offre.description)),
              DataCell(Text(offre.dateFin)),
              DataCell(Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () => _showOffreDialog(offre: offre),
                  ),
                  IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () => _deleteOffre(offre.idOffre),
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
