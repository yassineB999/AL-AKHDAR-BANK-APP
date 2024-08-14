import 'dart:io';
import 'package:flutter/material.dart';
import 'package:frontend/Admin/ManageDemandes.dart';
import 'package:frontend/Client/ListReclamation.dart';
import 'package:frontend/Client/Offre.dart';
import 'package:frontend/Client/Reclamation.dart';
import 'package:provider/provider.dart';
import 'services/api_service.dart';
import 'services/auth_provider.dart';
import 'App/auth_page.dart';
import 'Admin/HomeAdmin.dart';
import 'Client/HomeClient.dart';
import 'App/RegisterPage.dart';
import 'Admin/ManageClient.dart';
import 'Admin/ManageOffer.dart';
import 'services/ProfileWrapper.dart';
import 'App/HomePage.dart'; // Import HomePage
import 'Admin/ManageReclamation.dart'; // Import ManageReclamation

void main() {
  HttpOverrides.global = MyHttpOverrides(); // Set up the proxy
  runApp(MyApp());
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..findProxy = (uri) {
        return "PROXY localhost:8888"; // Use a consistent proxy address
      }
      ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthProvider(
            apiService: ApiService(baseUrl: 'http://localhost:8080'),
          ),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => HomePage(), // Set HomePage as initial route
          '/auth': (context) => AuthPage(),
          '/register': (context) => RegisterPage(),
          '/homeAdmin': (context) => HomeAdmin(),
          '/homeClient': (context) => HomeClient(),
          '/manageclients': (context) => ManageClient(),
          '/manageoffre': (context) => ManageOffre(),
          '/managereclamation': (context) => ManageReclamation(), // Add route for ManageReclamation
          '/managedemande': (context) => ManageDemande(),
          '/reclamation': (context) => ReclamationPage(),
          '/listreclamation': (context) => ListReclamationPage(),
          '/offre': (context) => ConcentricAnimationOnboarding(),
          '/profile': (context) => ProfileWrapper(),
        },
      ),
    );
  }
}
