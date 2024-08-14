import 'package:flutter/material.dart';
import 'package:frontend/models/Reclamation.dart';
import 'package:frontend/services/ClientService.dart';

class ListReclamationPage extends StatefulWidget {
  @override
  _ListReclamationPageState createState() => _ListReclamationPageState();
}

class _ListReclamationPageState extends State<ListReclamationPage> {
  late Future<List<Reclamation>> _reclamationsFuture;

  @override
  void initState() {
    super.initState();
    _reclamationsFuture = ClientService.listReclamation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text('List of Reclamations'),
      ),
      body: Center(
        child: FutureBuilder<List<Reclamation>>(
          future: _reclamationsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Text('No reclamations found');
            } else {
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    columns: [
                      DataColumn(label: Text('Date')),
                      DataColumn(label: Text('Description')),
                      DataColumn(label: Text('Type')),
                      DataColumn(label: Text('Status')),
                      DataColumn(label: Text('User')),
                    ],
                    rows: snapshot.data!
                        .map((reclamation) => DataRow(cells: [
                      DataCell(Text(reclamation.date.split('T')[0])),
                      DataCell(Text(reclamation.description)),
                      DataCell(Text(reclamation.type)),
                      DataCell(Text(reclamation.status)),
                      DataCell(Text(reclamation.utilisateur.nom + " " + reclamation.utilisateur.prenom)),
                    ]))
                        .toList(),
                  ),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
