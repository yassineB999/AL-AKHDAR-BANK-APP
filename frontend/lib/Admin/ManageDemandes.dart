import 'package:flutter/material.dart';
import 'package:frontend/models/DemandeCreationCompte.dart';
import 'package:frontend/services/AdminService.dart';

class ManageDemande extends StatefulWidget {
  @override
  _ManageDemandeState createState() => _ManageDemandeState();
}

class _ManageDemandeState extends State<ManageDemande> {
  late Future<List<DemandeCreationCompte>> _demandes;
  List<DemandeCreationCompte> _filteredDemandes = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchDemandes();
  }

  void _fetchDemandes() {
    setState(() {
      _isLoading = true;
      _demandes = AdminService.getDemandes();
      _demandes.then((demandes) {
        setState(() {
          _filteredDemandes = demandes;
          _isLoading = false;
        });
      }).catchError((error) {
        setState(() {
          _isLoading = false;
        });
        _showErrorDialog(error.toString());
      });
    });
  }

  void _showDemandeDetails(DemandeCreationCompte demande) {
    showDialog(
      context: context,
      builder: (context) {
        return DemandeDetailsDialog(demande: demande);
      },
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Erreur'),
          content: Text(message),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gérer les Demandes'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 16.0),
            Expanded(
              child: _isLoading
                  ? Center(child: CircularProgressIndicator())
                  : FutureBuilder<List<DemandeCreationCompte>>(
                future: _demandes,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Erreur: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text('Aucune demande disponible.'));
                  } else {
                    return Center(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: DataTable(
                          columns: const [
                            DataColumn(label: Text('ID')),
                            DataColumn(label: Text('Date')),
                            DataColumn(label: Text('Utilisateur')),
                            DataColumn(label: Text('Actions')),
                          ],
                          rows: _filteredDemandes.map((demande) {
                            return DataRow(cells: [
                              DataCell(Text(demande.idDemandeCreationCompte.toString())),
                              DataCell(Text(demande.date.split('T')[0])),
                              DataCell(Text('${demande.utilisateur.nom} ${demande.utilisateur.prenom}')),
                              DataCell(ElevatedButton(
                                onPressed: () => _showDemandeDetails(demande),
                                child: Text('Voir les Détails'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green, // Couleur du bouton définie en vert
                                  foregroundColor: Colors.white, // Couleur du texte
                                  textStyle: TextStyle(fontWeight: FontWeight.bold), // Style du texte
                                ),
                              )),
                            ]);
                          }).toList(),
                        ),
                      ),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DemandeDetailsDialog extends StatelessWidget {
  final DemandeCreationCompte demande;

  DemandeDetailsDialog({required this.demande});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Détails de la Demande'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildDetailRow('ID', demande.idDemandeCreationCompte.toString()),
            _buildDetailRow('Date', demande.date),
            SizedBox(height: 10),
            Text('Détails de l\'Utilisateur', style: TextStyle(fontWeight: FontWeight.bold)),
            _buildDetailRow('ID Utilisateur', demande.utilisateur.idUtilisateur.toString()),
            _buildDetailRow('Nom', '${demande.utilisateur.nom} ${demande.utilisateur.prenom}'),
            _buildDetailRow('Email', demande.utilisateur.email),
            _buildDetailRow('Numéro de Téléphone', demande.utilisateur.numerotelephone),
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
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('$label:'),
          Text(value),
        ],
      ),
    );
  }
}
