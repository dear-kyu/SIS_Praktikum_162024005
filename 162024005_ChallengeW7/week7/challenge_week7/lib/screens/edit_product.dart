import 'package:flutter/material.dart';
import '../models/drink.dart';
import '../utils/app_theme.dart';
import '../widgets/case_image_widget.dart';
import '../widgets/glass_container.dart';

class EditProductPage extends StatefulWidget {
  final Function(Drink) onSave;
  final Drink existingDrink;

  const EditProductPage({
    super.key,
    required this.onSave,
    required this.existingDrink,
  });

  @override
  State<EditProductPage> createState() => _EditProductPageState();
}

class _EditProductPageState extends State<EditProductPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _priceController;
  late TextEditingController _imageUrlController;
  late String _selectedCategory;

  final List<String> _categories = [
    'Silicone',
    'MagSafe',
    'Aesthetic',
    'Armor',
    'Leather',
    'Mecha',
  ];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.existingDrink.name);
    _priceController =
        TextEditingController(text: widget.existingDrink.price.toString());
    _imageUrlController =
        TextEditingController(text: widget.existingDrink.imageUrl);
    _selectedCategory = _categories.contains(widget.existingDrink.category)
        ? widget.existingDrink.category
        : 'Silicone';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final name = _nameController.text.trim();
      final price = int.parse(_priceController.text.trim());
      final imageUrl = _imageUrlController.text.trim();

      final updatedDrink = widget.existingDrink.copyWith(
        name: name,
        price: price,
        imageUrl: imageUrl,
        category: _selectedCategory,
      );

      widget.onSave(updatedDrink);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.check_circle_outline, color: Colors.white),
              const SizedBox(width: 8),
              Expanded(
                child: Text('Casing "$name" berhasil diperbarui!'),
              ),
            ],
          ),
          backgroundColor: const Color(0xFF10B981),
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          margin: const EdgeInsets.all(16),
        ),
      );

      Navigator.of(context).pop();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:
              const Text('Validasi Gagal! Silakan periksa kolom formulir.'),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          margin: const EdgeInsets.all(16),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: GlassBackground(
        child: SafeArea(
          child: Column(
            children: [
              // Top Glass Bar
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
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
                    const SizedBox(width: 14),
                    const Text(
                      'Edit Casing HP',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),

              // Form Body
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20.0),
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Live Preview Frosted Card
                      GlassContainer(
                        padding: const EdgeInsets.all(16),
                        borderRadius: BorderRadius.circular(22),
                        blur: 20,
                        opacity: 0.12,
                        borderColor: Colors.white.withValues(alpha: 0.2),
                        child: Row(
                          children: [
                            CaseImageWidget(
                              imageUrl: _imageUrlController.text,
                              title: _nameController.text.isEmpty
                                  ? 'Casing Baru'
                                  : _nameController.text,
                              width: 75,
                              height: 85,
                              borderRadius: BorderRadius.circular(14),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  GlassContainer(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 3,
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                    blur: 8,
                                    opacity: 0.16,
                                    borderColor:
                                        Colors.white.withValues(alpha: 0.2),
                                    child: Text(
                                      _selectedCategory.toUpperCase(),
                                      style: const TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                        color: AppTheme.accent,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    _nameController.text.isEmpty
                                        ? 'Nama Casing HP'
                                        : _nameController.text,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    _priceController.text.isEmpty
                                        ? 'Rp 0'
                                        : 'Rp ${_priceController.text}',
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w900,
                                      color: Color(0xFF38BDF8),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Form Input Card in Frosted Glass
                      GlassContainer(
                        padding: const EdgeInsets.all(22),
                        borderRadius: BorderRadius.circular(26),
                        blur: 22,
                        opacity: 0.12,
                        borderColor: Colors.white.withValues(alpha: 0.2),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              // Nama Produk
                              TextFormField(
                                controller: _nameController,
                                style: const TextStyle(color: Colors.white),
                                decoration: AppTheme.glassInputDecoration(
                                  labelText: 'Nama Casing / Produk',
                                  prefixIcon:
                                      const Icon(Icons.phone_android_rounded),
                                ),
                                onChanged: (val) => setState(() {}),
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return 'Nama produk tidak boleh kosong.';
                                  }
                                  if (value.trim().length < 3) {
                                    return 'Nama produk minimal 3 karakter.';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 16),

                              // Kategori Dropdown
                              DropdownButtonFormField<String>(
                                initialValue: _selectedCategory,
                                dropdownColor: const Color(0xFF151D30),
                                style: const TextStyle(color: Colors.white),
                                decoration: AppTheme.glassInputDecoration(
                                  labelText: 'Kategori Casing',
                                  prefixIcon:
                                      const Icon(Icons.category_outlined),
                                ),
                                items: _categories.map((cat) {
                                  return DropdownMenuItem<String>(
                                    value: cat,
                                    child: Text(
                                      cat,
                                      style:
                                          const TextStyle(color: Colors.white),
                                    ),
                                  );
                                }).toList(),
                                onChanged: (val) {
                                  if (val != null) {
                                    setState(() {
                                      _selectedCategory = val;
                                    });
                                  }
                                },
                              ),
                              const SizedBox(height: 16),

                              // Harga
                              TextFormField(
                                controller: _priceController,
                                keyboardType: TextInputType.number,
                                style: const TextStyle(color: Colors.white),
                                decoration: AppTheme.glassInputDecoration(
                                  labelText: 'Harga',
                                  prefixIcon:
                                      const Icon(Icons.payments_outlined),
                                ),
                                onChanged: (val) => setState(() {}),
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return 'Harga tidak boleh kosong.';
                                  }
                                  final price = int.tryParse(value.trim());
                                  if (price == null) {
                                    return 'Masukkan harga dalam bentuk angka.';
                                  }
                                  if (price <= 0) {
                                    return 'Harga harus lebih dari 0.';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 16),

                              // Image Path
                              TextFormField(
                                controller: _imageUrlController,
                                style: const TextStyle(color: Colors.white),
                                decoration: AppTheme.glassInputDecoration(
                                  labelText: 'Path Aset / URL Gambar',
                                  prefixIcon: const Icon(Icons.image_outlined),
                                ),
                                onChanged: (val) => setState(() {}),
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return 'Path gambar tidak boleh kosong.';
                                  }
                                  final trimmed = value.trim();
                                  final isAsset = trimmed.startsWith('assets/');
                                  final isWeb = trimmed.startsWith('http://') ||
                                      trimmed.startsWith('https://');
                                  if (!isAsset && !isWeb) {
                                    return "Path harus dimulai dengan 'assets/' atau URL web.";
                                  }
                                  if (isAsset &&
                                      !trimmed.endsWith('.png') &&
                                      !trimmed.endsWith('.jpg') &&
                                      !trimmed.endsWith('.jpeg')) {
                                    return 'Path harus berupa file gambar (.png, .jpg, .jpeg).';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 26),

                              // Submit Button
                              Container(
                                height: 54,
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [
                                      Color(0xFF6366F1),
                                      Color(0xFF06B6D4)
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(16),
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppTheme.primary
                                          .withValues(alpha: 0.4),
                                      blurRadius: 16,
                                      offset: const Offset(0, 6),
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
                                  onPressed: _submitForm,
                                  child: const Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.check_rounded,
                                        color: Colors.white,
                                      ),
                                      SizedBox(width: 8),
                                      Text(
                                        'Simpan Perubahan',
                                        style: TextStyle(
                                          fontSize: 16,
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
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
