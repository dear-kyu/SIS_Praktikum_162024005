import 'package:flutter/material.dart';

import '../models/drink.dart';

class AddProductPage extends StatefulWidget {
  final Function(Drink) onSave;

  const AddProductPage({Key? key, required this.onSave}) : super(key: key);

  @override
  State<AddProductPage> createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _imageUrlController = TextEditingController();

  static const Color cream = Color(0xFFFFF7F5);
  static const Color creamWhite = Color(0xFFFFFCFA);
  static const Color teaRed = Color(0xFFAA382B);
  static const Color brown = Color(0xFF725A52);
  static const Color mutedBrown = Color(0xFF9A8178);
  static const Color softBorder = Color(0xFFF0DFDA);

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  InputDecoration _inputDecoration({
    required String label,
    required IconData icon,
    String? hint,
    String? prefixText,
  }) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      prefixText: prefixText,
      prefixIcon: Icon(icon, color: teaRed, size: 21),
      labelStyle: const TextStyle(color: mutedBrown),
      hintStyle: const TextStyle(color: Color(0xFFB9A7A0), fontSize: 13),
      filled: true,
      fillColor: creamWhite,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(color: softBorder),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(color: softBorder),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(color: teaRed, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(color: Colors.redAccent),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(color: Colors.redAccent, width: 1.5),
      ),
    );
  }

  void _submitForm() {
    FocusScope.of(context).unfocus();

    if (_formKey.currentState!.validate()) {
      final name = _nameController.text.trim();
      final price = int.parse(_priceController.text.trim());
      final imageUrl = _imageUrlController.text.trim();

      final newDrink = Drink(
        id: DateTime.now().toString(),
        name: name,
        price: price,
        imageUrl: imageUrl,
      );

      widget.onSave(newDrink);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Produk berhasil ditambahkan!'),
          backgroundColor: teaRed,
          behavior: SnackBarBehavior.floating,
        ),
      );

      Navigator.of(context).pop();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Validasi Gagal! Silakan perbaiki error di form.'),
          backgroundColor: teaRed,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
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
        title: const Text(
          'Tambah Produk Baru',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: brown,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(22),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: _nameController,
                  textCapitalization: TextCapitalization.words,
                  decoration: _inputDecoration(
                    label: 'Nama Produk',
                    icon: Icons.fastfood_outlined,
                  ),
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
                const SizedBox(height: 18),
                TextFormField(
                  controller: _priceController,
                  decoration: _inputDecoration(
                    label: 'Harga',
                    icon: Icons.price_change_outlined,
                    prefixText: 'Rp ',
                  ),
                  keyboardType: TextInputType.number,
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
                const SizedBox(height: 18),
                TextFormField(
                  controller: _imageUrlController,
                  decoration: _inputDecoration(
                    label: 'Path Aset Gambar',
                    icon: Icons.image_outlined,
                    hint: 'Contoh: assets/espresso.jpg',
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Path gambar tidak boleh kosong.';
                    }

                    final path = value.trim().toLowerCase();

                    if (!path.startsWith('assets/')) {
                      return "Path harus dimulai dengan 'assets/'.";
                    }

                    if (!path.endsWith('.png') &&
                        !path.endsWith('.jpg') &&
                        !path.endsWith('.jpeg')) {
                      return 'Path harus berupa file gambar (.png, .jpg, .jpeg).';
                    }

                    return null;
                  },
                ),
                const SizedBox(height: 26),
                SizedBox(
                  height: 54,
                  child: ElevatedButton(
                    onPressed: _submitForm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: teaRed,
                      foregroundColor: Colors.white,
                      elevation: 2,
                      shadowColor: teaRed.withOpacity(0.2),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      textStyle: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    child: const Text('Simpan'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
