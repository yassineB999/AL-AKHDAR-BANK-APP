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
  int totalDemande = 0; // New variable to store total demands

  @override
  void initState() {
    super.initState();
    _fetchTotalClients();
    _fetchTotalOffres();
    _fetchTotalReclamations();
    _fetchTotalDemande(); // Fetch total demands on init
  }

  Future<void> _fetchTotalClients() async {
    try {
      int clients = await AdminService.getTotalClients();
      setState(() {
        totalClients = clients;
      });
    } catch (e) {
      print('Failed to fetch total clients: $e');
    }
  }

  Future<void> _fetchTotalOffres() async {
    try {
      int offres = await AdminService.getTotalOffres();
      setState(() {
        totalOffres = offres;
      });
    } catch (e) {
      print('Failed to fetch total offers: $e');
    }
  }

  Future<void> _fetchTotalReclamations() async {
    try {
      int reclamations = await AdminService.getTotalReclamations();
      setState(() {
        totalReclamations = reclamations;
      });
    } catch (e) {
      print('Failed to fetch total reclamations: $e');
    }
  }

  Future<void> _fetchTotalDemande() async {
    try {
      int demandes = await AdminService.getTotalDemandes(); // Fetch the total demands
      setState(() {
        totalDemande = demandes;
      });
    } catch (e) {
      print('Failed to fetch total demands: $e');
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
          backgroundColor: Colors.blueAccent,
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
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Admin Dashboard",
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
                  "Welcome to the Admin Dashboard!",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                Text(
                  "Use the navigation menu to manage clients, view offers, "
                      "handle reclamations, and more.",
                  style: TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 40),
                _buildDashboardCard("Total Clients", totalClients.toString()),
                _buildDashboardCard("Total Offers", totalOffres.toString()),
                _buildDashboardCard("Total Reclamations", totalReclamations.toString()),
                _buildDashboardCard("Total Demands", totalDemande.toString()), // New card for total demands
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
            color: Colors.blueAccent,
          ),
          child: Center(
            child: Text(
              'Admin Menu',
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
          padding: const EdgeInsets.symmetric(
              vertical: 24.0, horizontal: 16),
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
      case 'List Client':
        Navigator.pushNamed(context, '/manageclients');
        break;
      case 'List Offre':
        Navigator.pushNamed(context, '/manageoffre');
        break;
      case 'List Reclamation':
        Navigator.pushNamed(context, '/managereclamation');
        break;
      case 'List Demande':
        Navigator.pushNamed(context, '/managedemande');
        break;
      case 'Profile':
        Navigator.pushNamed(context, '/profile');
        break;
    // Add more cases for other items if needed
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
            Icon(Icons.group, size: 40, color: Colors.blueAccent),
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
                  style: TextStyle(fontSize: 30, color: Colors.blueAccent),
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
  'Dashboard',
  'List Client',
  'List Offre',
  'List Reclamation',
  'List Demande',
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
          // Handle sign out
            await Provider.of<AuthProvider>(context, listen: false).signOut();
            Navigator.pushNamedAndRemoveUntil(context, '/auth', (route) => false);
            break;
        }
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<Menu>>[
        const PopupMenuItem<Menu>(
          value: Menu.profile,
          child: Text('Profile'),
        ),
        const PopupMenuItem<Menu>(
          value: Menu.signOut,
          child: Text('Sign Out'),
        ),
      ],
    );
  }
}
