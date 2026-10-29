import 'package:flutter/material.dart';

import '../models/cart_item.dart';
import '../models/drink.dart';
import 'cart_page.dart';
import 'home_page.dart';
import 'add_product.dart';
import 'edit_product.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  static const Color creamBackground = Color(0xFFFFF7F5);
  static const Color creamWhite = Color(0xFFFFFCFA);
  static const Color teaRed = Color(0xFFAA382B);
  static const Color darkBrown = Color(0xFF725A52);

  final List<CartItem> _cartItems = [];

  final List<Drink> _drinkList = [
    Drink(
      id: 'd1',
      name: 'Mofusand Leopard',
      price: 18000,
      imageUrl: 'assets/mofusand_leopard.jpg',
    ),
    Drink(
      id: 'd2',
      name: 'Mofusand x Pompompurin',
      price: 20000,
      imageUrl: 'assets/mofusand_pompompurin.jpg',
    ),
    Drink(
      id: 'd3',
      name: 'Mofusand Ice Cream',
      price: 25000,
      imageUrl: 'assets/mofusand_icecream.jpg',
    ),
    Drink(
      id: 'd4',
      name: 'Mofusand Orca',
      price: 28000,
      imageUrl: 'assets/mofusand_orca.jpg',
    ),
  ];

  void _addProduct(Drink newDrink) {
    setState(() {
      _drinkList.add(newDrink);
    });
  }

  void _updateProduct(Drink updatedDrink) {
    setState(() {
      final index = _drinkList.indexWhere(
        (drink) => drink.id == updatedDrink.id,
      );

      if (index != -1) {
        _drinkList[index] = updatedDrink;
      }
    });
  }

  void _deleteProduct(String id) {
    setState(() {
      _drinkList.removeWhere((drink) => drink.id == id);
    });
  }

  void _navigateToAddPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddProductPage(
          onSave: (Drink newDrink) {
            _addProduct(newDrink);
          },
        ),
      ),
    );
  }

  void _navigateToEditPage(BuildContext context, Drink drinkToEdit) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditProductPage(
          existingDrink: drinkToEdit,
          onSave: (Drink updatedDrink) {
            _updateProduct(updatedDrink);
          },
        ),
      ),
    );
  }

  void addToCart(Drink drink, int quantity) {
    setState(() {
      final existingIndex = _cartItems.indexWhere(
        (item) => item.drink.id == drink.id,
      );

      if (existingIndex != -1) {
        _cartItems[existingIndex].quantity += quantity;
      } else {
        _cartItems.add(CartItem(drink: drink, quantity: quantity));
      }
    });
  }

  void _removeFromCart(String drinkId) {
    setState(() {
      _cartItems.removeWhere((item) => item.drink.id == drinkId);
    });
  }

  void _clearCart() {
    setState(() {
      _cartItems.clear();
    });
  }

  List<Widget> _buildPages() {
    return [
      HomePage(
        drinkList: _drinkList,
        onAddToCart: addToCart,
        onAdd: () {
          _navigateToAddPage(context);
        },
        onEdit: (Drink drink) {
          _navigateToEditPage(context, drink);
        },
        onDelete: _deleteProduct,
      ),
      CartPage(
        cartItems: _cartItems,
        onRemoveFromCart: _removeFromCart,
        onClearCart: _clearCart,
      ),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final pages = _buildPages();

    return Scaffold(
      backgroundColor: creamBackground,
      body: SafeArea(top: true, bottom: false, child: pages[_selectedIndex]),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: creamWhite,
        selectedItemColor: teaRed,
        unselectedItemColor: darkBrown.withValues(alpha: 0.65),
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600),
        unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500),
        type: BottomNavigationBarType.fixed,
        elevation: 8,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: [
          const BottomNavigationBarItem(
            icon: Icon(Icons.local_cafe_outlined),
            activeIcon: Icon(Icons.local_cafe),
            label: 'Menu',
          ),
          BottomNavigationBarItem(
            icon: Badge(
              backgroundColor: teaRed,
              textColor: Colors.white,
              label: Text(_cartItems.length.toString()),
              isLabelVisible: _cartItems.isNotEmpty,
              child: const Icon(Icons.shopping_cart_outlined),
            ),
            activeIcon: Badge(
              backgroundColor: teaRed,
              textColor: Colors.white,
              label: Text(_cartItems.length.toString()),
              isLabelVisible: _cartItems.isNotEmpty,
              child: const Icon(Icons.shopping_cart),
            ),
            label: 'Keranjang',
          ),
        ],
      ),
    );
  }
}
