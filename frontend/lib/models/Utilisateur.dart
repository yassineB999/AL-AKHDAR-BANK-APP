// lib/models/Utilisateur.dart
class Utilisateur {
  final int idUtilisateur;
  final String cin;
  final String nom;
  final String prenom;
  final String numerotelephone;
  final String email;
  final String adresse;
  final String age;
  final String? password; // Include password field

  Utilisateur({
    required this.idUtilisateur,
    required this.cin,
    required this.nom,
    required this.prenom,
    required this.numerotelephone,
    required this.email,
    required this.adresse,
    required this.age,
    this.password, // Make password optional for cases like update where it might not be needed
  });

  factory Utilisateur.fromJson(Map<String, dynamic> json) {
    return Utilisateur(
      idUtilisateur: json['idUtilisateur'],
      cin: json['cin'],
      nom: json['nom'],
      prenom: json['prenom'],
      numerotelephone: json['numerotelephone'],
      email: json['email'],
      adresse: json['adresse'],
      age: json['age'],
      password: json['password'], // Add password
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idUtilisateur': idUtilisateur,
      'cin': cin,
      'nom': nom,
      'prenom': prenom,
      'numerotelephone': numerotelephone,
      'email': email,
      'adresse': adresse,
      'age': age,
      'password': password, // Include password in JSON representation
    };
  }
}
