import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  final ScrollController _scrollController = ScrollController();

  void _scrollToSection(double position) {
    _scrollController.animateTo(
      position,
      duration: Duration(seconds: 1),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset(
                'assets/images/1.png',
                height: 80, // Adjust the size of the logo here
                fit: BoxFit.contain,
              ),
            ),
          ],
        ),
        actions: [
          _buildNavItem('ACCUEIL', () => _scrollToSection(0)),
          _buildNavItem('NOS SERVICES', () => _scrollToSection(600)),
          _buildNavItem('CONTACT', () => _scrollToSection(1200)),
          _buildNavItem('INFOS FINANCIÈRES', () => _scrollToSection(1800)),
          _buildNavItem('CRÉER COMPTE', () {
            Navigator.pushNamed(context, '/register');
          }),
          _buildNavItem('SIGN IN', () {
            Navigator.pushNamed(context, '/auth');
          }),
        ],
      ),
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/2.png'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'AL AKHDAR BANK EST PRÊT À VOUS PROTÉGER\n'
                        'Assurance TAKAFUL\n'
                        'La protection de la famille par une couverture de financement MOURABAHA',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      backgroundColor: Colors.black54,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
            Container(
              color: Colors.white,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'NOS SERVICES',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 20),
                      _buildServiceGrid(),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height * 0.8, // Smaller height for the contact section
              color: Colors.grey[200],
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'CONTACTEZ NOUS',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 20),
                      Container(
                        padding: const EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          children: [
                            Text(
                              'AL AKHDAR BANK met à votre dispositon un ensemble de moyens pour rentrer en relation avec ses conseillers',
                              style: TextStyle(fontSize: 16),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 20),
                            _buildContactInfo(
                              icon: Icons.location_on,
                              text: 'Angle Avenue Alger et Rue Oran, HASSAN 10 000',
                            ),
                            _buildContactInfo(
                              icon: Icons.email,
                              text: 'contact@alakhdarbank.ma',
                            ),
                            _buildContactInfo(
                              icon: Icons.phone,
                              text: '(+212) 0530-142222',
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height, // Adjusted height for the financial information section
              color: Colors.white,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'INFOS FINANCIÈRES',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            flex: 2,
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Text(
                                'AL AKHDAR BANK poursuit la mise en place de son plan stratégique, s’inscrivant dans une dynamique de croissance soutenue et visant à conforter son positionnement dans le paysage des banques participatives. En terme d’activité et conformément à son Business Plan, la banque améliore progressivement ses performances commerciales. Ainsi, l’encours des financements accordés s’établit au 30 juin 2023 à 3,2 Milliards de dirhams. Les dépôts ont également enregistré une forte croissance au cours de 1er Semestre 2023 pour atteindre près de 1,5 Milliards de dirhams.\n\n'
                                    '2023-Juin\n'
                                    '2022-Juin\n'
                                    '2021-Décembre\n'
                                    '2021-Juin\n'
                                    '2020-Décembre\n'
                                    '2020-Juin\n'
                                    '2019-Décembre\n'
                                    '2019-Juin\n'
                                    '2018-Décembre\n'
                                    '2018-Juin\n'
                                    '2017-Décembre',
                                style: TextStyle(fontSize: 16),
                                textAlign: TextAlign.left,
                              ),
                            ),
                          ),
                          SizedBox(width: 16),
                          Expanded(
                            flex: 1,
                            child: Image.asset(
                              'assets/images/3.png',
                              fit: BoxFit.cover,
                              width: MediaQuery.of(context).size.width * 0.4,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(String title, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: GestureDetector(
        onTap: onTap,
        child: Text(
          title,
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildServiceGrid() {
    return Wrap(
      spacing: 16,
      runSpacing: 16,
      alignment: WrapAlignment.center,
      children: [
        _buildServiceItem(
          'UN COMPTE AAB',
          'Pour tous vos besoins, un moyen de paiement AAB est mis à votre disposition.',
        ),
        _buildServiceItem(
          'UNE CARTE AAB',
          'La carte qui vous simplifie la vie au Maroc et à l\'étranger. Paiements et retraits, profitez d\'une carte d\'excellence.',
        ),
        _buildServiceItem(
          'BANQUE EN LIGNE',
          'Gérer votre compte où que vous soyez et garder un œil sur votre compte bancaire 24h/24 et 7J/7 avec nos services AKHDAR NET et AKHDAR MOBILE.',
        ),
        _buildServiceItem(
          'E-AGENCE',
          'Une expérience inédite avec un espace digital dédié au sein de nos agences, vous permettant d\'effectuer l\'ensemble de vos opérations bancaires.',
        ),
        _buildServiceItem(
          'MOURABAHA IMMO',
          'Afin de vous accompagner dans vos projets d\'acquisition de bien immobilier, AL AKHDAR BANK vous propose la solution MOURABAHA IMMO et vous aide à devenir propriétaire.',
        ),
        _buildServiceItem(
          'MOURABAHA AUTO',
          'AL AKHDAR BANK met à votre disposition, le financement de votre nouvelle voiture basé sur la technique de la MOURABAHA conformément aux principes de la Finance Participative.',
        ),
        _buildServiceItem(
          'MOURABAHA EQUIPEMENT',
          'Une solution de financement adaptée pour mettre à niveau vos équipements agricoles (matériel d\'arrosage, d\'irrigation, panneaux solaires, ...).',
        ),
        _buildServiceItem(
          'Assurance Takaful',
          'Grâce à son expertise dans les montages financiers compatibles avec les avis du Conseil Supérieur des Oulémas, AL AKHDAR BANK vous offre la possibilité de faire face aux aléas de la vie, avec une offre de prévoyance complète et adaptable à vos contraintes.',
        ),
      ],
    );
  }

  Widget _buildServiceItem(String title, String description) {
    return Container(
      width: 300,
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 10),
          Text(
            description,
            style: TextStyle(fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildContactInfo({required IconData icon, required String text}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 24),
          SizedBox(width: 10),
          Text(
            text,
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}
