import 'package:flutter/material.dart';
import 'package:frontend/services/AdminService.dart';
import 'package:frontend/services/auth_provider.dart';
import 'package:provider/provider.dart';

class HomeAdmin extends StatefulWidget {
  @override
  _HomeAdminState createState() => _HomeAdminState();
}

class _HomeAdminState extends State<HomeAdmin> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int totalClients = 0;
  int totalOffres = 0;
  int totalReclamations = 0;
  int totalDemande = 0; // Nouvelle variable pour stocker le nombre total de demandes

  @override
  void initState() {
    super.initState();
    _fetchTotalClients();
    _fetchTotalOffres();
    _fetchTotalReclamations();
    _fetchTotalDemande(); // Récupérer le nombre total de demandes lors de l'initialisation
  }

  Future<void> _fetchTotalClients() async {
    try {
      int clients = await AdminService.getTotalClients();
      setState(() {
        totalClients = clients;
      });
    } catch (e) {
      print('Échec de la récupération du nombre total de clients : $e');
    }
  }

  Future<void> _fetchTotalOffres() async {
    try {
      int offres = await AdminService.getTotalOffres();
      setState(() {
        totalOffres = offres;
      });
    } catch (e) {
      print('Échec de la récupération du nombre total d\'offres : $e');
    }
  }

  Future<void> _fetchTotalReclamations() async {
    try {
      int reclamations = await AdminService.getTotalReclamations();
      setState(() {
        totalReclamations = reclamations;
      });
    } catch (e) {
      print('Échec de la récupération du nombre total de réclamations : $e');
    }
  }

  Future<void> _fetchTotalDemande() async {
    try {
      int demandes = await AdminService.getTotalDemandes(); // Récupérer le nombre total de demandes
      setState(() {
        totalDemande = demandes;
      });
    } catch (e) {
      print('Échec de la récupération du nombre total de demandes : $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isLargeScreen = MediaQuery.of(context).size.width > 800;

    return Theme(
      data: ThemeData.light(),
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          backgroundColor: Colors.green,
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
                  height: 40, // Ajuster la taille du logo
                  fit: BoxFit.contain,
                ),
                SizedBox(width: 16), // Ajouter un espace entre le logo et le texte
                const Text(
                  "",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 24),
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
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                Text(
                  "",
                  style: TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 40),
                _buildDashboardCard("Total Clients", totalClients.toString()),
                _buildDashboardCard("Total Offres", totalOffres.toString()),
                _buildDashboardCard("Total Réclamations", totalReclamations.toString()),
                _buildDashboardCard("Total Demandes", totalDemande.toString()), // Nouvelle carte pour le nombre total de demandes
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _drawer(BuildContext context) => Drawer(
    child: ListView(
      children: [
        DrawerHeader(
          decoration: BoxDecoration(
            color: Colors.green,
          ),
          child: Center(
            child: Text(
              'Menu Admin',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
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
          _handleNavigation(context, item);
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
      case 'Liste Clients':
        Navigator.pushNamed(context, '/manageclients');
        break;
      case 'Liste Offres':
        Navigator.pushNamed(context, '/manageoffre');
        break;
      case 'Liste Réclamations':
        Navigator.pushNamed(context, '/managereclamation');
        break;
      case 'Liste Demandes':
        Navigator.pushNamed(context, '/managedemande');
        break;
      case 'Profil':
        Navigator.pushNamed(context, '/profile');
        break;
    // Ajouter plus de cas pour d'autres éléments si nécessaire
    }
  }

  Widget _buildDashboardCard(String title, String value) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.group, size: 40, color: Colors.green),
            SizedBox(width: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                Text(
                  value,
                  style: TextStyle(fontSize: 30, color: Colors.green),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

final List<String> _menuItems = <String>[
  'Tableau de bord',
  'Liste Clients',
  'Liste Offres',
  'Liste Réclamations',
  'Liste Demandes',
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
          // Gérer la déconnexion
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
