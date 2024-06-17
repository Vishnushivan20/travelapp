import 'package:base_auth/AP%20Page.dart';
import 'package:base_auth/GOA%20page.dart';
import 'package:base_auth/KA%20Page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'TN Page.dart';
import 'KL Page.dart';
import 'TL page.dart';
import 'AP Page.dart';

class TravelApp extends StatelessWidget {
  final User user;
  const TravelApp({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Travel App',
      home: HomePage(user: user,),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomePage extends StatefulWidget {
  final User user;
  const HomePage({Key? key, required this.user}) : super(key: key);
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  final List<Map<String, String>> _allItems = [
    {'name': 'TamilNadu', 'country': 'India', 'imagePath': 'asset/chennai.jpeg'},
    {'name': 'Kerala', 'country': 'India', 'imagePath': 'asset/kerala2.jpeg'},
    {'name': 'Telangana', 'country': 'India', 'imagePath': 'asset/telengana.jpeg'},
    {'name': 'Karnataka', 'country': 'India', 'imagePath': 'asset/karnataka.jpeg'},
    {'name': 'Goa', 'country': 'India', 'imagePath': 'asset/goa.jpeg'},
    {'name': 'Andhra', 'country': 'India', 'imagePath': 'asset/andhra.jpeg'},
  ];
  List<Map<String, String>> _filteredItems = [];

  void _filterSearchResults(String query) {
    if (query.isEmpty) {
      setState(() {
        _filteredItems = _allItems;
      });
      return;
    }

    List<Map<String, String>> filteredList = [];
    _allItems.forEach((item) {
      if (item['name']!.toLowerCase().contains(query.toLowerCase())) {
        filteredList.add(item);
      }
    });

    setState(() {
      _filteredItems = filteredList;
    });
  }

  void initState() {
    super.initState();
    _filteredItems = _allItems;
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue.shade300, Colors.purple.shade300],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          FadeTransition(
            opacity: _animation,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 40.0),
                child: Column(
                  children: [
                    _buildTopSection(),
                    SizedBox(height: 20),
                    _buildRecommendedSection(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        IconButton(
          icon: Icon(Icons.logout, color: Colors.white),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => Log(),));
          },
        ),
      ],
    );
  }

  Widget _buildRecommendedSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Place To Visit in India',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 20,),
        Container(
          height: 50,
          width: 300,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.8),
            borderRadius: BorderRadius.circular(10),
          ),
          padding: EdgeInsets.all(10),
          child: TextFormField(
            onChanged: _filterSearchResults,
            style: TextStyle(color: Colors.black),
            decoration: InputDecoration(
              hintText: 'Search',
              hintStyle: TextStyle(color: Colors.black54),
              border: InputBorder.none,
            ),
          ),
        ),
        SizedBox(height: 20,),
        Container(
          height: MediaQuery.of(context).size.height - 200,
          child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemCount: _filteredItems.length,
            itemBuilder: (context, index) {
              final item = _filteredItems[index];
              return _buildLocationCard(item['name']!, item['country']!, item['imagePath']!);
            },
          ),
        ),
      ],
    );
  }

  void _navigateToLocationPage(String locationName) {
    switch (locationName) {
      case 'TamilNadu':
        Navigator.push(context, MaterialPageRoute(builder: (context) => TNplc(user: FirebaseAuth.instance.currentUser!)));
        break;
      case 'Kerala':
        Navigator.push(context, MaterialPageRoute(builder: (context) => KLplc(user: FirebaseAuth.instance.currentUser!)));
        break;
      case 'Telangana':
        Navigator.push(context, MaterialPageRoute(builder: (context) => TLplc(user: FirebaseAuth.instance.currentUser!)));
        break;
      case 'Karnataka':
        Navigator.push(context, MaterialPageRoute(builder: (context) => KAplc(user: FirebaseAuth.instance.currentUser!)));
        break;
      case 'Goa':
        Navigator.push(context, MaterialPageRoute(builder: (context) => Goaplc(user: FirebaseAuth.instance.currentUser!)));
        break;
      case 'Andhra':
        Navigator.push(context, MaterialPageRoute(builder: (context) => APplc(user: FirebaseAuth.instance.currentUser!),));
    }
  }

  Widget _buildLocationCard(String name, String country, String imagePath) {
    return GestureDetector(
      onTap: () {
        _navigateToLocationPage(name);
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          image: DecorationImage(
            image: AssetImage(imagePath),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              bottom: 10,
              left: 10,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    country,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TNPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tamil Nadu'),
      ),
      body: Center(
        child: Text('Details of Tamil Nadu'),
      ),
    );
  }
}

class KeralaPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Kerala'),
      ),
      body: Center(
        child: Text('Details of Kerala'),
      ),
    );
  }
}

// Add similar pages for other locations like Karnataka, Goa, etc.

class Log extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Logout'),
      ),
      body: Center(
        child: Text('Logged out successfully!'),
      ),
    );
  }
}

void main() {
  runApp(TravelApp(user: FirebaseAuth.instance.currentUser!));
}
