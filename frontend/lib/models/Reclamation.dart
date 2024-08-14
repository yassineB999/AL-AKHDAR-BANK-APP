import 'Utilisateur.dart';

class Reclamation {
  final int idReclamation;
  final String date;
  final String description;
  final String type;
  final String status;
  final Utilisateur utilisateur;

  Reclamation({
    required this.idReclamation,
    required this.date,
    required this.description,
    required this.type,
    required this.status,
    required this.utilisateur,
  });

  factory Reclamation.fromJson(Map<String, dynamic> json) {
    return Reclamation(
      idReclamation: json['idReclamation'],
      date: json['date'],
      description: json['description'],
      type: json['type'],
      status: json['status'],
      utilisateur: Utilisateur.fromJson(json['utilisateur']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idReclamation': idReclamation,
      'date': date,
      'description': description,
      'type': type,
      'status': status,
      'utilisateur': utilisateur.toJson(),
    };
  }
}
