import 'package:flutter/material.dart';
import '../models/drink.dart';
import '../utils/app_theme.dart';
import '../widgets/case_image_widget.dart';
import '../widgets/glass_container.dart';

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
  String _selectedModel = 'iPhone 15 Pro';
  String _selectedColor = 'Midnight Black';
  bool _isFavorite = false;

  final List<String> _models = [
    'iPhone 15 Pro',
    'iPhone 15',
    'iPhone 14 Pro',
    'Samsung S24 Ultra',
    'Samsung S23',
    'Xiaomi 14',
  ];

  final List<Map<String, dynamic>> _colors = [
    {'name': 'Midnight Black', 'color': const Color(0xFF1E293B)},
    {'name': 'Titanium Blue', 'color': const Color(0xFF2563EB)},
    {'name': 'Deep Purple', 'color': const Color(0xFF7C3AED)},
    {'name': 'Frost White', 'color': const Color(0xFFE2E8F0)},
  ];

  void _incrementQuantity() {
    setState(() {
      _quantity++;
    });
  }

  void _decrementQuantity() {
    setState(() {
      if (_quantity > 1) {
        _quantity--;
      }
    });
  }

  void _showSuccessDialog(BuildContext context, String caseName, int quantity) {
    showDialog(
      context: context,
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
          contentPadding: const EdgeInsets.fromLTRB(24, 28, 24, 20),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              GlassContainer(
                width: 70,
                height: 70,
                borderRadius: BorderRadius.circular(35),
                blur: 16,
                opacity: 0.2,
                borderColor: const Color(0xFF10B981).withValues(alpha: 0.4),
                child: const Icon(
                  Icons.check_circle_rounded,
                  color: Color(0xFF10B981),
                  size: 46,
                ),
              ),
              const SizedBox(height: 18),
              const Text(
                'Berhasil Ditambahkan!',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Kamu telah menambahkan $quantity x $caseName ($_selectedModel, $_selectedColor) ke keranjang belanja Toko CH.',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFFCBD5E1),
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF6366F1), Color(0xFF06B6D4)],
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    onPressed: () {
                      Navigator.of(ctx).pop();
                      Navigator.of(context).pop();
                    },
                    child: const Text(
                      'Lanjut Belanja',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final totalPrice = widget.drink.price * _quantity;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: GlassBackground(
        child: SafeArea(
          bottom: false,
          child: Column(
            children: [
              // Custom Glass Top App Bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GlassContainer(
                      width: 44,
                      height: 44,
                      borderRadius: BorderRadius.circular(14),
                      blur: 16,
                      opacity: 0.16,
                      borderColor: Colors.white.withValues(alpha: 0.22),
                      padding: EdgeInsets.zero,
                      child: IconButton(
                        icon: const Icon(
                          Icons.arrow_back_ios_new_rounded,
                          size: 18,
                          color: Colors.white,
                        ),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                    const Text(
                      'Detail Casing',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                    GlassContainer(
                      width: 44,
                      height: 44,
                      borderRadius: BorderRadius.circular(14),
                      blur: 16,
                      opacity: 0.16,
                      borderColor: Colors.white.withValues(alpha: 0.22),
                      padding: EdgeInsets.zero,
                      child: IconButton(
                        icon: Icon(
                          _isFavorite
                              ? Icons.favorite_rounded
                              : Icons.favorite_border_rounded,
                          color: _isFavorite
                              ? Colors.redAccent
                              : Colors.white,
                          size: 20,
                        ),
                        onPressed: () {
                          setState(() {
                            _isFavorite = !_isFavorite;
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                _isFavorite
                                    ? 'Disimpan ke wishlist!'
                                    : 'Dihapus dari wishlist',
                              ),
                              duration: const Duration(seconds: 1),
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),

              // Scrollable Body Content
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.only(bottom: 120),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Case Showcase in Frosted Glass Pedestal
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                        child: Hero(
                          tag: 'case_img_${widget.drink.id}',
                          child: GlassContainer(
                            height: 310,
                            width: double.infinity,
                            borderRadius: BorderRadius.circular(28),
                            blur: 24,
                            opacity: 0.12,
                            borderColor: Colors.white.withValues(alpha: 0.22),
                            borderWidth: 1.2,
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                CaseImageWidget(
                                  imageUrl: widget.drink.imageUrl,
                                  title: widget.drink.name,
                                  width: double.infinity,
                                  height: double.infinity,
                                  fit: BoxFit.contain,
                                ),
                                // Frosted Category Tag
                                Positioned(
                                  top: 16,
                                  left: 16,
                                  child: GlassContainer(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 6,
                                    ),
                                    borderRadius: BorderRadius.circular(20),
                                    blur: 12,
                                    opacity: 0.22,
                                    borderColor: Colors.white.withValues(alpha: 0.3),
                                    gradient: AppTheme.accentGradient,
                                    child: Text(
                                      widget.drink.category.toUpperCase(),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 11,
                                        letterSpacing: 0.8,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      // Product Details Glass Panel
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: GlassContainer(
                          borderRadius: BorderRadius.circular(28),
                          blur: 22,
                          opacity: 0.12,
                          borderColor: Colors.white.withValues(alpha: 0.2),
                          borderWidth: 1.2,
                          padding: const EdgeInsets.all(22),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Title and Rating
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Text(
                                      widget.drink.name,
                                      style: const TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                        height: 1.25,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  GlassContainer(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 6,
                                    ),
                                    borderRadius: BorderRadius.circular(12),
                                    blur: 12,
                                    opacity: 0.2,
                                    borderColor: Colors.amber.withValues(alpha: 0.4),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Icon(
                                          Icons.star_rounded,
                                          size: 18,
                                          color: Colors.amber,
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          widget.drink.rating.toStringAsFixed(1),
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),

                              // Price
                              Text(
                                'Rp ${widget.drink.price}',
                                style: const TextStyle(
                                  fontSize: 26,
                                  fontWeight: FontWeight.w900,
                                  color: Color(0xFF38BDF8),
                                ),
                              ),
                              const SizedBox(height: 20),

                              // Feature Badges (Glassmorphic)
                              Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children: [
                                  _buildFeatureBadge(
                                    Icons.shield_outlined,
                                    'Drop Tested 3M',
                                  ),
                                  _buildFeatureBadge(
                                    Icons.bolt_rounded,
                                    'MagSafe Ready',
                                  ),
                                  _buildFeatureBadge(
                                    Icons.pan_tool_outlined,
                                    'Anti-Slip Grip',
                                  ),
                                  _buildFeatureBadge(
                                    Icons.check_box_outlined,
                                    'Garansi Pas',
                                  ),
                                ],
                              ),
                              const SizedBox(height: 24),

                              // Deskripsi
                              const Text(
                                'Deskripsi Produk',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                widget.drink.description,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Color(0xFFCBD5E1),
                                  height: 1.5,
                                ),
                              ),
                              const SizedBox(height: 24),

                              // Tipe / Model Smartphone Selector
                              const Text(
                                'Pilih Model Smartphone',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 12),
                              SizedBox(
                                height: 40,
                                child: ListView.separated(
                                  scrollDirection: Axis.horizontal,
                                  physics: const BouncingScrollPhysics(),
                                  itemCount: _models.length,
                                  separatorBuilder: (context, index) =>
                                      const SizedBox(width: 8),
                                  itemBuilder: (context, index) {
                                    final model = _models[index];
                                    final isSelected = _selectedModel == model;
                                    return GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          _selectedModel = model;
                                        });
                                      },
                                      child: AnimatedContainer(
                                        duration:
                                            const Duration(milliseconds: 220),
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 16,
                                          vertical: 8,
                                        ),
                                        decoration: BoxDecoration(
                                          gradient: isSelected
                                              ? const LinearGradient(
                                                  colors: [
                                                    Color(0xFF6366F1),
                                                    Color(0xFF06B6D4)
                                                  ],
                                                )
                                              : null,
                                          color: isSelected
                                              ? null
                                              : Colors.white.withValues(
                                                  alpha: 0.08,
                                                ),
                                          borderRadius:
                                              BorderRadius.circular(16),
                                          border: Border.all(
                                            color: isSelected
                                                ? Colors.white.withValues(
                                                    alpha: 0.35,
                                                  )
                                                : Colors.white.withValues(
                                                    alpha: 0.15,
                                                  ),
                                            width: 1.2,
                                          ),
                                        ),
                                        child: Center(
                                          child: Text(
                                            model,
                                            style: TextStyle(
                                              color: isSelected
                                                  ? Colors.white
                                                  : const Color(0xFFCBD5E1),
                                              fontWeight: isSelected
                                                  ? FontWeight.bold
                                                  : FontWeight.w500,
                                              fontSize: 13,
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                              const SizedBox(height: 24),

                              // Color Variant Picker
                              const Text(
                                'Pilihan Warna Casing',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Row(
                                children: _colors.map((c) {
                                  final isSelected =
                                      _selectedColor == c['name'];
                                  return GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _selectedColor = c['name'] as String;
                                      });
                                    },
                                    child: Container(
                                      margin: const EdgeInsets.only(right: 14),
                                      padding: const EdgeInsets.all(3),
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: isSelected
                                              ? AppTheme.accent
                                              : Colors.transparent,
                                          width: 2.2,
                                        ),
                                      ),
                                      child: Container(
                                        width: 36,
                                        height: 36,
                                        decoration: BoxDecoration(
                                          color: c['color'] as Color,
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: Colors.white.withValues(
                                              alpha: 0.3,
                                            ),
                                            width: 1.2,
                                          ),
                                        ),
                                        child: isSelected
                                            ? const Icon(
                                                Icons.check,
                                                size: 18,
                                                color: Colors.white,
                                              )
                                            : null,
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ],
                          ),
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

      // Sticky Floating Frosted Bottom Bar
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
          child: GlassContainer(
            borderRadius: BorderRadius.circular(24),
            blur: 24,
            opacity: 0.16,
            borderColor: Colors.white.withValues(alpha: 0.22),
            borderWidth: 1.2,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                // Quantity Stepper (Frosted Glass)
                GlassContainer(
                  borderRadius: BorderRadius.circular(16),
                  blur: 14,
                  opacity: 0.14,
                  borderColor: Colors.white.withValues(alpha: 0.18),
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove_rounded, size: 20),
                        onPressed: _decrementQuantity,
                        color: Colors.white,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 6),
                        child: Text(
                          '$_quantity',
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.add_rounded, size: 20),
                        onPressed: _incrementQuantity,
                        color: AppTheme.accent,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 14),

                // Add To Cart Button
                Expanded(
                  child: Container(
                    height: 52,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF6366F1), Color(0xFF06B6D4)],
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.primary.withValues(alpha: 0.4),
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
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                      ),
                      onPressed: () {
                        widget.onAddToCart(widget.drink, _quantity);
                        _showSuccessDialog(
                          context,
                          widget.drink.name,
                          _quantity,
                        );
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.shopping_bag_outlined,
                            color: Colors.white,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Flexible(
                            child: Text(
                              '+ Keranjang (Rp $totalPrice)',
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
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
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureBadge(IconData icon, String text) {
    return GlassContainer(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      borderRadius: BorderRadius.circular(10),
      blur: 10,
      opacity: 0.12,
      borderColor: Colors.white.withValues(alpha: 0.16),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: AppTheme.accent),
          const SizedBox(width: 6),
          Text(
            text,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Color(0xFFCBD5E1),
            ),
          ),
        ],
      ),
    );
  }
}
