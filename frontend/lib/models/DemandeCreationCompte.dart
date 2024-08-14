import 'Utilisateur.dart';

class DemandeCreationCompte {
  final int idDemandeCreationCompte;
  final String date;
  final Utilisateur utilisateur;

  DemandeCreationCompte({
    required this.idDemandeCreationCompte,
    required this.date,
    required this.utilisateur,
  });

  factory DemandeCreationCompte.fromJson(Map<String, dynamic> json) {
    return DemandeCreationCompte(
      idDemandeCreationCompte: json['idDemandeCreationCompte'],
      date: json['date'],
      utilisateur: Utilisateur.fromJson(json['utilisateur']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idDemandeCreationCompte': idDemandeCreationCompte,
      'date': date,
      'utilisateur': utilisateur.toJson(),
    };
  }
}
