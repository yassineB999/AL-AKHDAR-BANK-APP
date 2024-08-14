import 'package:frontend/models/DemandeCreationCompte.dart';
import 'package:frontend/models/Offre.dart';
import 'package:frontend/models/Reclamation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/Utilisateur.dart';

class AdminService {
  static const String baseUrl = 'http://localhost:8080/App/api/admin';

  static Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  // Fetch the profile of the authenticated admin user
  static Future<Utilisateur?> getProfile() async {
    final token = await _getToken();
    if (token == null) {
      throw Exception('No token found');
    }

    final response = await http.get(
      Uri.parse('$baseUrl/profile'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return Utilisateur.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load profile. Status code: ${response.statusCode}');
    }
  }

  // Update the profile of the authenticated admin user
  static Future<Utilisateur?> updateProfile(Utilisateur utilisateur) async {
    final token = await _getToken();
    if (token == null) {
      throw Exception('No token found');
    }

    final response = await http.put(
      Uri.parse('$baseUrl/updateProfile'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(utilisateur.toJson()),
    );

    if (response.statusCode == 200) {
      return Utilisateur.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to update profile. Status code: ${response.statusCode}');
    }
  }
  static Future<List<Reclamation>> getReclamations() async {
    final token = await _getToken();
    if (token == null) {
      throw Exception('No token found');
    }

    final response = await http.get(
      Uri.parse('$baseUrl/ListReclamation'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      Iterable list = json.decode(response.body);
      return list.map((model) => Reclamation.fromJson(model)).toList();
    } else {
      throw Exception('Failed to load reclamations. Status code: ${response.statusCode}');
    }
  }

  static Future<int> getTotalReclamations() async {
    final token = await _getToken();
    if (token == null) {
      throw Exception('No token found');
    }

    final response = await http.post(
      Uri.parse('$baseUrl/TotalReclamation'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return int.parse(response.body);
    } else if (response.statusCode == 403) {
      throw Exception('Access denied');
    } else {
      throw Exception('Failed to get total reclamations. Status code: ${response.statusCode}');
    }
  }
  static Future<Reclamation> getReclamationDetails(int idReclamation) async {
    final token = await _getToken();
    if (token == null) {
      throw Exception('No token found');
    }

    final response = await http.get(
      Uri.parse('$baseUrl/DetailsReclamation/$idReclamation'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return Reclamation.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load reclamation details. Status code: ${response.statusCode}');
    }
  }
  static Future<List<Offre>> getOffres() async {
    final token = await _getToken();
    if (token == null) {
      throw Exception('No token found');
    }

    final response = await http.get(
      Uri.parse('$baseUrl/ListOffre'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      Iterable list = json.decode(response.body);
      return list.map((model) => Offre.fromJson(model)).toList();
    } else {
      throw Exception('Failed to load offers. Status code: ${response.statusCode}');
    }
  }

  static Future<int> getTotalOffres() async {
    final token = await _getToken();
    if (token == null) {
      throw Exception('No token found');
    }

    final response = await http.post(
      Uri.parse('$baseUrl/TotalOffre'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return int.parse(response.body);
    } else if (response.statusCode == 403) {
      print('Access denied: Check if the user has the required role and permissions');
      throw Exception('Access denied');
    } else {
      throw Exception('Failed to get total offers. Status code: ${response.statusCode}');
    }
  }

  static Future<bool> addOffre(Offre offre) async {
    final token = await _getToken();
    if (token == null) {
      throw Exception('No token found');
    }

    final response = await http.post(
      Uri.parse('$baseUrl/addOffre'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(offre.toJson()),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      print('Failed to add offer: ${response.body}');
      throw Exception('Failed to add offer. Status code: ${response.statusCode}');
    }
  }

  static Future<bool> updateOffre(int id, Offre offre) async {
    final token = await _getToken();
    if (token == null) {
      throw Exception('No token found');
    }

    final response = await http.put(
      Uri.parse('$baseUrl/updateOffre/$id'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(offre.toJson()),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception('Failed to update offer. Status code: ${response.statusCode}');
    }
  }

  static Future<bool> deleteOffre(int id) async {
    final token = await _getToken();
    if (token == null) {
      throw Exception('No token found');
    }

    final response = await http.delete(
      Uri.parse('$baseUrl/deleteOffre/$id'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception('Failed to delete offer. Status code: ${response.statusCode}');
    }
  }
  static Future<List<DemandeCreationCompte>> getDemandes() async {
    final token = await _getToken();
    if (token == null) {
      throw Exception('No token found');
    }

    final response = await http.get(
      Uri.parse('$baseUrl/ListDemande'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      Iterable list = json.decode(response.body);
      return list.map((model) => DemandeCreationCompte.fromJson(model)).toList();
    } else {
      throw Exception('Failed to load demandes. Status code: ${response.statusCode}');
    }
  }

  static Future<int> getTotalDemandes() async {
    final token = await _getToken();
    if (token == null) {
      throw Exception('No token found');
    }

    final response = await http.post(
      Uri.parse('$baseUrl/TotalDemande'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return int.parse(response.body);
    } else if (response.statusCode == 403) {
      throw Exception('Access denied');
    } else {
      throw Exception('Failed to get total demandes. Status code: ${response.statusCode}');
    }
  }

  static Future<DemandeCreationCompte> getDemandeDetails(int idDemande) async {
    final token = await _getToken();
    if (token == null) {
      throw Exception('No token found');
    }

    final response = await http.get(
      Uri.parse('$baseUrl/DetailsDemandes/$idDemande'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return DemandeCreationCompte.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load demande details. Status code: ${response.statusCode}');
    }
  }

  static Future<List<Utilisateur>> getClients() async {
    final token = await _getToken();
    if (token == null) {
      throw Exception('No token found');
    }

    final response = await http.get(
      Uri.parse('$baseUrl/ListClient'),
      headers: {
        'Authorization': 'Bearer $token', // Ensure token is sent correctly
      },
    );

    if (response.statusCode == 200) {
      Iterable list = json.decode(response.body);
      return list.map((model) => Utilisateur.fromJson(model)).toList();
    } else {
      throw Exception('Failed to load clients. Status code: ${response.statusCode}');
    }
  }

  static Future<int> getTotalClients() async {
    final token = await _getToken();
    if (token == null) {
      throw Exception('No token found');
    }

    print('Token used: $token'); // Debugging line

    final response = await http.post(
      Uri.parse('$baseUrl/TotalClient'), // Ensure the URL is correct
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json', // Include content type if necessary
      },
    );

    print('Response status code: ${response.statusCode}'); // Debugging line
    print('Response body: ${response.body}'); // Debugging line

    if (response.statusCode == 200) {
      return int.parse(response.body); // Ensure this matches the format of the response body
    } else if (response.statusCode == 403) {
      print('Access denied: Check if the user has the required role and permissions');
      throw Exception('Access denied');
    } else {
      throw Exception('Failed to get total clients. Status code: ${response.statusCode}');
    }
  }



  static Future<bool> addClient(Utilisateur client) async {
    final token = await _getToken();
    if (token == null) {
      throw Exception('No token found');
    }

    // Log the client details for debugging
    print('Client data: ${client.toJson()}');

    final response = await http.post(
      Uri.parse('$baseUrl/addClient'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(client.toJson()),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      print('Failed to add client: ${response.body}');
      throw Exception('Failed to add client. Status code: ${response.statusCode}');
    }
  }


  static Future<bool> updateClient(int id, Utilisateur client) async {
    final token = await _getToken();
    if (token == null) {
      throw Exception('No token found');
    }

    final response = await http.put(
      Uri.parse('$baseUrl/updateClient/$id'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(client.toJson()),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception('Failed to update client. Status code: ${response.statusCode}');
    }
  }

  static Future<bool> deleteClient(int id) async {
    final token = await _getToken();
    if (token == null) {
      throw Exception('No token found');
    }

    final response = await http.delete(
      Uri.parse('$baseUrl/deleteClient/$id'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception('Failed to delete client. Status code: ${response.statusCode}');
    }
  }

  static Future<bool> updateReclamationStatus(int idReclamation, String newStatus) async {
    final token = await _getToken();
    if (token == null) {
      throw Exception('No token found');
    }

    final response = await http.put(
      Uri.parse('$baseUrl/updatestatus/$idReclamation'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'newStatus': newStatus,
      }),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      print('Failed to update reclamation status: ${response.body}');
      throw Exception('Failed to update reclamation status. Status code: ${response.statusCode}');
    }
  }
}

extension on Utilisateur {
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
      // Include other fields as necessary
    };
  }
}
