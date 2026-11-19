import 'package:flutter/material.dart';
import '../models/drink.dart';
import '../utils/app_theme.dart';
import '../utils/page_transitions.dart';
import '../widgets/case_image_widget.dart';
import '../widgets/glass_container.dart';
import 'drink_detail_page.dart';

class HomePage extends StatefulWidget {
  final List<Drink> drinkList;
  final Function(Drink, int) onAddToCart;
  final VoidCallback onAdd;
  final Function(Drink) onEdit;
  final Function(String) onDelete;

  const HomePage({
    super.key,
    required this.drinkList,
    required this.onAddToCart,
    required this.onAdd,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _searchText = '';
  String _selectedCategory = 'Semua';
  bool _isGridView = true;
  final TextEditingController _searchController = TextEditingController();

  final List<String> _categories = [
    'Semua',
    'MagSafe',
    'Silicone',
    'Aesthetic',
    'Armor',
    'Leather',
    'Mecha',
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _showQuickAddDialog(String caseName) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle_outline, color: Colors.white, size: 20),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                '$caseName ditambahkan ke keranjang!',
                style: const TextStyle(fontWeight: FontWeight.w600),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        duration: const Duration(seconds: 2),
        backgroundColor: const Color(0xFF10B981),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  void _confirmDelete(BuildContext context, Drink drink) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF151D30).withValues(alpha: 0.95),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: BorderSide(
            color: Colors.white.withValues(alpha: 0.2),
            width: 1.2,
          ),
        ),
        title: const Row(
          children: [
            Icon(Icons.delete_outline_rounded, color: Colors.redAccent),
            SizedBox(width: 8),
            Text(
              'Hapus Casing',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        content: Text(
          'Apakah Anda yakin ingin menghapus "${drink.name}" dari katalog Toko CH?',
          style: const TextStyle(color: Color(0xFFCBD5E1)),
        ),
        actions: [
          TextButton(
            child: const Text('Batal', style: TextStyle(color: Color(0xFF94A3B8))),
            onPressed: () => Navigator.of(ctx).pop(),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFEF4444),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
            ),
            child: const Text('Hapus'),
            onPressed: () {
              widget.onDelete(drink.id);
              Navigator.of(ctx).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${drink.name} telah dihapus.'),
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filteredList = widget.drinkList.where((drink) {
      final matchesSearch = drink.name.toLowerCase().contains(_searchText.toLowerCase()) ||
          drink.description.toLowerCase().contains(_searchText.toLowerCase()) ||
          drink.category.toLowerCase().contains(_searchText.toLowerCase());
      final matchesCategory = _selectedCategory == 'Semua' ||
          drink.category.toLowerCase() == _selectedCategory.toLowerCase();
      return matchesSearch && matchesCategory;
    }).toList();

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        titleSpacing: 20,
        title: Row(
          children: [
            GlassContainer(
              padding: const EdgeInsets.all(8),
              borderRadius: BorderRadius.circular(12),
              blur: 16,
              opacity: 0.16,
              borderColor: Colors.white.withValues(alpha: 0.25),
              gradient: AppTheme.accentGradient,
              child: const Icon(Icons.phone_iphone_rounded, color: Colors.white, size: 20),
            ),
            const SizedBox(width: 10),
            RichText(
              text: const TextSpan(
                text: 'TOKO ',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  letterSpacing: 0.5,
                ),
                children: [
                  TextSpan(
                    text: 'CH',
                    style: TextStyle(
                      color: AppTheme.accent,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          GlassContainer(
            borderRadius: BorderRadius.circular(12),
            blur: 12,
            opacity: 0.14,
            borderColor: Colors.white.withValues(alpha: 0.22),
            padding: EdgeInsets.zero,
            child: IconButton(
              tooltip: 'Tambah Casing',
              icon: const Icon(
                Icons.add_rounded,
                color: Color(0xFF38BDF8),
                size: 22,
              ),
              onPressed: widget.onAdd,
            ),
          ),
          const SizedBox(width: 8),
          GlassContainer(
            borderRadius: BorderRadius.circular(12),
            blur: 12,
            opacity: 0.12,
            borderColor: Colors.white.withValues(alpha: 0.18),
            padding: EdgeInsets.zero,
            child: IconButton(
              tooltip: _isGridView ? 'Tampilan List' : 'Tampilan Grid',
              icon: Icon(
                _isGridView ? Icons.view_list_rounded : Icons.grid_view_rounded,
                color: Colors.white,
                size: 20,
              ),
              onPressed: () {
                setState(() {
                  _isGridView = !_isGridView;
                });
              },
            ),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // Banner Promo Toko CH (Glassmorphic)
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 10),
              child: GlassContainer(
                borderRadius: BorderRadius.circular(24),
                blur: 24,
                opacity: 0.15,
                borderColor: Colors.white.withValues(alpha: 0.25),
                borderWidth: 1.2,
                padding: const EdgeInsets.all(20),
                gradient: LinearGradient(
                  colors: [
                    const Color(0xFF4F46E5).withValues(alpha: 0.55),
                    const Color(0xFF7C3AED).withValues(alpha: 0.40),
                    const Color(0xFF06B6D4).withValues(alpha: 0.35),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF4F46E5).withValues(alpha: 0.3),
                    blurRadius: 24,
                    offset: const Offset(0, 8),
                  ),
                ],
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          GlassContainer(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            borderRadius: BorderRadius.circular(20),
                            blur: 10,
                            opacity: 0.2,
                            borderColor: Colors.white.withValues(alpha: 0.3),
                            child: const Text(
                              '🔥 PROMO SPESIAL TOKO CH',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            'Diskon Hingga 30%\nKoleksi Case Terbaru!',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              height: 1.25,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Perlindungan maksimal & style terbaik untuk HP kamu.',
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.8),
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    GlassContainer(
                      width: 72,
                      height: 72,
                      borderRadius: BorderRadius.circular(36),
                      blur: 16,
                      opacity: 0.2,
                      borderColor: Colors.white.withValues(alpha: 0.35),
                      child: const Center(
                        child: Icon(
                          Icons.cases_rounded,
                          size: 38,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Search Field in Glass
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              child: GlassContainer(
                borderRadius: BorderRadius.circular(18),
                blur: 18,
                opacity: 0.10,
                borderColor: Colors.white.withValues(alpha: 0.18),
                child: TextField(
                  controller: _searchController,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Cari tipe casing, material, atau model HP...',
                    hintStyle: const TextStyle(fontSize: 13, color: Color(0xFF94A3B8)),
                    prefixIcon: const Icon(Icons.search, color: Color(0xFF94A3B8)),
                    suffixIcon: _searchText.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear, color: Color(0xFF94A3B8)),
                            onPressed: () {
                              _searchController.clear();
                              setState(() {
                                _searchText = '';
                              });
                            },
                          )
                        : null,
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  ),
                  onChanged: (val) {
                    setState(() {
                      _searchText = val;
                    });
                  },
                ),
              ),
            ),
          ),

          // Horizontal Category Filter Pills (Glassmorphic)
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: SizedBox(
                height: 40,
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  itemCount: _categories.length,
                  separatorBuilder: (context, index) => const SizedBox(width: 8),
                  itemBuilder: (context, index) {
                    final cat = _categories[index];
                    final isSelected = _selectedCategory == cat;
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedCategory = cat;
                        });
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                        decoration: BoxDecoration(
                          gradient: isSelected
                              ? const LinearGradient(
                                  colors: [Color(0xFF6366F1), Color(0xFF06B6D4)],
                                )
                              : null,
                          color: isSelected ? null : Colors.white.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: isSelected
                                ? Colors.white.withValues(alpha: 0.35)
                                : Colors.white.withValues(alpha: 0.14),
                            width: 1.2,
                          ),
                          boxShadow: isSelected
                              ? [
                                  BoxShadow(
                                    color: AppTheme.primary.withValues(alpha: 0.4),
                                    blurRadius: 10,
                                    offset: const Offset(0, 3),
                                  ),
                                ]
                              : null,
                        ),
                        child: Center(
                          child: Text(
                            cat,
                            style: TextStyle(
                              color: isSelected ? Colors.white : const Color(0xFFCBD5E1),
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),

          // Results count
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(18, 6, 18, 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Koleksi Casing (${filteredList.length})',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                  if (_searchText.isNotEmpty || _selectedCategory != 'Semua')
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _searchText = '';
                          _selectedCategory = 'Semua';
                          _searchController.clear();
                        });
                      },
                      child: const Text(
                        'Reset Filter',
                        style: TextStyle(
                          color: AppTheme.accent,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),

          // Empty state
          if (filteredList.isEmpty)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(40.0),
                child: Center(
                  child: Column(
                    children: [
                      GlassContainer(
                        padding: const EdgeInsets.all(22),
                        borderRadius: BorderRadius.circular(40),
                        blur: 16,
                        opacity: 0.12,
                        child: const Icon(
                          Icons.search_off_rounded,
                          size: 48,
                          color: Color(0xFF94A3B8),
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Casing tidak ditemukan',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        'Coba cari dengan kata kunci lain atau reset filter kategori.',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Color(0xFF94A3B8), fontSize: 13),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _searchText = '';
                            _selectedCategory = 'Semua';
                            _searchController.clear();
                          });
                        },
                        child: const Text('Lihat Semua Casing'),
                      ),
                    ],
                  ),
                ),
              ),
            )
          // Grid View
          else if (_isGridView)
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.63,
                  crossAxisSpacing: 14,
                  mainAxisSpacing: 14,
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final drink = filteredList[index];
                    return _buildGridCard(context, drink);
                  },
                  childCount: filteredList.length,
                ),
              ),
            )
          // List View
          else
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final drink = filteredList[index];
                    return _buildListCard(context, drink);
                  },
                  childCount: filteredList.length,
                ),
              ),
            ),

          const SliverToBoxAdapter(child: SizedBox(height: 160)),
        ],
      ),
    );
  }

  // Frosted Glass Grid Card
  Widget _buildGridCard(BuildContext context, Drink drink) {
    return GlassCard(
      borderRadius: BorderRadius.circular(22),
      blur: 20,
      opacity: 0.10,
      borderColor: Colors.white.withValues(alpha: 0.18),
      borderWidth: 1.1,
      onTap: () {
        Navigator.push(
          context,
          AppPageRoute.slideHorizontal(
            DrinkDetailPage(
              drink: drink,
              onAddToCart: widget.onAddToCart,
            ),
          ),
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Case Image Showcase with Hero
          Stack(
            children: [
              Hero(
                tag: 'case_img_${drink.id}',
                child: CaseImageWidget(
                  imageUrl: drink.imageUrl,
                  title: drink.name,
                  height: 145,
                  width: double.infinity,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(22)),
                ),
              ),
              // Frosted Rating Badge
              Positioned(
                top: 10,
                left: 10,
                child: GlassContainer(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  borderRadius: BorderRadius.circular(12),
                  blur: 14,
                  opacity: 0.22,
                  borderColor: Colors.white.withValues(alpha: 0.3),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.edit_outlined, size: 14, color: Colors.amber),
                      const SizedBox(width: 3),
                      Text(
                        drink.rating.toStringAsFixed(1),
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Frosted More Menu (Edit / Delete)
              Positioned(
                top: 6,
                right: 6,
                child: PopupMenuButton<String>(
                  color: const Color(0xFF151D30).withValues(alpha: 0.95),
                  icon: GlassContainer(
                    width: 30,
                    height: 30,
                    borderRadius: BorderRadius.circular(15),
                    blur: 14,
                    opacity: 0.2,
                    borderColor: Colors.white.withValues(alpha: 0.25),
                    padding: EdgeInsets.zero,
                    child: const Center(
                      child: Icon(Icons.more_vert, size: 16, color: Colors.white),
                    ),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: BorderSide(
                      color: Colors.white.withValues(alpha: 0.2),
                      width: 1,
                    ),
                  ),
                  onSelected: (value) {
                    if (value == 'edit') {
                      widget.onEdit(drink);
                    } else if (value == 'delete') {
                      _confirmDelete(context, drink);
                    }
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 'edit',
                      child: Row(
                        children: [
                          Icon(Icons.add_shopping_cart_rounded, size: 18, color: Color(0xFF818CF8)),
                          SizedBox(width: 8),
                          Text('Edit Casing', style: TextStyle(color: Colors.white)),
                        ],
                      ),
                    ),
                    const PopupMenuItem(
                      value: 'delete',
                      child: Row(
                        children: [
                          Icon(Icons.add_shopping_cart_rounded, size: 18, color: Colors.redAccent),
                          SizedBox(width: 8),
                          Text('Hapus', style: TextStyle(color: Colors.redAccent)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          // Product Info
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Category chip
                Text(
                  drink.category.toUpperCase(),
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.accent,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 4),
                // Product Title
                Text(
                  drink.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    height: 1.25,
                  ),
                ),
                const SizedBox(height: 8),
                // Price & Add Button Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        'Rp ${drink.price}',
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w900,
                          color: Color(0xFF38BDF8),
                        ),
                      ),
                    ),
                    // Quick Add Button in Glass Accent
                    GestureDetector(
                      onTap: () {
                        widget.onAddToCart(drink, 1);
                        _showQuickAddDialog(drink.name);
                      },
                      child: Container(
                        padding: const EdgeInsets.all(7),
                        decoration: BoxDecoration(
                          gradient: AppTheme.accentGradient,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: AppTheme.primary.withValues(alpha: 0.35),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.add_shopping_cart_rounded,
                          size: 16,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Frosted Glass List Card
  Widget _buildListCard(BuildContext context, Drink drink) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: GlassCard(
        borderRadius: BorderRadius.circular(20),
        blur: 18,
        opacity: 0.10,
        borderColor: Colors.white.withValues(alpha: 0.18),
        borderWidth: 1.1,
        padding: const EdgeInsets.all(12),
        onTap: () {
          Navigator.push(
            context,
            AppPageRoute.slideHorizontal(
              DrinkDetailPage(
                drink: drink,
                onAddToCart: widget.onAddToCart,
              ),
            ),
          );
        },
        child: Row(
          children: [
            Hero(
              tag: 'case_img_${drink.id}',
              child: CaseImageWidget(
                imageUrl: drink.imageUrl,
                title: drink.name,
                width: 75,
                height: 85,
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GlassContainer(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    borderRadius: BorderRadius.circular(8),
                    blur: 8,
                    opacity: 0.16,
                    borderColor: Colors.white.withValues(alpha: 0.2),
                    child: Text(
                      drink.category.toUpperCase(),
                      style: const TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.accent,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    drink.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Rp ${drink.price}',
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF38BDF8),
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.edit_outlined, color: Color(0xFF818CF8)),
              onPressed: () => widget.onEdit(drink),
            ),
            IconButton(
              icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
              onPressed: () => _confirmDelete(context, drink),
            ),
          ],
        ),
      ),
    );
  }
}
