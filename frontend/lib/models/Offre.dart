class Offre {
  final int idOffre;
  final String dateDebut;
  final String libelle;
  final String description;
  final String dateFin;

  Offre({
    required this.idOffre,
    required this.dateDebut,
    required this.libelle,
    required this.description,
    required this.dateFin,
  });

  factory Offre.fromJson(Map<String, dynamic> json) {
    return Offre(
      idOffre: json['idOffre'],
      dateDebut: json['dateDebut'],
      libelle: json['libelle'],
      description: json['description'],
      dateFin: json['dateFin'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idOffre': idOffre,
      'dateDebut': dateDebut,
      'libelle': libelle,
      'description': description,
      'dateFin': dateFin,
    };
  }
}
