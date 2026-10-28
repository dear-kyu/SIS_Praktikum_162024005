import 'package:flutter/material.dart';

import '../models/drink.dart';
import 'drink_detail_page.dart';
import 'add_product.dart';

class HomePage extends StatefulWidget {
  final List<Drink> drinkList;
  final Function(Drink, int) onAddToCart;

  const HomePage({
    super.key,
    required this.drinkList,
    required this.onAddToCart,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String searchText = '';

  @override
  Widget build(BuildContext context) {
    final filteredDrinks = widget.drinkList.where((drink) {
      return drink.name.toLowerCase().contains(searchText);
    }).toList();

    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Cari Minuman',
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (value) {
                setState(() {
                  searchText = value.toLowerCase();
                });
              },
            ),
          ),
          Expanded(
            child: filteredDrinks.isEmpty
                ? const Center(child: Text('Minuman tidak ditemukan'))
                : ListView.builder(
                    padding: const EdgeInsets.all(8.0),
                    itemCount: filteredDrinks.length,
                    itemBuilder: (context, index) {
                      final drink = filteredDrinks[index];

                      return Container(
                        padding: const EdgeInsets.all(12),
                        margin: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.blue[50],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: [
                            Image.asset(
                              drink.imageUrl,
                              width: 45,
                              height: 45,
                              fit: BoxFit.cover,
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    drink.name,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Rp ${drink.price}',
                                    style: TextStyle(color: Colors.green[700]),
                                  ),
                                ],
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => DrinkDetailPage(
                                      drink: drink,
                                      onAddToCart: widget.onAddToCart,
                                    ),
                                  ),
                                );
                              },
                              child: const Text('Detail'),
                            ),
                            const SizedBox(width: 4),
                            ElevatedButton(
                              onPressed: () {
                                widget.onAddToCart(drink, 1);
                              },
                              child: const Text('Pesan'),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddProductPage()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
