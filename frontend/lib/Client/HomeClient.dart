import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_provider.dart';
import '../services/ClientService.dart';
import '../models/Utilisateur.dart';

class HomeClient extends StatefulWidget {
  const HomeClient({super.key});

  @override
  State<HomeClient> createState() => _HomeClientState();
}

class _HomeClientState extends State<HomeClient> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final ScrollController _scrollController = ScrollController();
  bool _isLoading = false;
  Utilisateur? _user;
  bool _hasSentRequest = false;

  void _scrollToSection(double position) {
    _scrollController.animateTo(
      position,
      duration: Duration(seconds: 1),
      curve: Curves.easeInOut,
    );
  }

  void _openPopup() async {
    setState(() {
      _isLoading = true;
    });

    try {
      Utilisateur? user = await ClientService.getProfile();
      setState(() {
        _user = user;
      });
      _showPopup();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(_scaffoldKey.currentContext!).showSnackBar(
          SnackBar(content: Text('Échec du chargement du profil : $e')),
        );
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showPopup() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Informations du profil'),
          content: _user != null
              ? Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Nom : ${_user!.nom} ${_user!.prenom}'),
              Text('Email : ${_user!.email}'),
              Text('Téléphone : ${_user!.numerotelephone}'),
              Text('Adresse : ${_user!.adresse}'),
              Text('CIN : ${_user!.cin}'),
              if (_hasSentRequest)
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: Text(
                    'Votre demande a déjà été envoyée. Nous vous contacterons bientôt.',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  ),
                ),
              if (!_hasSentRequest)
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: Text(
                    'Vous avez une dernière chance de confirmer avant d\'envoyer la demande.',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  ),
                ),
            ],
          )
              : Text('Échec du chargement des informations du profil.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pushNamed(context, '/profile');
              },
              child: Text('Non'),
            ),
            if (!_hasSentRequest)
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  _confirmSendDemande();
                },
                child: Text('Oui'),
              ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Annuler'),
            ),
          ],
        );
      },
    );
  }

  void _confirmSendDemande() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Confirmer la demande'),
          content: Text('Êtes-vous sûr de vouloir envoyer la demande de création de compte ?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pushNamed(context, '/profile');
              },
              child: Text('Non'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                try {
                  await ClientService.sendDemandeCreationCompte();
                  setState(() {
                    _hasSentRequest = true;
                  });
                  if (mounted) {
                    ScaffoldMessenger.of(_scaffoldKey.currentContext!).showSnackBar(
                      SnackBar(content: Text('Demande envoyée avec succès !')),
                    );
                  }
                } catch (e) {
                  if (mounted) {
                    ScaffoldMessenger.of(_scaffoldKey.currentContext!).showSnackBar(
                      SnackBar(content: Text('Échec de l\'envoi de la demande : $e')),
                    );
                  }
                }
              },
              child: Text('Oui'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Annuler'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isLargeScreen = MediaQuery.of(context).size.width > 800;

    return Theme(
      data: ThemeData.light(),
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          backgroundColor: Colors.green, // Set the navbar background to green
          elevation: 2,
          titleSpacing: 0,
          leading: isLargeScreen
              ? null
              : IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => _scaffoldKey.currentState?.openDrawer(),
          ),
          title: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Image.asset(
                  'assets/images/1.png',
                  height: 50, // Adjust the size of the logo
                  fit: BoxFit.contain,
                ),
                if (isLargeScreen) Expanded(child: _navBarItems(context)),
              ],
            ),
          ),
          actions: const [
            Padding(
              padding: EdgeInsets.only(right: 16.0),
              child: CircleAvatar(child: _ProfileIcon()),
            )
          ],
        ),
        drawer: isLargeScreen ? null : _drawer(context),
        body: Container(
          color: Colors.white, // Set the body background color to white
          child: SingleChildScrollView(
            controller: _scrollController,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildHomeSection(),
                _buildDevenirClientSection(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _drawer(BuildContext context) => Drawer(
    child: ListView(
      padding: EdgeInsets.zero,
      children: <Widget>[
        UserAccountsDrawerHeader(
          accountName: Text("Nom du Client"),
          accountEmail: Text("client@exemple.com"),
          currentAccountPicture: CircleAvatar(
            backgroundColor: Colors.white,
            child: Text(
              "C",
              style: TextStyle(fontSize: 40.0),
            ),
          ),
          decoration: BoxDecoration(
            color: Colors.greenAccent, // Changed to greenAccent
          ),
        ),
        ..._menuItems.map((item) => ListTile(
          onTap: () {
            _scaffoldKey.currentState?.openEndDrawer();
            _handleNavigation(context, item);
          },
          title: Text(item),
        )),
      ],
    ),
  );

  Widget _navBarItems(BuildContext context) => Row(
    mainAxisAlignment: MainAxisAlignment.end,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: _menuItems
        .map(
          (item) => InkWell(
        onTap: () {
          if (item == 'Ouvrir un compte') {
            _scrollToSection(MediaQuery.of(context).size.height); // Adjust the position to scroll to the desired section
          } else {
            _handleNavigation(context, item);
          }
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 16),
          child: Text(
            item,
            style: const TextStyle(fontSize: 18, color: Colors.white),
          ),
        ),
      ),
    )
        .toList(),
  );

  void _handleNavigation(BuildContext context, String item) {
    switch (item) {
      case 'Accueil':
        _scrollToSection(0); // Scroll to the top for Home
        break;
      case 'Ouvrir un compte':
        _scrollToSection(MediaQuery.of(context).size.height); // Adjust the position to scroll to the desired section
        break;
      case 'Offre':
        Navigator.pushNamed(context, '/offre');
        break;
      case 'Réclamation':
        Navigator.pushNamed(context, '/reclamation');
        break;
      case 'Liste des Réclamations':
        Navigator.pushNamed(context, '/listreclamation');
        break;
    }
  }

  Widget _buildHomeSection() {
    return Container(
      height: MediaQuery.of(context).size.height, // Full height for centering
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                flex: 2,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'BANQUE PARTICIPATIVE POUR TOUS',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'AL AKHDAR BANK (AAB) est une nouvelle banque participative créée conjointement par le Groupe Crédit Agricole du Maroc (CAM) et la Société Islamique pour le Développement du Secteur Privé (SID), une institution financière multilatérale de développement, filiale du Groupe de la Banque Islamique de Développement. AL AKHDAR BANK s’inscrit dans le cadre de la stratégie du Groupe Crédit Agricole du Maroc visant la diversification des produits proposés à la clientèle. Elle permet, par ailleurs, au Groupe CAM de se distinguer par des solutions bancaires novatrices notamment pour le financement et le développement du secteur agricole et du monde rural.',
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(height: 20),
                    Text(
                      'AL AKHDAR BANK',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 20),
              Expanded(
                flex: 1,
                child: Image.asset(
                  'assets/images/1.png',
                  height: 200, // Adjust the size as needed
                  fit: BoxFit.contain,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDevenirClientSection() {
    return Container(
      height: MediaQuery.of(context).size.height, // Full height for centering
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                flex: 2,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Devenir Client',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'RIEN DE PLUS SIMPLE!\nQuels que soient vos besoins, il y a forcément une solution AL AKHDAR BANK\n qui vous correspond, Découvrez dès maintenant les avantages à être client AAB.\n Et réaliser l’ouverture de votre compte en ligne.',
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _openPopup,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green, // Set button color to green
                        padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
                      ),
                      child: Text(
                        'Ouvrir un compte',
                        style: TextStyle(fontSize: 18), // Increase font size
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 20),
              Expanded(
                flex: 1,
                child: Image.asset(
                  'assets/images/4.png',
                  height: 250, // Adjust the size as needed
                  fit: BoxFit.contain,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

final List<String> _menuItems = <String>[
  'Accueil',
  'Ouvrir un compte',
  'Offre',
  'Réclamation',
  'Liste des Réclamations',
];

enum Menu { profile, signOut }

class _ProfileIcon extends StatelessWidget {
  const _ProfileIcon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<Menu>(
      icon: const Icon(Icons.person, color: Colors.white),
      offset: const Offset(0, 40),
      onSelected: (Menu item) async {
        switch (item) {
          case Menu.profile:
            Navigator.pushNamed(context, '/profile');
            break;
          case Menu.signOut:
            await Provider.of<AuthProvider>(context, listen: false).signOut();
            Navigator.pushNamedAndRemoveUntil(context, '/auth', (route) => false);
            break;
        }
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<Menu>>[
        const PopupMenuItem<Menu>(
          value: Menu.profile,
          child: Text('Profil'),
        ),
        const PopupMenuItem<Menu>(
          value: Menu.signOut,
          child: Text('Déconnexion'),
        ),
      ],
    );
  }
}
