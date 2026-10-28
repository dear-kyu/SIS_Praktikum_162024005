import 'package:flutter/material.dart';

import '../models/cart_item.dart';

class CartPage extends StatefulWidget {
  final List<CartItem> cartItems;
  final Function(String) onRemoveFromCart;

  const CartPage({
    super.key,
    required this.cartItems,
    required this.onRemoveFromCart,
  });

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final _formKey = GlobalKey<FormState>();
  final _namaController = TextEditingController();
  final _mejaController = TextEditingController();

  @override
  void dispose() {
    _namaController.dispose();
    _mejaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final int totalPrice = widget.cartItems.fold<int>(
      0,
      (sum, item) => sum + (item.drink.price * item.quantity),
    );

    return Column(
      children: [
        Expanded(
          child: widget.cartItems.isEmpty
              ? const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.shopping_cart_outlined,
                        size: 65,
                        color: Colors.grey,
                      ),
                      SizedBox(height: 12),
                      Text('Keranjang Anda kosong.'),
                      SizedBox(height: 6),
                      Text(
                        'Silakan pilih minuman dari menu.',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(8),
                  itemCount: widget.cartItems.length,
                  itemBuilder: (context, index) {
                    final item = widget.cartItems[index];
                    final subtotal = item.drink.price * item.quantity;

                    return Card(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 6,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Row(
                          children: [
                            Image.asset(
                              item.drink.imageUrl,
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.drink.name,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Text('Jumlah: ${item.quantity}'),
                                  Text(
                                    'Rp $subtotal',
                                    style: TextStyle(color: Colors.green[700]),
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              tooltip: 'Hapus',
                              onPressed: () {
                                widget.onRemoveFromCart(item.drink.id);
                              },
                              icon: const Icon(Icons.delete, color: Colors.red),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
        ),

        // Form pemesan hanya muncul jika keranjang berisi item.
        if (widget.cartItems.isNotEmpty)
          Container(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
            decoration: BoxDecoration(
              color: Colors.blue[50],
              border: const Border(top: BorderSide(color: Colors.black12)),
            ),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Data Pemesanan',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),

                  // Field Nama Pemesan
                  TextFormField(
                    controller: _namaController,
                    decoration: const InputDecoration(
                      labelText: 'Nama Pemesan',
                      hintText: 'Masukkan nama pemesan',
                      prefixIcon: Icon(Icons.person),
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Nama Pemesan tidak boleh kosong';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),

                  // Field Nomor Meja
                  TextFormField(
                    controller: _mejaController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Nomor Meja',
                      hintText: 'Masukkan nomor meja (1-20)',
                      prefixIcon: Icon(Icons.table_restaurant),
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Nomor Meja harus berupa angka';
                      }

                      final nomorMeja = int.tryParse(value.trim());

                      if (nomorMeja == null) {
                        return 'Nomor Meja harus berupa angka';
                      }

                      if (nomorMeja < 1 || nomorMeja > 20) {
                        return 'Nomor Meja harus antara 1-20';
                      }

                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Total Harga
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Total Harga:',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Rp $totalPrice',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.green[700],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Tombol Checkout
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _showCheckoutDialog(totalPrice);
                        }
                      },
                      icon: const Icon(Icons.shopping_bag),
                      label: const Text('Checkout'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  void _showCheckoutDialog(int totalPrice) {
    final namaPemesan = _namaController.text.trim();
    final nomorMeja = _mejaController.text.trim();

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Checkout Berhasil'),
          content: Text(
            'Pesanan berhasil diproses!\n\n'
            'Nama Pemesan: $namaPemesan\n'
            'Nomor Meja: $nomorMeja\n'
            'Total Pembayaran: Rp $totalPrice',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);

                final orderedItems = widget.cartItems.toList();

                for (final item in orderedItems) {
                  widget.onRemoveFromCart(item.drink.id);
                }

                _namaController.clear();
                _mejaController.clear();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
