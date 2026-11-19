import 'package:flutter/material.dart';

import '../models/post.dart';
import '../repositories/post_repository.dart';
import '../utils/app_theme.dart';
import '../widgets/glass_container.dart';

class PostPage extends StatefulWidget {
  const PostPage({super.key});

  @override
  State<PostPage> createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  final PostRepository _repository = PostRepository();

  List<Post> _posts = [];
  List<Post> _filteredPosts = [];
  bool _isLoading = true;
  String? _errorMessage;
  int? _selectedUserId;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchPosts();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  /// GET: Mengambil data post dari API
  Future<void> _fetchPosts({int? userId}) async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final posts = await _repository.getPosts(userId: userId);
      setState(() {
        _posts = posts;
        _applySearchFilter();
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString().replaceAll('Exception: ', '');
        _isLoading = false;
      });
    }
  }

  void _applySearchFilter() {
    final query = _searchController.text.toLowerCase().trim();
    if (query.isEmpty) {
      _filteredPosts = List.from(_posts);
    } else {
      _filteredPosts = _posts.where((post) {
        return post.title.toLowerCase().contains(query) ||
            post.id.toString() == query ||
            (post.body != null && post.body!.toLowerCase().contains(query));
      }).toList();
    }
  }

  /// POST: Menambahkan data post baru
  Future<void> _handleCreatePost(String title, String body) async {
    // Tampilkan loading overlay / indicator
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Row(
          children: [
            SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.white,
              ),
            ),
            SizedBox(width: 12),
            Text('Mengirim POST /posts ke server...'),
          ],
        ),
        duration: Duration(seconds: 1),
      ),
    );

    try {
      final createdPost = await _repository.createPost(
        title: title,
        body: body,
        userId: 1,
      );

      // Tambahkan ke list lokal di posisi teratas agar user langsung melihat hasilnya
      setState(() {
        _posts.insert(0, createdPost);
        _applySearchFilter();
      });

      if (!mounted) return;
      _showSuccessFeedback(
        title: 'POST Berhasil! (HTTP 201 Created)',
        message:
            'Post #${createdPost.id} "${createdPost.title}" sukses dikirim.',
      );
    } catch (e) {
      if (!mounted) return;
      _showErrorSnackBar('Gagal membuat post: $e');
    }
  }

  /// PUT: Mengubah data post
  Future<void> _handleUpdatePost(
    Post post,
    String newTitle,
    String newBody,
  ) async {
    try {
      final updatedPost = await _repository.updatePost(
        id: post.id,
        title: newTitle,
        body: newBody,
        userId: post.userId,
      );

      setState(() {
        final index = _posts.indexWhere((p) => p.id == post.id);
        if (index != -1) {
          _posts[index] = updatedPost;
          _applySearchFilter();
        }
      });

      if (!mounted) return;
      _showSuccessFeedback(
        title: 'PUT Berhasil! (HTTP 200 OK)',
        message: 'Post #${post.id} berhasil diperbarui di server.',
      );
    } catch (e) {
      if (!mounted) return;
      _showErrorSnackBar('Gagal memperbarui post: $e');
    }
  }

  /// DELETE: Menghapus data post
  Future<void> _handleDeletePost(Post post) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppTheme.darkSurface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          'Hapus Post?',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        content: Text(
          'Apakah Anda yakin ingin menghapus Post #${post.id}?\nRequest HTTP DELETE /posts/${post.id} akan dikirimkan.',
          style: const TextStyle(color: Color(0xFFCBD5E1), fontSize: 13),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Batal', style: TextStyle(color: Colors.white70)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFEF4444),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text(
              'Hapus (DELETE)',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    try {
      await _repository.deletePost(post.id);

      setState(() {
        _posts.removeWhere((p) => p.id == post.id);
        _applySearchFilter();
      });

      if (!mounted) return;
      _showSuccessFeedback(
        title: 'DELETE Berhasil! (HTTP 200 OK)',
        message: 'Post #${post.id} berhasil dihapus dari server.',
      );
    } catch (e) {
      if (!mounted) return;
      _showErrorSnackBar('Gagal menghapus post: $e');
    }
  }

  void _showSuccessFeedback({required String title, required String message}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: const Color(0xFF10B981),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 13,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              message,
              style: const TextStyle(fontSize: 12, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: const Color(0xFFEF4444),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        content: Text(message, style: const TextStyle(color: Colors.white)),
      ),
    );
  }

  /// Dialog Form untuk Create (POST) atau Edit (PUT)
  void _openPostDialog({Post? postToEdit}) {
    final isEditing = postToEdit != null;
    final titleController = TextEditingController(
      text: postToEdit?.title ?? '',
    );
    final bodyController = TextEditingController(text: postToEdit?.body ?? '');
    final formKey = GlobalKey<FormState>();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
        child: GlassContainer(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
          blur: 24,
          opacity: 0.18,
          borderColor: Colors.white.withValues(alpha: 0.25),
          padding: const EdgeInsets.all(24),
          child: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 44,
                      height: 5,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: isEditing
                              ? const Color(0xFFF59E0B).withValues(alpha: 0.2)
                              : const Color(0xFF10B981).withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: isEditing
                                ? const Color(0xFFF59E0B)
                                : const Color(0xFF10B981),
                          ),
                        ),
                        child: Text(
                          isEditing ? 'HTTP PUT' : 'HTTP POST',
                          style: TextStyle(
                            color: isEditing
                                ? const Color(0xFFF59E0B)
                                : const Color(0xFF10B981),
                            fontWeight: FontWeight.bold,
                            fontSize: 11,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        isEditing
                            ? 'Edit Post #${postToEdit.id}'
                            : 'Buat Post Baru',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    isEditing
                        ? 'Retrofit akan mengeksekusi @PUT(\'/posts/${postToEdit.id}\')'
                        : 'Retrofit akan mengeksekusi @POST(\'/posts\') dengan @Body()',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.6),
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 18),
                  TextFormField(
                    controller: titleController,
                    style: const TextStyle(color: Colors.white),
                    decoration: AppTheme.glassInputDecoration(
                      labelText: 'Judul Post (Title)',
                      hintText: 'Masukkan judul postingan...',
                      prefixIcon: const Icon(
                        Icons.title_rounded,
                        color: Color(0xFF94A3B8),
                      ),
                    ),
                    validator: (v) => (v == null || v.trim().isEmpty)
                        ? 'Judul wajib diisi'
                        : null,
                  ),
                  const SizedBox(height: 14),
                  TextFormField(
                    controller: bodyController,
                    maxLines: 4,
                    style: const TextStyle(color: Colors.white),
                    decoration: AppTheme.glassInputDecoration(
                      labelText: 'Isi Konten (Body)',
                      hintText: 'Tulis penjelasan konten post di sini...',
                      prefixIcon: const Icon(
                        Icons.article_rounded,
                        color: Color(0xFF94A3B8),
                      ),
                    ),
                    validator: (v) => (v == null || v.trim().isEmpty)
                        ? 'Konten wajib diisi'
                        : null,
                  ),
                  const SizedBox(height: 22),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primary,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          Navigator.pop(ctx);
                          if (isEditing) {
                            _handleUpdatePost(
                              postToEdit,
                              titleController.text.trim(),
                              bodyController.text.trim(),
                            );
                          } else {
                            _handleCreatePost(
                              titleController.text.trim(),
                              bodyController.text.trim(),
                            );
                          }
                        }
                      },
                      child: Text(
                        isEditing
                            ? 'Simpan Perubahan (PUT)'
                            : 'Kirim Post (POST)',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Detail Modal (Menampilkan data lengkap & Raw JSON inspect untuk pembelajaran)
  void _openDetailModal(Post post) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) => GlassContainer(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        blur: 24,
        opacity: 0.18,
        borderColor: Colors.white.withValues(alpha: 0.25),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 44,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppTheme.primary.withValues(alpha: 0.25),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppTheme.primary),
                  ),
                  child: Text(
                    'Post ID #${post.id}',
                    style: const TextStyle(
                      color: AppTheme.primaryLight,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                if (post.userId != null)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppTheme.accent.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppTheme.accent),
                    ),
                    child: Text(
                      'User ID #${post.userId}',
                      style: const TextStyle(
                        color: AppTheme.accent,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.close_rounded, color: Colors.white70),
                  onPressed: () => Navigator.pop(ctx),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Text(
              post.title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
                height: 1.3,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              post.body ?? '(Tidak ada konten)',
              style: const TextStyle(
                color: Color(0xFFCBD5E1),
                fontSize: 14,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 20),
            // Panel Inspeksi JSON untuk Pembelajaran Mahasiswa
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.45),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(
                        Icons.code_rounded,
                        color: AppTheme.accent,
                        size: 16,
                      ),
                      SizedBox(width: 6),
                      Text(
                        'Serialized JSON Preview (toJson())',
                        style: TextStyle(
                          color: AppTheme.accent,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  SelectableText(
                    post.toJson().toString(),
                    style: const TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 11,
                      color: Color(0xFF94A3B8),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFFF59E0B),
                      side: const BorderSide(color: Color(0xFFF59E0B)),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    icon: const Icon(Icons.edit_rounded, size: 18),
                    label: const Text('Edit (PUT)'),
                    onPressed: () {
                      Navigator.pop(ctx);
                      _openPostDialog(postToEdit: post);
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFEF4444),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    icon: const Icon(Icons.delete_outline_rounded, size: 18),
                    label: const Text('Hapus (DELETE)'),
                    onPressed: () {
                      Navigator.pop(ctx);
                      _handleDeletePost(post);
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Sheet Panduan Materi Modul Week 7 untuk Mahasiswa
  void _openModuleGuide() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => GlassContainer(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        blur: 24,
        opacity: 0.18,
        borderColor: Colors.white.withValues(alpha: 0.25),
        padding: const EdgeInsets.all(24),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 44,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Row(
                children: [
                  Icon(Icons.school_rounded, color: AppTheme.accent, size: 24),
                  SizedBox(width: 10),
                  Text(
                    'Poin Pembelajaran Modul 7',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _buildGuideCard(
                icon: Icons.code_rounded,
                color: AppTheme.primary,
                title: '1. JSON Serialization & Deserialization',
                content:
                    '• Deserialisasi: jsonDecode() -> fromJson() mengubah JSON server menjadi Objek Model Dart.\n'
                    '• Serialisasi: toJson() -> jsonEncode() membungkus Objek Model Dart menjadi JSON string untuk dikirim.\n'
                    '• Anotasi @JsonSerializable() mengotomatiskan pembuatan fungsi ini lewat build_runner.',
              ),
              const SizedBox(height: 12),
              _buildGuideCard(
                icon: Icons.electrical_services_rounded,
                color: AppTheme.accent,
                title: '2. Retrofit & Dio Architecture',
                content:
                    '• Retrofit adalah type-safe HTTP client berbasis anotasi di atas Dio.\n'
                    '• Interface didefinisikan dengan @RestApi, @GET, @POST, @PUT, @DELETE.\n'
                    '• File generator otomatis dibuat di api_service.g.dart tanpa perlu menulis boilerplate HTTP manual.',
              ),
              const SizedBox(height: 12),
              _buildGuideCard(
                icon: Icons.shield_rounded,
                color: const Color(0xFF10B981),
                title: '3. Clean Architecture & Error Handling',
                content:
                    '• Alur: UI (Widget) -> Repository -> Service/Retrofit -> Server.\n'
                    '• Dio Interceptor menangkap logging & request options.\n'
                    '• DioException di-handle dengan ramah sesuai HTTP Status Code (200, 201, 400, 404, 500).',
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  onPressed: () => Navigator.pop(ctx),
                  child: const Text(
                    'Tutup Panduan',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGuideCard({
    required IconData icon,
    required Color color,
    required String title,
    required String content,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 18),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    color: color,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: const TextStyle(
              color: Color(0xFFCBD5E1),
              fontSize: 12,
              height: 1.45,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            _buildSearchAndFilterBar(),
            Expanded(child: _buildContent()),
          ],
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 76),
        child: FloatingActionButton.extended(
          backgroundColor: AppTheme.primary,
          icon: const Icon(Icons.add_rounded, color: Colors.white),
          label: const Text(
            'Tambah Post (POST)',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          onPressed: () => _openPostDialog(),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 10),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              gradient: AppTheme.buttonGradient,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.primary.withValues(alpha: 0.4),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Icon(
              Icons.cloud_sync_rounded,
              color: Colors.white,
              size: 24,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Text(
                      'JSON & Retrofit API',
                      style: TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  'jsonplaceholder.typicode.com • Modul 7',
                  style: TextStyle(
                    fontSize: 11,
                    color: AppTheme.accent.withValues(alpha: 0.9),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            tooltip: 'Panduan Materi Modul 7',
            icon: const Icon(
              Icons.info_outline_rounded,
              color: AppTheme.accent,
            ),
            onPressed: _openModuleGuide,
          ),
          IconButton(
            tooltip: 'Refresh Data (GET)',
            icon: const Icon(Icons.refresh_rounded, color: Colors.white70),
            onPressed: () => _fetchPosts(userId: _selectedUserId),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchAndFilterBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
      child: Column(
        children: [
          TextField(
            controller: _searchController,
            style: const TextStyle(color: Colors.white, fontSize: 13),
            onChanged: (_) {
              setState(() {
                _applySearchFilter();
              });
            },
            decoration: AppTheme.glassInputDecoration(
              labelText: 'Cari Postingan (Judul / ID)',
              hintText: 'Ketik kata kunci pencarian...',
              prefixIcon: const Icon(
                Icons.search_rounded,
                color: Color(0xFF94A3B8),
              ),
            ),
          ),
          const SizedBox(height: 8),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildFilterChip(label: 'Semua User', userId: null),
                const SizedBox(width: 8),
                _buildFilterChip(label: 'User 1 (@Query)', userId: 1),
                const SizedBox(width: 8),
                _buildFilterChip(label: 'User 2', userId: 2),
                const SizedBox(width: 8),
                _buildFilterChip(label: 'User 3', userId: 3),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip({required String label, required int? userId}) {
    final isSelected = _selectedUserId == userId;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedUserId = userId;
        });
        _fetchPosts(userId: userId);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: isSelected ? AppTheme.accentGradient : null,
          color: isSelected ? null : Colors.white.withValues(alpha: 0.08),
          border: Border.all(
            color: isSelected
                ? AppTheme.accent
                : Colors.white.withValues(alpha: 0.15),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            color: isSelected ? Colors.white : const Color(0xFF94A3B8),
          ),
        ),
      ),
    );
  }

  Widget _buildContent() {
    if (_isLoading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(color: AppTheme.accent),
            const SizedBox(height: 16),
            Text(
              'Menghubungi JSONPlaceholder via Retrofit...',
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.7),
                fontSize: 12,
              ),
            ),
          ],
        ),
      );
    }

    if (_errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.cloud_off_rounded,
                color: Color(0xFFEF4444),
                size: 56,
              ),
              const SizedBox(height: 16),
              const Text(
                'Gagal Mengambil Data (Error Handling)',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                _errorMessage!,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 13),
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                icon: const Icon(Icons.refresh_rounded, color: Colors.white),
                label: const Text(
                  'Coba Lagi (Retry)',
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () => _fetchPosts(userId: _selectedUserId),
              ),
            ],
          ),
        ),
      );
    }

    if (_filteredPosts.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off_rounded,
              size: 48,
              color: Colors.white.withValues(alpha: 0.3),
            ),
            const SizedBox(height: 12),
            Text(
              'Tidak ada postingan yang sesuai',
              style: TextStyle(color: Colors.white.withValues(alpha: 0.6)),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      color: AppTheme.accent,
      backgroundColor: AppTheme.darkSurface,
      onRefresh: () => _fetchPosts(userId: _selectedUserId),
      child: ListView.builder(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 100),
        itemCount: _filteredPosts.length,
        itemBuilder: (context, index) {
          final post = _filteredPosts[index];
          return _buildPostCard(post);
        },
      ),
    );
  }

  Widget _buildPostCard(Post post) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: GlassContainer(
        borderRadius: BorderRadius.circular(18),
        blur: 16,
        opacity: 0.12,
        borderColor: Colors.white.withValues(alpha: 0.16),
        padding: const EdgeInsets.all(16),
        child: InkWell(
          onTap: () => _openDetailModal(post),
          borderRadius: BorderRadius.circular(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: AppTheme.primary.withValues(alpha: 0.25),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: AppTheme.primary.withValues(alpha: 0.6),
                      ),
                    ),
                    child: Text(
                      '#${post.id}',
                      style: const TextStyle(
                        color: AppTheme.primaryLight,
                        fontWeight: FontWeight.bold,
                        fontSize: 11,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  if (post.userId != null)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.accent.withValues(alpha: 0.18),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'User ${post.userId}',
                        style: const TextStyle(
                          color: AppTheme.accent,
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(
                      Icons.edit_outlined,
                      size: 18,
                      color: Color(0xFFF59E0B),
                    ),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    tooltip: 'Edit (PUT)',
                    onPressed: () => _openPostDialog(postToEdit: post),
                  ),
                  const SizedBox(width: 12),
                  IconButton(
                    icon: const Icon(
                      Icons.delete_outline_rounded,
                      size: 18,
                      color: Color(0xFFEF4444),
                    ),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    tooltip: 'Hapus (DELETE)',
                    onPressed: () => _handleDeletePost(post),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                post.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  height: 1.3,
                ),
              ),
              if (post.body != null && post.body!.isNotEmpty) ...[
                const SizedBox(height: 6),
                Text(
                  post.body!,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.65),
                    fontSize: 12,
                    height: 1.4,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
