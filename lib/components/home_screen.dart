// ignore_for_file: unused_field

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:instore/components/controllers/instagrameur.dart';
import 'package:instore/components/details.dart';

import '../components/messages_screen.dart';
import '../components/produit.dart';
import '../components/profil_screen.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> with TickerProviderStateMixin {
  InstagrameurController instaController = Get.find<InstagrameurController>();

  final List<String> names = <String>[
    'Vetement',
    'Sport',
    'Electronic',
    'Maison',
    'Accesoire',
    'Beauté',
    'Animaux',
  ];

  final List<Map<String, String>> products = [
    {
      'name': 'Pull',
      'price': '90DT',
      'image': 'assets/YELLOW.png',
    },
    {
      'name': 'Chemise',
      'price': '100DT',
      'image': 'assets/chemise2.jpg',
    },
    {
      'name': 'Cargo',
      'price': '150DT',
      'image': 'assets/kargou.jpg',
    },
    {
      'name': 'Trenche',
      'price': '250DT',
      'image': 'assets/trenchesW.jpg',
    },
  ];

  int _selectedIndex = 0;
  late FocusNode _searchFocusNode;
  late AnimationController _animationController;
  late Animation<double> _animation;
  bool _isMessageSelected = false;
  bool _isAccountSelected = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    _animationController.forward();
    _searchFocusNode = FocusNode();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      _updateIconStates();
    });
    // Ajouter votre logique de navigation ici
    switch (index) {
      case 0:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeView()),
        );
        break;
      case 1:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const InstagramProduit()),
        );
        break;
      case 2:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MessageScreen()),
        );
        break;
      case 3:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const ProfilScreen()),
        );
        break;
    }
  }

  void _updateIconStates() {
    _isMessageSelected = _selectedIndex == 2;
    _isAccountSelected = _selectedIndex == 3;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Image.asset(
                'assets/instore.png',
                height: 50,
              ),
              const CircleAvatar(
                radius: 20, // Ajustez la taille du cercle
                backgroundImage: AssetImage('assets/marwa.jpg'),
              ),
            ],
          ),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.only(top: 10, left: 20, right: 20),
        child: Column(
          children: [
            _searchTextFormField(),
            const SizedBox(height: 20),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Categories',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 20),
            _listViewCategory(),
            const SizedBox(height: 20),
            // Expanded widget to ensure the grid view takes up remaining space
            Expanded(
              child: _gridViewProducts(),
            ),
          ],
        ),
      ),
      bottomNavigationBar: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return AnimatedContainer(
            duration: const Duration(milliseconds: 100),
            transform: Matrix4.translationValues(
                0.0, 50.0 * (1.0 - _animation.value), 0.0), // Move up and down
            child: AnimatedOpacity(
              opacity: _animation.value,
              duration: const Duration(milliseconds: 100),
              child: Container(
                decoration: const BoxDecoration(
                  border: Border(
                    top: BorderSide(
                        color: Colors.black, width: 1.0), // Add top border
                  ),
                ),
                child: BottomAppBar(
                  child: SizedBox(
                    height: 50.0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        IconButton(
                          icon: _selectedIndex == 0
                              ? const Icon(Icons.home)
                              : const Icon(Icons.home_outlined),
                          onPressed: () {
                            _onItemTapped(0);
                          },
                        ),
                        IconButton(
                          icon: _selectedIndex == 1
                              ? const Icon(Icons.shopping_bag)
                              : const Icon(Icons.shopping_bag_outlined),
                          onPressed: () {
                            _onItemTapped(1);
                          },
                        ),
                        IconButton(
                          icon: _selectedIndex == 2
                              ? const Icon(Icons.message)
                              : const Icon(Icons.message_outlined),
                          onPressed: () {
                            _onItemTapped(2);
                          },
                        ),
                        IconButton(
                          icon: _selectedIndex == 3
                              ? const Icon(Icons.account_circle)
                              : const Icon(Icons.account_circle_outlined),
                          onPressed: () {
                            _onItemTapped(3);
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _searchTextFormField() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.grey.shade200,
      ),
      child: TextFormField(
        focusNode: _searchFocusNode,
        decoration: const InputDecoration(
          border: InputBorder.none,
          prefixIcon: Icon(
            Icons.search,
            color: Colors.black,
          ),
        ),
      ),
    );
  }

  Widget _listViewCategory() {
    return SizedBox(
      height: 40, // Adjust height according to your need
      child: ListView.separated(
        itemCount: names.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: index == 0
                  ? const Color(0xFFFA058C)
                  : const Color(0xFFffebf7), // Change color for the first item
            ),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Center(
              child: Text(
                names[index],
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          );
        },
        separatorBuilder: (context, index) => const SizedBox(width: 20),
      ),
    );
  }

  Widget _gridViewProducts() {
    return FutureBuilder(
      future: instaController.getProducts(),
      builder: (context, snapshot) {
        if (snapshot.hasData &&
            snapshot.data != null &&
            snapshot.data!.isNotEmpty) {
          return GridView.builder(
            shrinkWrap: true,
            physics: const AlwaysScrollableScrollPhysics(),
            itemCount: snapshot.data!.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // Number of columns
              mainAxisSpacing: 20.0,
              crossAxisSpacing: 20.0,
              childAspectRatio: 0.7, // Adjust height of the cards
            ),
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  Get.to(const Details(),
                      arguments: {'id': snapshot.data![index].id});
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.grey.shade100,
                  ),
                  child: Column(
                    children: [
                      Container(
                        height: 150,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.grey.shade100,
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image.network(
                            snapshot.data![index].image,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        snapshot.data![index].name,
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        snapshot.data![index].priceSale.toString(),
                        style: const TextStyle(color: Colors.pink),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
