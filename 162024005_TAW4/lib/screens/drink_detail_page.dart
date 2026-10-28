import 'package:flutter/material.dart';

import '../models/drink.dart';

class DrinkDetailPage extends StatefulWidget {
  final Drink drink;
  final Function(Drink, int) onAddToCart;

  const DrinkDetailPage({
    super.key,
    required this.drink,
    required this.onAddToCart,
  });

  @override
  State<DrinkDetailPage> createState() => _DrinkDetailPageState();
}

class _DrinkDetailPageState extends State<DrinkDetailPage> {
  int _quantity = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.drink.name)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.brown.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Image.asset(widget.drink.imageUrl, width: 100, height: 100),
                  const SizedBox(height: 10),
                  Text(
                    widget.drink.name,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    'Harga: Rp ${widget.drink.price}',
                    style: TextStyle(color: Colors.green[700], fontSize: 16),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 25),
            const Text('Jumlah:', style: TextStyle(fontSize: 16)),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () {
                    setState(() {
                      if (_quantity > 1) {
                        _quantity--;
                      }
                    });
                  },
                  icon: const Icon(
                    Icons.remove_circle,
                    color: Colors.red,
                    size: 30,
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  '$_quantity',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 10),
                IconButton(
                  onPressed: () {
                    setState(() {
                      _quantity++;
                    });
                  },
                  icon: const Icon(
                    Icons.add_circle,
                    color: Colors.green,
                    size: 30,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20),
        child: ElevatedButton(
          onPressed: () {
            widget.onAddToCart(widget.drink, _quantity);

            showDialog(
              context: context,
              builder: (dialogContext) {
                return AlertDialog(
                  title: const Text('Berhasil Ditambahkan'),
                  content: Text(
                    '${widget.drink.name} sebanyak $_quantity '
                    'berhasil ditambahkan ke keranjang.',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(dialogContext);
                      },
                      child: const Text('OK'),
                    ),
                  ],
                );
              },
            );
          },
          child: const Text('Tambah ke Keranjang'),
        ),
      ),
    );
  }
}
