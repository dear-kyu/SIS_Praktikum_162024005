import 'package:flutter/material.dart';

import '../models/drink.dart';
import '../models/cart_item.dart';

import 'package:challengew3/screens/home_page.dart' as home_page;

import 'cart_page.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<CartItem> _cartItems = [];

  final List<Drink> _drinkList = [
    Drink(id: '1', name: 'Espresso', price: 18000, imageUrl: 'assets/cafe.png'),
    Drink(
      id: '2',
      name: 'Americano',
      price: 20000,
      imageUrl: 'assets/cafe.png',
    ),
    Drink(
      id: '3',
      name: 'Matcha Latte',
      price: 25000,
      imageUrl: 'assets/cafe.png',
    ),
    Drink(
      id: '4',
      name: 'Chocolate Frappe',
      price: 28000,
      imageUrl: 'assets/cafe.png',
    ),
  ];

  void _addToCart(Drink drink, int quantity) {
    if (quantity <= 0) return;

    setState(() {
      final index = _cartItems.indexWhere((item) => item.drink.id == drink.id);

      if (index != -1) {
        _cartItems[index].quantity += quantity;
      } else {
        _cartItems.add(CartItem(drink: drink, quantity: quantity));
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${drink.name} ditambahkan ke keranjang'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _removeFromCart(String drinkId) {
    setState(() {
      _cartItems.removeWhere((item) => item.drink.id == drinkId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      home_page.HomePage(drinkList: _drinkList, onAddToCart: _addToCart),
      CartPage(cartItems: _cartItems, onRemoveFromCart: _removeFromCart),
    ];

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          _selectedIndex == 0 ? 'Warung IS - Menu' : 'Keranjang Anda',
        ),
      ),
      body: IndexedStack(index: _selectedIndex, children: pages),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: [
          const BottomNavigationBarItem(
            icon: Icon(Icons.local_cafe),
            label: 'Menu',
          ),
          BottomNavigationBarItem(
            icon: Stack(
              clipBehavior: Clip.none,
              children: [
                const Icon(Icons.shopping_cart),
                if (_cartItems.isNotEmpty)
                  Positioned(
                    right: -8,
                    top: -6,
                    child: Container(
                      padding: const EdgeInsets.all(3),
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        '${_cartItems.fold<int>(0, (sum, item) => sum + item.quantity)}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            label: 'Keranjang',
          ),
        ],
      ),
    );
  }
}
