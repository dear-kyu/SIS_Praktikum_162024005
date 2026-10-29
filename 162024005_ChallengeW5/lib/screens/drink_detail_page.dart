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

  static const Color cream = Color(0xFFFFF7F5);
  static const Color creamWhite = Color(0xFFFFFCFA);
  static const Color teaRed = Color(0xFFAA382B);
  static const Color brown = Color(0xFF725A52);
  static const Color mutedBrown = Color(0xFF9A8178);
  static const Color softBorder = Color(0xFFF0DFDA);
  static const Color priceGreen = Color(0xFF61966A);

  void _incrementQuantity() {
    setState(() {
      _quantity++;
    });
  }

  void _decrementQuantity() {
    if (_quantity > 1) {
      setState(() {
        _quantity--;
      });
    }
  }

  void _showSuccessDialog(
    BuildContext context,
    String drinkName,
    int quantity,
  ) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: creamWhite,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
            side: const BorderSide(color: softBorder),
          ),
          icon: const Icon(
            Icons.check_circle_outline_rounded,
            color: priceGreen,
            size: 48,
          ),
          title: const Text(
            'Berhasil Ditambahkan!',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: brown,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          content: Text(
            '$drinkName ($quantity) berhasil ditambahkan ke keranjang ♡',
            textAlign: TextAlign.center,
            style: const TextStyle(color: brown, height: 1.5),
          ),
          actionsAlignment: MainAxisAlignment.center,
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: teaRed,
                foregroundColor: Colors.white,
                elevation: 0,
                minimumSize: const Size(120, 44),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              onPressed: () {
                Navigator.of(dialogContext).pop();
                Navigator.of(context).pop();
              },
              child: const Text(
                'OK, siap!',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: cream,
      appBar: AppBar(
        backgroundColor: cream,
        foregroundColor: brown,
        elevation: 0,
        centerTitle: true,
        title: Text(
          widget.drink.name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        top: true,
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 32),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight - 52,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.fromLTRB(20, 24, 20, 22),
                      decoration: BoxDecoration(
                        color: creamWhite,
                        borderRadius: BorderRadius.circular(28),
                        border: Border.all(color: softBorder, width: 1),
                        boxShadow: [
                          BoxShadow(
                            color: brown.withValues(alpha: 0.07),
                            blurRadius: 18,
                            offset: const Offset(0, 7),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Image.asset(
                            widget.drink.imageUrl,
                            height: 175,
                            width: 175,
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) {
                              return const SizedBox(
                                height: 175,
                                width: 175,
                                child: Icon(
                                  Icons.image_not_supported_outlined,
                                  color: mutedBrown,
                                  size: 48,
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 20),
                          Text(
                            widget.drink.name,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 23,
                              height: 1.3,
                              fontWeight: FontWeight.bold,
                              color: brown,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'Rp ${widget.drink.price}',
                            style: const TextStyle(
                              fontSize: 20,
                              color: priceGreen,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),
                    const Text(
                      'Jumlah Produk',
                      style: TextStyle(
                        color: brown,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: creamWhite,
                        borderRadius: BorderRadius.circular(22),
                        border: Border.all(color: softBorder),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _QuantityButton(
                            icon: Icons.remove_rounded,
                            color: teaRed,
                            onPressed: _decrementQuantity,
                          ),
                          SizedBox(
                            width: 64,
                            child: Text(
                              '$_quantity',
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                                color: brown,
                              ),
                            ),
                          ),
                          _QuantityButton(
                            icon: Icons.add_rounded,
                            color: teaRed,
                            onPressed: _incrementQuantity,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 28),
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: teaRed,
                          foregroundColor: Colors.white,
                          elevation: 3,
                          shadowColor: teaRed.withValues(alpha: 0.25),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                        ),
                        icon: const Icon(Icons.shopping_bag_outlined, size: 21),
                        label: const Text(
                          'Tambah ke Keranjang',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        onPressed: () {
                          widget.onAddToCart(widget.drink, _quantity);

                          _showSuccessDialog(
                            context,
                            widget.drink.name,
                            _quantity,
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Adopt your Mofusand!',
                      style: TextStyle(color: mutedBrown, fontSize: 12),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _QuantityButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onPressed;

  const _QuantityButton({
    required this.icon,
    required this.color,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color.withValues(alpha: 0.12),
      shape: const CircleBorder(),
      child: InkWell(
        onTap: onPressed,
        customBorder: const CircleBorder(),
        child: SizedBox(
          width: 44,
          height: 44,
          child: Icon(icon, color: color, size: 25),
        ),
      ),
    );
  }
}
