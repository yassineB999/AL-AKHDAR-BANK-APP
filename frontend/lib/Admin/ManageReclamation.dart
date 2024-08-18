import 'package:flutter/material.dart';
import 'package:frontend/models/Reclamation.dart';
import 'package:frontend/services/AdminService.dart';

class ManageReclamation extends StatefulWidget {
  @override
  _ManageReclamationState createState() => _ManageReclamationState();
}

class _ManageReclamationState extends State<ManageReclamation> {
  late Future<List<Reclamation>> _reclamations;
  List<Reclamation> _filteredReclamations = [];

  @override
  void initState() {
    super.initState();
    _fetchReclamations();
  }

  void _fetchReclamations() {
    setState(() {
      _reclamations = AdminService.getReclamations();
      _reclamations.then((reclamations) {
        _filteredReclamations = reclamations;
      });
    });
  }

  void _showReclamationDetails(Reclamation reclamation) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Détails de la Réclamation'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildDetailRow('ID', reclamation.idReclamation.toString()),
                _buildDetailRow('Date', reclamation.date.split('T')[0]), // Format date if necessary
                _buildDetailRow('Description', reclamation.description),
                _buildDetailRow('Type', reclamation.type),
                _buildDetailRow('Statut', reclamation.status),
                SizedBox(height: 10),
                Text('Détails de l\'Utilisateur', style: TextStyle(fontWeight: FontWeight.bold)),
                _buildDetailRow('ID Utilisateur', reclamation.utilisateur.idUtilisateur.toString()),
                _buildDetailRow('Nom', '${reclamation.utilisateur.nom} ${reclamation.utilisateur.prenom}'),
                _buildDetailRow('Email', reclamation.utilisateur.email),
                _buildDetailRow('Numéro de Téléphone', reclamation.utilisateur.numerotelephone),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Fermer'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '$label:',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  void _updateReclamationStatus(Reclamation reclamation, String newStatus) async {
    try {
      await AdminService.updateReclamationStatus(reclamation.idReclamation, newStatus);

      setState(() {
        // Create a new Reclamation object with the updated status
        Reclamation updatedReclamation = Reclamation(
          idReclamation: reclamation.idReclamation,
          date: reclamation.date,
          description: reclamation.description,
          type: reclamation.type,
          status: newStatus,
          utilisateur: reclamation.utilisateur,
        );

        // Replace the old reclamation in the list with the updated one
        int index = _filteredReclamations.indexOf(reclamation);
        _filteredReclamations[index] = updatedReclamation;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Statut mis à jour avec succès')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Échec de la mise à jour du statut: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gérer les Réclamations'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: FutureBuilder<List<Reclamation>>(
                future: _reclamations,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Erreur: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text('Aucune réclamation disponible.'));
                  } else {
                    return _buildReclamationTable(_filteredReclamations);
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReclamationTable(List<Reclamation> reclamations) {
    return Center(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columns: const [
            DataColumn(label: Text('ID')),
            DataColumn(label: Text('Date')),
            DataColumn(label: Text('Description')),
            DataColumn(label: Text('Type')),
            DataColumn(label: Text('Statut')),
            DataColumn(label: Text('Actions')),
          ],
          rows: reclamations.map((reclamation) {
            return DataRow(cells: [
              DataCell(Text(reclamation.idReclamation.toString())),
              DataCell(Text(reclamation.date.split('T')[0])),
              DataCell(Text(reclamation.description)),
              DataCell(Text(reclamation.type)),
              DataCell(
                DropdownButton<String>(
                  value: ['EN_COURS_DE_TRAITEMENT', 'TRAITE'].contains(reclamation.status)
                      ? reclamation.status
                      : null,
                  items: [
                    DropdownMenuItem(
                      value: 'EN_COURS_DE_TRAITEMENT',
                      child: Text('EN_COURS_DE_TRAITEMENT'),
                    ),
                    DropdownMenuItem(
                      value: 'TRAITE',
                      child: Text('TRAITE'),
                    ),
                  ],
                  onChanged: (newStatus) {
                    if (newStatus != null) {
                      _updateReclamationStatus(reclamation, newStatus);
                    }
                  },
                  hint: Text('Sélectionner un statut'),
                ),
              ),
              DataCell(ElevatedButton(
                onPressed: () => _showReclamationDetails(reclamation),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green, // Button color set to green
                ),
                child: Text('Voir les détails'),
              )),
            ]);
          }).toList(),
        ),
      ),
    );
  }
}
