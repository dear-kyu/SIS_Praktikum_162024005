import 'package:flutter/material.dart';

import '../models/cart_item.dart';

const Color creamBackground = Color(0xFFFFF7F5);
const Color creamWhite = Color(0xFFFFFCFA);
const Color softRed = Color(0xFFFFE3DF);
const Color teaRed = Color(0xFFAA382B);
const Color darkBrown = Color(0xFF725A52);
const Color mutedBrown = Color(0xFF9A8178);
const Color softBorder = Color(0xFFF0DFDA);
const Color priceGreen = Color(0xFF61966A);

class CartPage extends StatefulWidget {
  final List<CartItem> cartItems;
  final Function(String) onRemoveFromCart;
  final VoidCallback onClearCart;

  const CartPage({
    super.key,
    required this.cartItems,
    required this.onRemoveFromCart,
    required this.onClearCart,
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
    final totalPrice = widget.cartItems.fold<int>(
      0,
      (sum, item) => sum + item.drink.price * item.quantity,
    );

    return Container(
      color: creamBackground,
      child: Column(
        children: [
          Expanded(
            child: widget.cartItems.isEmpty
                ? const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.shopping_bag_outlined,
                          size: 64,
                          color: teaRed,
                        ),
                        SizedBox(height: 14),
                        Text(
                          'Keranjang masih kosong',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: darkBrown,
                          ),
                        ),
                        SizedBox(height: 6),
                        Text(
                          'Yuk, pilih Mofusand favoritmu!',
                          style: TextStyle(color: mutedBrown),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
                    itemCount: widget.cartItems.length,
                    itemBuilder: (context, index) {
                      final item = widget.cartItems[index];
                      final subtotal = item.drink.price * item.quantity;

                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: creamWhite,
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(color: softBorder),
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0x0A725A52),
                              blurRadius: 8,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Image.asset(
                              item.drink.imageUrl,
                              width: 58,
                              height: 58,
                              fit: BoxFit.contain,
                              errorBuilder: (context, error, stackTrace) {
                                return const SizedBox(
                                  width: 58,
                                  height: 58,
                                  child: Icon(
                                    Icons.image_not_supported_outlined,
                                    color: mutedBrown,
                                  ),
                                );
                              },
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.drink.name,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: darkBrown,
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    'Jumlah: ${item.quantity}',
                                    style: const TextStyle(
                                      fontSize: 13,
                                      color: mutedBrown,
                                    ),
                                  ),
                                  const SizedBox(height: 3),
                                  Text(
                                    'Rp $subtotal',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: priceGreen,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              tooltip: 'Hapus',
                              onPressed: () {
                                widget.onRemoveFromCart(item.drink.id);
                              },
                              icon: const Icon(
                                Icons.delete_outline_rounded,
                                color: teaRed,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),

          if (widget.cartItems.isNotEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 14),
              decoration: const BoxDecoration(
                color: creamWhite,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                border: Border(top: BorderSide(color: softBorder)),
                boxShadow: [
                  BoxShadow(
                    color: Color(0x0A725A52),
                    blurRadius: 10,
                    offset: Offset(0, -3),
                  ),
                ],
              ),
              child: SafeArea(
                top: false,
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Data Pemesanan',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: darkBrown,
                        ),
                      ),
                      const SizedBox(height: 12),

                      TextFormField(
                        controller: _namaController,
                        textCapitalization: TextCapitalization.words,
                        decoration: _inputDecoration(
                          label: 'Nama Pemesan',
                          hint: 'Masukkan nama pemesan',
                          icon: Icons.person_outline_rounded,
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Nama Pemesan tidak boleh kosong';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 10),

                      TextFormField(
                        controller: _mejaController,
                        keyboardType: TextInputType.number,
                        decoration: _inputDecoration(
                          label: 'Nomor Meja',
                          hint: 'Masukkan nomor meja (1-20)',
                          icon: Icons.table_restaurant_outlined,
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

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Total Harga',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: darkBrown,
                            ),
                          ),
                          Text(
                            'Rp $totalPrice',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: priceGreen,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),

                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            FocusScope.of(context).unfocus();

                            if (_formKey.currentState!.validate()) {
                              _showCheckoutDialog(totalPrice);
                            }
                          },
                          icon: const Icon(
                            Icons.shopping_bag_outlined,
                            size: 20,
                          ),
                          label: const Text(
                            'Checkout',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: teaRed,
                            foregroundColor: Colors.white,
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  InputDecoration _inputDecoration({
    required String label,
    required String hint,
    required IconData icon,
  }) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      floatingLabelBehavior: FloatingLabelBehavior.auto,
      labelStyle: const TextStyle(color: mutedBrown, fontSize: 14),
      hintStyle: const TextStyle(color: mutedBrown, fontSize: 14),
      prefixIcon: Icon(icon, color: teaRed, size: 21),
      prefixIconConstraints: const BoxConstraints(minWidth: 48, minHeight: 48),
      filled: true,
      fillColor: creamWhite,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 15),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: softBorder),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: softBorder),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: teaRed, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Colors.redAccent),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Colors.redAccent, width: 1.5),
      ),
    );
  }

  void _showCheckoutDialog(int totalPrice) {
    final namaPemesan = _namaController.text.trim();
    final nomorMeja = _mejaController.text.trim();

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: creamWhite,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
          ),
          icon: const Icon(
            Icons.check_circle_outline_rounded,
            color: teaRed,
            size: 46,
          ),
          title: const Text(
            'Checkout Berhasil',
            textAlign: TextAlign.center,
            style: TextStyle(color: darkBrown, fontWeight: FontWeight.bold),
          ),
          content: Text(
            'Pesanan berhasil diproses!\n\n'
            'Nama Pemesan: $namaPemesan\n'
            'Nomor Meja: $nomorMeja\n'
            'Total Pembayaran: Rp $totalPrice',
            style: const TextStyle(color: darkBrown, height: 1.6),
          ),
          actionsAlignment: MainAxisAlignment.center,
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(dialogContext);
                widget.onClearCart();
                _namaController.clear();
                _mejaController.clear();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: teaRed,
                foregroundColor: Colors.white,
                minimumSize: const Size(120, 44),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
