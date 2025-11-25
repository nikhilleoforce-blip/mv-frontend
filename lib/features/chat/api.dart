import 'package:dio/dio.dart';
import '../../core/services/api_service.dart';

// API methods for Chat feature
class ChatApi {
  // Classify user message and get AI response
  static Future<ChatResponse> getMovieRecommendations(String message) async {
    try {
      final response = await ApiService.post(
        '/api/messages/process',
        data: {'message': message},
      );

      return ChatResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw ChatException(_handleDioError(e));
    } catch (e) {
      throw ChatException('An unexpected error occurred: $e');
    }
  }

  static String _handleDioError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
        return 'Connection timeout. Please check your internet connection.';
      case DioExceptionType.sendTimeout:
        return 'Send timeout. Please try again.';
      case DioExceptionType.receiveTimeout:
        return 'Receive timeout. Please try again.';
      case DioExceptionType.badResponse:
        final statusCode = e.response?.statusCode;
        if (statusCode == 404) {
          return 'Service not found. Please try again later.';
        } else if (statusCode == 500) {
          return 'Server error. Please try again later.';
        }
        return 'Server responded with error: ${statusCode ?? 'Unknown'}';
      case DioExceptionType.cancel:
        return 'Request was cancelled.';
      case DioExceptionType.connectionError:
        return 'Connection error. Please check your internet connection.';
      case DioExceptionType.unknown:
        return 'Network error. Please check your internet connection.';
      default:
        return 'An error occurred: ${e.message ?? 'Unknown error'}';
    }
  }
}

// Data models for chat API responses
class ChatResponse {
  final String response;
  final String? classification;
  final List<Movie> movies;
  final bool success;
  final String? classifiedGenre;
  final int? classifiedGenreId;
  final double? confidence;
  final int? total;

  ChatResponse({
    required this.response,
    this.classification,
    required this.movies,
    this.success = true,
    this.classifiedGenre,
    this.classifiedGenreId,
    this.confidence,
    this.total,
  });

  factory ChatResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? {};

    return ChatResponse(
      response: data['message'] ?? 'Here are some movie recommendations!',
      classification: data['classifiedGenre'],
      classifiedGenre: data['classifiedGenre'],
      classifiedGenreId: data['classifiedGenreId'],
      confidence: data['confidence']?.toDouble(),
      total: data['total'],
      movies: data['movies'] != null
          ? (data['movies'] as List)
                .map((movieJson) => Movie.fromJson(movieJson))
                .toList()
          : [],
      success: json['success'] ?? true,
    );
  }
}

class Movie {
  final String id;
  final String title;
  final String? overview;
  final String? posterPath;
  final String? releaseDate;
  final double? voteAverage;
  final int? voteCount;
  final List<Genre> genres;
  final String? originalLanguage;
  final bool? adult;
  final int? runtime;
  final String? status;
  final String? tagline;
  final String? imdbId;
  final int? tmdbId;

  Movie({
    required this.id,
    required this.title,
    this.overview,
    this.posterPath,
    this.releaseDate,
    this.voteAverage,
    this.voteCount,
    this.genres = const [],
    this.originalLanguage,
    this.adult,
    this.runtime,
    this.status,
    this.tagline,
    this.imdbId,
    this.tmdbId,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      id: json['_id'] ?? '',
      title: json['title'] ?? json['original_title'] ?? 'Unknown Title',
      overview: json['overview'],
      posterPath: json['poster_path'],
      releaseDate: json['release_date'],
      voteAverage: json['vote_average']?.toDouble(),
      voteCount: json['vote_count'],
      genres: json['genres'] != null
          ? (json['genres'] as List).map((g) => Genre.fromJson(g)).toList()
          : [],
      originalLanguage: json['original_language'],
      adult: json['adult'],
      runtime: json['runtime'],
      status: json['status'],
      tagline: json['tagline'],
      imdbId: json['imdb_id'],
      tmdbId: json['tmdb_id'],
    );
  }
}

class Genre {
  final int genreId;
  final String name;

  Genre({required this.genreId, required this.name});

  factory Genre.fromJson(Map<String, dynamic> json) {
    return Genre(genreId: json['genre_id'] ?? 0, name: json['name'] ?? '');
  }
}

class ChatException implements Exception {
  final String message;

  ChatException(this.message);

  @override
  String toString() => 'ChatException: $message';
}
