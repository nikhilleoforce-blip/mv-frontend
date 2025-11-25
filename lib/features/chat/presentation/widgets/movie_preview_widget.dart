import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../core/constants/app_colors.dart';
import '../../api.dart';

class MoviePreviewWidget extends StatelessWidget {
  final List<Movie> movies;
  final String? genreName;
  final double? confidence;

  const MoviePreviewWidget({
    super.key,
    required this.movies,
    this.genreName,
    this.confidence,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    if (movies.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Genre and confidence header
        if (genreName != null) ...[
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.primary.withOpacity(0.2),
                  AppColors.secondary.withOpacity(0.1),
                ],
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.category, size: 12, color: AppColors.primary),
                const SizedBox(width: 4),
                Text(
                  genreName!,
                  style: TextStyle(
                    color: AppColors.primary,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (confidence != null) ...[
                  const SizedBox(width: 4),
                  Text(
                    '(${(confidence! * 100).toStringAsFixed(0)}%)',
                    style: TextStyle(
                      color: AppColors.secondary,
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 8),
        ],

        // Movie recommendations header
        Text(
          'Movie Recommendations:',
          style: TextStyle(
            color: isDarkMode ? AppColors.grey300 : AppColors.grey600,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),

        // Horizontal scrollable movie list with detailed previews
        SizedBox(
          height: 220, // Increased height for more content
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: movies.take(10).length, // Show max 10 movies
            itemBuilder: (context, index) {
              final movie = movies[index];
              return _buildMovieCard(movie, isDarkMode, context);
            },
          ),
        ),

        // Show more button if there are more movies
        if (movies.length > 10) ...[
          const SizedBox(height: 8),
          GestureDetector(
            onTap: () => _showAllMovies(context, movies, genreName),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.primary.withOpacity(0.3)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.grid_view, size: 14, color: AppColors.primary),
                  const SizedBox(width: 4),
                  Text(
                    'View all ${movies.length} movies',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 12,
                    color: AppColors.primary,
                  ),
                ],
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildMovieCard(Movie movie, bool isDarkMode, BuildContext context) {
    return Container(
      width: 100,
      margin: const EdgeInsets.only(right: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Movie poster
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: isDarkMode
                        ? AppColors.black.withOpacity(0.3)
                        : AppColors.grey900.withOpacity(0.1),
                    blurRadius: 6,
                    spreadRadius: 0,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: movie.posterPath != null
                    ? CachedNetworkImage(
                        imageUrl: movie.posterPath!,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Container(
                          color: isDarkMode
                              ? AppColors.grey700
                              : AppColors.grey200,
                          child: Center(
                            child: Icon(
                              Icons.movie,
                              color: isDarkMode
                                  ? AppColors.grey500
                                  : AppColors.grey400,
                              size: 24,
                            ),
                          ),
                        ),
                        errorWidget: (context, url, error) => Container(
                          color: isDarkMode
                              ? AppColors.grey700
                              : AppColors.grey200,
                          child: Center(
                            child: Icon(
                              Icons.broken_image,
                              color: isDarkMode
                                  ? AppColors.grey500
                                  : AppColors.grey400,
                              size: 24,
                            ),
                          ),
                        ),
                      )
                    : Container(
                        color: isDarkMode
                            ? AppColors.grey700
                            : AppColors.grey200,
                        child: Center(
                          child: Icon(
                            Icons.movie,
                            color: isDarkMode
                                ? AppColors.grey500
                                : AppColors.grey400,
                            size: 24,
                          ),
                        ),
                      ),
              ),
            ),
          ),
          const SizedBox(height: 4),

          // Movie title
          Text(
            movie.title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: isDarkMode ? AppColors.white : AppColors.grey900,
              fontSize: 10,
              fontWeight: FontWeight.w500,
              height: 1.2,
            ),
          ),

          // Rating
          if (movie.voteAverage != null) ...[
            const SizedBox(height: 2),
            Row(
              children: [
                Icon(Icons.star, size: 10, color: AppColors.warning),
                const SizedBox(width: 2),
                Text(
                  movie.voteAverage!.toStringAsFixed(1),
                  style: TextStyle(
                    color: isDarkMode ? AppColors.grey400 : AppColors.grey600,
                    fontSize: 9,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  void _showAllMovies(
    BuildContext context,
    List<Movie> movies,
    String? genreName,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) =>
          MovieListBottomSheet(movies: movies, genreName: genreName),
    );
  }
}

class MovieListBottomSheet extends StatelessWidget {
  final List<Movie> movies;
  final String? genreName;

  const MovieListBottomSheet({Key? key, required this.movies, this.genreName})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      decoration: BoxDecoration(
        color: isDarkMode ? AppColors.backgroundDark : AppColors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          // Handle bar
          Container(
            margin: const EdgeInsets.symmetric(vertical: 8),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: isDarkMode ? AppColors.grey600 : AppColors.grey300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    genreName != null
                        ? '$genreName Movies'
                        : 'Movie Recommendations',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: isDarkMode ? AppColors.white : AppColors.grey900,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(
                    Icons.close,
                    color: isDarkMode ? AppColors.grey300 : AppColors.grey600,
                  ),
                ),
              ],
            ),
          ),

          // Movies grid
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.6,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: movies.length,
              itemBuilder: (context, index) {
                final movie = movies[index];
                return _buildFullMovieCard(movie, isDarkMode);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFullMovieCard(Movie movie, bool isDarkMode) {
    return Container(
      decoration: BoxDecoration(
        color: isDarkMode ? AppColors.surfaceDark : AppColors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: isDarkMode
                ? AppColors.black.withOpacity(0.3)
                : AppColors.grey900.withOpacity(0.1),
            blurRadius: 8,
            spreadRadius: 0,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Movie poster
          Expanded(
            flex: 3,
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
              child: movie.posterPath != null
                  ? CachedNetworkImage(
                      imageUrl: movie.posterPath!,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      placeholder: (context, url) => Container(
                        color: isDarkMode
                            ? AppColors.grey700
                            : AppColors.grey200,
                        child: Center(
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation(
                              AppColors.primary,
                            ),
                            strokeWidth: 2,
                          ),
                        ),
                      ),
                      errorWidget: (context, url, error) => Container(
                        color: isDarkMode
                            ? AppColors.grey700
                            : AppColors.grey200,
                        child: Center(
                          child: Icon(
                            Icons.broken_image,
                            color: isDarkMode
                                ? AppColors.grey500
                                : AppColors.grey400,
                            size: 32,
                          ),
                        ),
                      ),
                    )
                  : Container(
                      color: isDarkMode ? AppColors.grey700 : AppColors.grey200,
                      child: Center(
                        child: Icon(
                          Icons.movie,
                          color: isDarkMode
                              ? AppColors.grey500
                              : AppColors.grey400,
                          size: 32,
                        ),
                      ),
                    ),
            ),
          ),

          // Movie details
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    movie.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: isDarkMode ? AppColors.white : AppColors.grey900,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 4),

                  // Rating and year
                  Row(
                    children: [
                      if (movie.voteAverage != null) ...[
                        Icon(Icons.star, size: 12, color: AppColors.warning),
                        const SizedBox(width: 2),
                        Text(
                          movie.voteAverage!.toStringAsFixed(1),
                          style: TextStyle(
                            color: isDarkMode
                                ? AppColors.grey400
                                : AppColors.grey600,
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                      const Spacer(),
                      if (movie.releaseDate != null)
                        Text(
                          DateTime.parse(movie.releaseDate!).year.toString(),
                          style: TextStyle(
                            color: isDarkMode
                                ? AppColors.grey400
                                : AppColors.grey600,
                            fontSize: 10,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),

                  // Genres
                  if (movie.genres.isNotEmpty)
                    Wrap(
                      spacing: 4,
                      children: movie.genres
                          .take(2)
                          .map(
                            (genre) => Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 4,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.primary.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                genre.name,
                                style: TextStyle(
                                  color: AppColors.primary,
                                  fontSize: 8,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          )
                          .toList(),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
