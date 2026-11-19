import 'package:flutter/material.dart';
import '../models/cart_item.dart';
import '../utils/app_theme.dart';
import '../widgets/case_image_widget.dart';
import '../widgets/glass_container.dart';

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
  final _nameController = TextEditingController();
  final _tableController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _tableController.dispose();
    super.dispose();
  }

  int _calculateTotal() {
    int total = 0;
    for (var item in widget.cartItems) {
      total += item.drink.price * item.quantity;
    }
    return total;
  }

  void _showCheckoutDialog(
    BuildContext context,
    int totalAmount,
    String customerName,
    String tableNumber,
  ) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext ctx) {
        return AlertDialog(
          backgroundColor: const Color(0xFF151D30).withValues(alpha: 0.95),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
            side: BorderSide(
              color: Colors.white.withValues(alpha: 0.2),
              width: 1.2,
            ),
          ),
          contentPadding: const EdgeInsets.all(24),
          title: Column(
            children: [
              GlassContainer(
                width: 70,
                height: 70,
                borderRadius: BorderRadius.circular(35),
                blur: 16,
                opacity: 0.2,
                borderColor: const Color(0xFF10B981).withValues(alpha: 0.4),
                child: const Icon(
                  Icons.check_rounded,
                  color: Color(0xFF10B981),
                  size: 42,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Checkout Berhasil!',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GlassContainer(
                padding: const EdgeInsets.all(16),
                borderRadius: BorderRadius.circular(16),
                blur: 14,
                opacity: 0.12,
                borderColor: Colors.white.withValues(alpha: 0.16),
                child: Column(
                  children: [
                    _buildReceiptRow('Nama Pembeli', customerName),
                    Divider(
                      height: 16,
                      color: Colors.white.withValues(alpha: 0.12),
                    ),
                    _buildReceiptRow('No. Meja/Booth CH', 'Meja #$tableNumber'),
                    Divider(
                      height: 16,
                      color: Colors.white.withValues(alpha: 0.12),
                    ),
                    _buildReceiptRow(
                      'Jumlah Item',
                      '${widget.cartItems.length} produk',
                    ),
                    Divider(
                      height: 16,
                      color: Colors.white.withValues(alpha: 0.12),
                    ),
                    _buildReceiptRow(
                      'Total Pembayaran',
                      'Rp $totalAmount',
                      isBold: true,
                      color: const Color(0xFF38BDF8),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              const Center(
                child: Text(
                  'Terima kasih telah berbelanja di Toko CH!',
                  style: TextStyle(
                    fontSize: 12,
                    color: Color(0xFF94A3B8),
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            ],
          ),
          actions: [
            SizedBox(
              width: double.infinity,
              child: Container(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF6366F1), Color(0xFF06B6D4)],
                  ),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  onPressed: () {
                    widget.onClearCart();
                    Navigator.of(ctx).pop();
                    _nameController.clear();
                    _tableController.clear();
                  },
                  child: const Text(
                    'Selesai & Pesan Lagi',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildReceiptRow(
    String title,
    String value, {
    bool isBold = false,
    Color? color,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 13, color: Color(0xFF94A3B8)),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: isBold ? FontWeight.w900 : FontWeight.w600,
            color: color ?? Colors.white,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final int total = _calculateTotal();

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text(
          'Keranjang Belanja',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        actions: [
          if (widget.cartItems.isNotEmpty)
            GlassContainer(
              borderRadius: BorderRadius.circular(12),
              blur: 12,
              opacity: 0.14,
              borderColor: Colors.redAccent.withValues(alpha: 0.3),
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: TextButton.icon(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      backgroundColor:
                          const Color(0xFF151D30).withValues(alpha: 0.95),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: BorderSide(
                          color: Colors.white.withValues(alpha: 0.2),
                        ),
                      ),
                      title: const Text('Kosongkan Keranjang?'),
                      content: const Text(
                        'Semua produk di keranjang akan dihapus.',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(ctx),
                          child: const Text('Batal'),
                        ),
                        TextButton(
                          onPressed: () {
                            widget.onClearCart();
                            Navigator.pop(ctx);
                          },
                          child: const Text(
                            'Kosongkan',
                            style: TextStyle(color: Colors.redAccent),
                          ),
                        ),
                      ],
                    ),
                  );
                },
                icon: const Icon(
                  Icons.delete_sweep_outlined,
                  color: Colors.redAccent,
                  size: 18,
                ),
                label: const Text(
                  'Hapus Semua',
                  style: TextStyle(color: Colors.redAccent, fontSize: 12),
                ),
              ),
            ),
          const SizedBox(width: 14),
        ],
      ),
      body: widget.cartItems.isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GlassContainer(
                      width: 110,
                      height: 110,
                      borderRadius: BorderRadius.circular(55),
                      blur: 20,
                      opacity: 0.14,
                      borderColor: Colors.white.withValues(alpha: 0.2),
                      child: const Center(
                        child: Icon(
                          Icons.shopping_bag_outlined,
                          size: 52,
                          color: AppTheme.accent,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Keranjang Masih Kosong',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Belum ada casing keren yang dipilih.\nYuk pilih casing favoritmu di katalog Toko CH!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white.withValues(alpha: 0.65),
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            )
          : Column(
              children: [
                // List of cart items (Frosted Glass)
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                    physics: const BouncingScrollPhysics(),
                    itemCount: widget.cartItems.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final item = widget.cartItems[index];
                      return GlassContainer(
                        padding: const EdgeInsets.all(12),
                        borderRadius: BorderRadius.circular(20),
                        blur: 18,
                        opacity: 0.10,
                        borderColor: Colors.white.withValues(alpha: 0.18),
                        child: Row(
                          children: [
                            // Thumbnail
                            CaseImageWidget(
                              imageUrl: item.drink.imageUrl,
                              title: item.drink.name,
                              width: 65,
                              height: 75,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            const SizedBox(width: 14),
                            // Item Details
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.drink.name,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '${item.quantity} x Rp ${item.drink.price}',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Color(0xFF94A3B8),
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    'Rp ${item.drink.price * item.quantity}',
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w900,
                                      color: Color(0xFF38BDF8),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // Delete button in glass container
                            GlassContainer(
                              width: 36,
                              height: 36,
                              borderRadius: BorderRadius.circular(18),
                              blur: 10,
                              opacity: 0.14,
                              borderColor:
                                  Colors.redAccent.withValues(alpha: 0.3),
                              padding: EdgeInsets.zero,
                              child: IconButton(
                                icon: const Icon(
                                  Icons.delete_outline_rounded,
                                  color: Colors.redAccent,
                                  size: 18,
                                ),
                                tooltip: 'Hapus dari keranjang',
                                onPressed: () {
                                  widget.onRemoveFromCart(item.drink.id);
                                },
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),

                // Checkout Frosted Glass Panel
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
                  child: GlassContainer(
                    padding: const EdgeInsets.all(20),
                    borderRadius: BorderRadius.circular(28),
                    blur: 24,
                    opacity: 0.14,
                    borderColor: Colors.white.withValues(alpha: 0.22),
                    borderWidth: 1.2,
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Form(
                            key: _formKey,
                            child: Column(
                              children: [
                                TextFormField(
                                  controller: _nameController,
                                  style: const TextStyle(color: Colors.white),
                                  decoration: AppTheme.glassInputDecoration(
                                    labelText: 'Nama Pembeli',
                                    hintText: 'Nama lengkap Anda',
                                    prefixIcon:
                                        const Icon(Icons.person_outline),
                                  ),
                                  validator: (value) {
                                    if (value == null ||
                                        value.trim().isEmpty) {
                                      return 'Nama Pemesan tidak boleh kosong';
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 12),
                                TextFormField(
                                  controller: _tableController,
                                  keyboardType: TextInputType.number,
                                  style: const TextStyle(color: Colors.white),
                                  decoration: AppTheme.glassInputDecoration(
                                    labelText: 'Nomor Meja / Booth CH (1-20)',
                                    hintText: 'Contoh: 5',
                                    prefixIcon:
                                        const Icon(Icons.table_bar_outlined),
                                  ),
                                  validator: (value) {
                                    if (value == null ||
                                        value.trim().isEmpty) {
                                      return 'Nomor Meja tidak boleh kosong';
                                    }
                                    final int? meja =
                                        int.tryParse(value.trim());
                                    if (meja == null) {
                                      return 'Nomor Meja harus berupa angka';
                                    }
                                    if (meja < 1 || meja > 20) {
                                      return 'Nomor Meja harus antara 1-20';
                                    }
                                    return null;
                                  },
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Total Price Summary
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Total Pembayaran:',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFFCBD5E1),
                                ),
                              ),
                              Text(
                                'Rp $total',
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w900,
                                  color: Color(0xFF38BDF8),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),

                          // Checkout Button
                          Container(
                            height: 52,
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFF6366F1), Color(0xFF06B6D4)],
                              ),
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color:
                                      AppTheme.primary.withValues(alpha: 0.4),
                                  blurRadius: 14,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                shadowColor: Colors.transparent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  final String customerName =
                                      _nameController.text;
                                  final String tableNumber =
                                      _tableController.text;
                                  _showCheckoutDialog(
                                    context,
                                    total,
                                    customerName,
                                    tableNumber,
                                  );
                                }
                              },
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.shopping_bag_rounded,
                                    color: Colors.white,
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    'Proses Checkout Sekarang',
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
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
}
