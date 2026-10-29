import 'package:flutter/material.dart';

import '../models/drink.dart';
import 'drink_detail_page.dart';

class HomePage extends StatefulWidget {
  final List<Drink> drinkList;
  final Function(Drink, int) onAddToCart;
  final VoidCallback onAdd;
  final void Function(Drink) onEdit;
  final void Function(String) onDelete;

  const HomePage({
    Key? key,
    required this.drinkList,
    required this.onAddToCart,
    required this.onAdd,
    required this.onEdit,
    required this.onDelete,
  }) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String searchText = '';

  static const Color cream = Color(0xFFFFF9F5);
  static const Color brown = Color(0xFF705750);
  static const Color lavender = Color(0xFF8B70B8);
  static const Color blush = Color(0xFFF4DFE1);

  void _showQuickAddDialog(String foodName) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$foodName ditambahkan ke keranjang ♡'),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        backgroundColor: brown,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }

  void _showDeleteDialog(Drink drink) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: cream,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: const Text(
          'Hapus produk?',
          style: TextStyle(color: brown, fontWeight: FontWeight.bold),
        ),
        content: Text(
          'Yakin ingin menghapus ${drink.name}?',
          style: const TextStyle(color: brown),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Batal', style: TextStyle(color: brown)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFE9BFC5),
              foregroundColor: brown,
              elevation: 0,
            ),
            onPressed: () {
              widget.onDelete(drink.id);
              Navigator.pop(ctx);
            },
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filteredList = widget.drinkList
        .where(
          (drink) =>
              drink.name.toLowerCase().contains(searchText.toLowerCase()),
        )
        .toList();

    return Scaffold(
      backgroundColor: cream,
      appBar: AppBar(
        backgroundColor: cream,
        foregroundColor: brown,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Mofusand Market',
          style: TextStyle(
            fontSize: 21,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.2,
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 18),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  searchText = value;
                });
              },
              decoration: InputDecoration(
                hintText: 'Cari Mofusand kesukaanmu...',
                hintStyle: const TextStyle(
                  color: Color(0xFFB6A29C),
                  fontSize: 14,
                ),
                prefixIcon: const Icon(Icons.search_rounded, color: lavender),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(vertical: 15),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(18),
                  borderSide: const BorderSide(color: blush),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(18),
                  borderSide: const BorderSide(color: blush),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(18),
                  borderSide: const BorderSide(color: lavender, width: 1.4),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
            child: Row(
              children: [
                const Icon(Icons.pets_rounded, color: lavender, size: 21),
                const SizedBox(width: 8),
                const Expanded(
                  child: Text(
                    'Little Mofusand Collection',
                    style: TextStyle(
                      color: brown,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                ),
                Text(
                  '${filteredList.length} items',
                  style: const TextStyle(
                    color: Color(0xFFB09B94),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: filteredList.isEmpty
                ? const Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.pets_rounded,
                          color: Color(0xFFD8C5D9),
                          size: 55,
                        ),
                        SizedBox(height: 12),
                        Text(
                          'Mofusand-nya belum ditemukan ♡',
                          style: TextStyle(color: brown),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
                    itemCount: filteredList.length,
                    itemBuilder: (context, index) {
                      final drink = filteredList[index];

                      return Container(
                        margin: const EdgeInsets.only(bottom: 14),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(22),
                          border: Border.all(color: const Color(0xFFF0DFDF)),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF9B7770).withOpacity(0.06),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(22),
                          onTap: () {
                            widget.onAddToCart(drink, 1);
                            _showQuickAddDialog(drink.name);
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(13),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Image.asset(
                                      drink.imageUrl,
                                      width: 76,
                                      height: 82,
                                      fit: BoxFit.contain,
                                      errorBuilder: (ctx, err, stack) =>
                                          const Icon(
                                            Icons.image_not_supported_outlined,
                                            color: Color(0xFFC6B5B0),
                                            size: 30,
                                          ),
                                    ),
                                    const SizedBox(width: 14),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            drink.name,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                              color: brown,
                                              fontSize: 15,
                                              height: 1.35,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          Text(
                                            'Rp ${drink.price}',
                                            style: const TextStyle(
                                              color: Color(0xFF63966B),
                                              fontWeight: FontWeight.w600,
                                              fontSize: 14,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                const Divider(
                                  height: 1,
                                  color: Color(0xFFF4E9E6),
                                ),
                                const SizedBox(height: 5),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    _ActionButton(
                                      icon: Icons.info_outline_rounded,
                                      label: 'Detail',
                                      color: lavender,
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                DrinkDetailPage(
                                                  drink: drink,
                                                  onAddToCart:
                                                      widget.onAddToCart,
                                                ),
                                          ),
                                        );
                                      },
                                    ),
                                    const SizedBox(width: 8),
                                    _ActionButton(
                                      icon: Icons.edit_outlined,
                                      label: 'Edit',
                                      color: const Color(0xFF6D9DD1),
                                      onPressed: () => widget.onEdit(drink),
                                    ),
                                    const SizedBox(width: 8),
                                    _ActionButton(
                                      icon: Icons.delete_outline_rounded,
                                      label: 'Hapus',
                                      color: const Color(0xFFD77D85),
                                      onPressed: () => _showDeleteDialog(drink),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: widget.onAdd,
        tooltip: 'Tambah Produk',
        backgroundColor: const Color(0xFFE9DDFB),
        foregroundColor: lavender,
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: const Icon(Icons.add_rounded, size: 29),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onPressed;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        foregroundColor: color,
        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
        minimumSize: const Size(0, 34),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        visualDensity: VisualDensity.compact,
      ),
      icon: Icon(icon, size: 17),
      label: Text(
        label,
        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
      ),
    );
  }
}
