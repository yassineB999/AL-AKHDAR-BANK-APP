import 'package:concentric_transition/concentric_transition.dart';
import 'package:flutter/material.dart';
import 'HomeClient.dart';  // Assurez-vous d'importer la page HomeClient
import '../services/ClientService.dart';
import '../models/Offre.dart';

class ConcentricAnimationOnboarding extends StatefulWidget {
  const ConcentricAnimationOnboarding({Key? key}) : super(key: key);

  @override
  _ConcentricAnimationOnboardingState createState() => _ConcentricAnimationOnboardingState();
}

class _ConcentricAnimationOnboardingState extends State<ConcentricAnimationOnboarding> {
  List<PageData> pages = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPages();
  }

  // Chargement des données de l'API
  Future<void> _loadPages() async {
    try {
      final List<Offre> offres = await ClientService.getAllOffres();
      final List<PageData> pageDataList = offres.map((offre) => PageData(
        icon: Icons.local_offer_outlined,
        title: offre.libelle,
        bgColor: offre.idOffre % 2 == 0 ? Colors.green : Colors.lightGreen,
        textColor: Colors.white,
        idOffre: offre.idOffre,
      )).toList();

      setState(() {
        pages = pageDataList;
        _isLoading = false;
      });
    } catch (e) {
      print('Failed to load pages: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green, // Couleur de fond verte pour l'AppBar
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HomeClient()),
            );
          },
        ),
        title: Text('Offres'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator()) // Afficher un indicateur de chargement pendant le chargement des pages
          : pages.length < 2
          ? Center(child: Text('Not enough data to display the onboarding')) // Afficher un message si moins de 2 pages
          : ConcentricPageView(
        colors: pages.map((p) => p.bgColor).toList(),
        radius: screenWidth * 0.1,
        nextButtonBuilder: (context) => Padding(
          padding: const EdgeInsets.only(left: 3), // centre visuel
          child: Icon(
            Icons.navigate_next,
            size: screenWidth * 0.08,
          ),
        ),
        scaleFactor: 2,
        itemBuilder: (index) {
          final page = pages[index % pages.length];
          return SafeArea(
            child: _Page(page: page),
          );
        },
      ),
    );
  }
}

class PageData {
  final String? title;
  final IconData? icon;
  final Color bgColor;
  final Color textColor;
  final int? idOffre; // Ajouter l'id de l'offre

  const PageData({
    this.title,
    this.icon,
    this.bgColor = Colors.white,
    this.textColor = Colors.black,
    this.idOffre,
  });
}

class _Page extends StatelessWidget {
  final PageData page;

  const _Page({Key? key, required this.page}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(16.0),
          margin: const EdgeInsets.all(16.0),
          decoration:
          BoxDecoration(shape: BoxShape.circle, color: page.textColor),
          child: Icon(
            page.icon,
            size: screenHeight * 0.1,
            color: page.bgColor,
          ),
        ),
        Text(
          page.title ?? "",
          style: TextStyle(
              color: page.textColor,
              fontSize: screenHeight * 0.035,
              fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 16.0),
        ElevatedButton(
          onPressed: () async {
            // Appel à l'API pour obtenir les détails de l'offre
            try {
              final Offre details = await ClientService.detailsOffre(page.idOffre!);
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('Details of ${page.title}'),
                  content: Text(
                      'Name: ${details.libelle}\nDescription: ${details.description}\nStart Date: ${details.dateDebut}\nEnd Date: ${details.dateFin}'
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text('Close'),
                    ),
                  ],
                ),
              );
            } catch (e) {
              print('Failed to load offer details: $e');
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Failed to load offer details: $e')),
              );
            }
          },
          child: Text('View Details'),
        ),
      ],
    );
  }
}
