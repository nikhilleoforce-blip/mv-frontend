class Movie {
  final String id;
  final String title;
  final String? overview;
  final String? posterPath;
  final String? backdropPath;
  final DateTime? releaseDate;
  final double? voteAverage;
  final int? voteCount;
  final List<String> genres;
  final String? originalLanguage;
  final bool? adult;
  final double? popularity;
  final int? runtime;
  final String? status;
  final String? tagline;
  final List<String>? productionCompanies;
  final List<String>? productionCountries;
  final List<String>? spokenLanguages;
  final double? budget;
  final double? revenue;
  final String? imdbId;
  final String? homepage;

  const Movie({
    required this.id,
    required this.title,
    this.overview,
    this.posterPath,
    this.backdropPath,
    this.releaseDate,
    this.voteAverage,
    this.voteCount,
    this.genres = const [],
    this.originalLanguage,
    this.adult,
    this.popularity,
    this.runtime,
    this.status,
    this.tagline,
    this.productionCompanies,
    this.productionCountries,
    this.spokenLanguages,
    this.budget,
    this.revenue,
    this.imdbId,
    this.homepage,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      id: json['id']?.toString() ?? '',
      title: json['title'] ?? json['name'] ?? '',
      overview: json['overview'],
      posterPath: json['poster_path'],
      backdropPath: json['backdrop_path'],
      releaseDate: json['release_date'] != null
          ? DateTime.tryParse(json['release_date'])
          : null,
      voteAverage: (json['vote_average'] as num?)?.toDouble(),
      voteCount: json['vote_count'] as int?,
      genres: _parseGenres(json['genres']),
      originalLanguage: json['original_language'],
      adult: json['adult'] as bool?,
      popularity: (json['popularity'] as num?)?.toDouble(),
      runtime: json['runtime'] as int?,
      status: json['status'],
      tagline: json['tagline'],
      productionCompanies: _parseStringList(json['production_companies']),
      productionCountries: _parseStringList(json['production_countries']),
      spokenLanguages: _parseStringList(json['spoken_languages']),
      budget: (json['budget'] as num?)?.toDouble(),
      revenue: (json['revenue'] as num?)?.toDouble(),
      imdbId: json['imdb_id'],
      homepage: json['homepage'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'overview': overview,
      'poster_path': posterPath,
      'backdrop_path': backdropPath,
      'release_date': releaseDate?.toIso8601String().split('T')[0],
      'vote_average': voteAverage,
      'vote_count': voteCount,
      'genres': genres,
      'original_language': originalLanguage,
      'adult': adult,
      'popularity': popularity,
      'runtime': runtime,
      'status': status,
      'tagline': tagline,
      'production_companies': productionCompanies,
      'production_countries': productionCountries,
      'spoken_languages': spokenLanguages,
      'budget': budget,
      'revenue': revenue,
      'imdb_id': imdbId,
      'homepage': homepage,
    };
  }

  static List<String> _parseGenres(dynamic genres) {
    if (genres == null) return [];
    
    if (genres is List) {
      return genres.map((genre) {
        if (genre is String) return genre;
        if (genre is Map && genre['name'] != null) return genre['name'].toString();
        return genre.toString();
      }).toList();
    }
    
    return [];
  }

  static List<String>? _parseStringList(dynamic list) {
    if (list == null) return null;
    
    if (list is List) {
      return list.map((item) {
        if (item is String) return item;
        if (item is Map && item['name'] != null) return item['name'].toString();
        return item.toString();
      }).toList();
    }
    
    return null;
  }

  // Helper methods
  String get fullPosterUrl => posterPath != null 
      ? 'https://image.tmdb.org/t/p/w500$posterPath' 
      : '';
  
  String get fullBackdropUrl => backdropPath != null 
      ? 'https://image.tmdb.org/t/p/w1280$backdropPath' 
      : '';

  String get genresText => genres.isNotEmpty ? genres.join(', ') : 'Unknown';

  String get releaseYear => releaseDate != null ? releaseDate!.year.toString() : '';

  String get formattedRating => voteAverage != null 
      ? voteAverage!.toStringAsFixed(1) 
      : 'N/A';

  String get formattedRuntime {
    if (runtime == null) return '';
    final hours = runtime! ~/ 60;
    final minutes = runtime! % 60;
    if (hours > 0) {
      return '${hours}h ${minutes}m';
    } else {
      return '${minutes}m';
    }
  }

  bool get hasValidPoster => posterPath != null && posterPath!.isNotEmpty;
  bool get hasValidBackdrop => backdropPath != null && backdropPath!.isNotEmpty;

  Movie copyWith({
    String? id,
    String? title,
    String? overview,
    String? posterPath,
    String? backdropPath,
    DateTime? releaseDate,
    double? voteAverage,
    int? voteCount,
    List<String>? genres,
    String? originalLanguage,
    bool? adult,
    double? popularity,
    int? runtime,
    String? status,
    String? tagline,
    List<String>? productionCompanies,
    List<String>? productionCountries,
    List<String>? spokenLanguages,
    double? budget,
    double? revenue,
    String? imdbId,
    String? homepage,
  }) {
    return Movie(
      id: id ?? this.id,
      title: title ?? this.title,
      overview: overview ?? this.overview,
      posterPath: posterPath ?? this.posterPath,
      backdropPath: backdropPath ?? this.backdropPath,
      releaseDate: releaseDate ?? this.releaseDate,
      voteAverage: voteAverage ?? this.voteAverage,
      voteCount: voteCount ?? this.voteCount,
      genres: genres ?? this.genres,
      originalLanguage: originalLanguage ?? this.originalLanguage,
      adult: adult ?? this.adult,
      popularity: popularity ?? this.popularity,
      runtime: runtime ?? this.runtime,
      status: status ?? this.status,
      tagline: tagline ?? this.tagline,
      productionCompanies: productionCompanies ?? this.productionCompanies,
      productionCountries: productionCountries ?? this.productionCountries,
      spokenLanguages: spokenLanguages ?? this.spokenLanguages,
      budget: budget ?? this.budget,
      revenue: revenue ?? this.revenue,
      imdbId: imdbId ?? this.imdbId,
      homepage: homepage ?? this.homepage,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Movie && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'Movie(id: $id, title: $title, releaseDate: $releaseDate, rating: $voteAverage)';
  }
}
