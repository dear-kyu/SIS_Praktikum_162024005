import 'dart:io';

import 'package:dio/dio.dart';

import '../models/post.dart';
import '../services/api_service.dart';
import '../services/dio_client.dart';

/// Repository untuk mengelola data Post (Best Practice Architecture: Repository Pattern)
/// Menangani business logic, validasi, dan mapping error HTTP/Dio ke pesan yang ramah pengguna.
class PostRepository {
  final ApiService _apiService;

  PostRepository({ApiService? apiService})
    : _apiService = apiService ?? ApiService(DioClient.createDio());

  /// Mengambil daftar semua post
  Future<List<Post>> getPosts({int? userId}) async {
    try {
      if (userId != null) {
        return await _apiService.getPostsByUserId(userId);
      }
      return await _apiService.getPosts();
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw Exception('Terjadi kesalahan tidak terduga: $e');
    }
  }

  /// Mengambil satu post berdasarkan ID
  Future<Post> getPostDetail(int id) async {
    try {
      return await _apiService.getPost(id);
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw Exception('Gagal memuat detail post: $e');
    }
  }

  /// Membuat post baru
  Future<Post> createPost({
    required String title,
    required String body,
    int userId = 1,
  }) async {
    try {
      final newPost = Post(
        id: 0, // Server akan mengassign ID (misalnya 101)
        userId: userId,
        title: title,
        body: body,
      );
      return await _apiService.createPost(newPost);
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw Exception('Gagal membuat post: $e');
    }
  }

  /// Memperbarui post yang sudah ada
  Future<Post> updatePost({
    required int id,
    required String title,
    required String body,
    int? userId,
  }) async {
    try {
      final updatedPost = Post(
        id: id,
        userId: userId ?? 1,
        title: title,
        body: body,
      );
      return await _apiService.updatePost(id, updatedPost);
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw Exception('Gagal memperbarui post: $e');
    }
  }

  /// Menghapus post berdasarkan ID
  Future<void> deletePost(int id) async {
    try {
      await _apiService.deletePost(id);
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw Exception('Gagal menghapus post: $e');
    }
  }

  /// Helper untuk menerjemahkan DioException ke pesan error bahasa Indonesia yang jelas
  String _handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return 'Waktu koneksi habis (Timeout). Periksa koneksi internet Anda.';
      case DioExceptionType.badResponse:
        final code = error.response?.statusCode;
        switch (code) {
          case 400:
            return 'Permintaan tidak valid (Bad Request 400).';
          case 401:
            return 'Tidak diizinkan (Unauthorized - 401).';
          case 404:
            return 'Data atau endpoint tidak ditemukan (Not Found 404).';
          case 500:
            return 'Terjadi gangguan pada server (Internal Server Error 500).';
          default:
            return 'Gagal memproses data dari server (Status $code).';
        }
      case DioExceptionType.connectionError:
        if (error.error is SocketException) {
          return 'Tidak ada akses internet. Pastikan perangkat terhubung.';
        }
        return 'Gagal terhubung ke server API.';
      case DioExceptionType.cancel:
        return 'Permintaan dibatalkan.';
      default:
        return error.message ?? 'Terjadi kesalahan jaringan.';
    }
  }
}
