import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

class WatchListPage extends StatefulWidget {
  const WatchListPage({super.key});

  @override
  State<WatchListPage> createState() => _WatchListPageState();
}

class _WatchListPageState extends State<WatchListPage> with TickerProviderStateMixin {
  final List<Movie> _watchlist = [];
  late AnimationController _animationController;
  String _selectedFilter = 'All';
  final List<String> _filters = ['All', 'To Watch', 'Watching', 'Completed'];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    // Add some sample movies
    _watchlist.addAll([
      Movie(
        title: 'The Shawshank Redemption',
        year: 1994,
        genre: 'Drama',
        rating: 9.3,
        status: 'Completed',
        posterUrl: 'https://via.placeholder.com/300x450/6366F1/FFFFFF?text=TSR',
      ),
      Movie(
        title: 'The Dark Knight',
        year: 2008,
        genre: 'Action',
        rating: 9.0,
        status: 'Completed',
        posterUrl: 'https://via.placeholder.com/300x450/4F46E5/FFFFFF?text=TDK',
      ),
      Movie(
        title: 'Inception',
        year: 2010,
        genre: 'Sci-Fi',
        rating: 8.8,
        status: 'To Watch',
        posterUrl: 'https://via.placeholder.com/300x450/10B981/FFFFFF?text=INC',
      ),
    ]);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _addToWatchlist() {
    showDialog(
      context: context,
      builder: (context) => _AddMovieDialog(
        onAdd: (movie) {
          setState(() {
            _watchlist.add(movie);
          });
          _animationController.forward().then((_) => _animationController.reset());
        },
      ),
    );
  }

  void _removeFromWatchlist(int index) {
    setState(() {
      _watchlist.removeAt(index);
    });
  }

  List<Movie> get _filteredMovies {
    if (_selectedFilter == 'All') return _watchlist;
    return _watchlist.where((movie) => movie.status == _selectedFilter).toList();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundSecondary,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: isDark ? AppColors.backgroundDark : AppColors.white,
        title: Text(
          'My Watchlist',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w800,
            color: isDark ? AppColors.white : AppColors.grey900,
            letterSpacing: -0.5,
          ),
        ),
        actions: [
          // Search button with glassmorphism effect
          Container(
            margin: const EdgeInsets.only(right: 8),
            child: IconButton(
              icon: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isDark 
                    ? AppColors.glassDark.withOpacity(0.2)
                    : AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: isDark 
                    ? Border.all(color: AppColors.glassDark.withOpacity(0.3))
                    : null,
                  boxShadow: isDark ? [] : [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.search_rounded,
                  color: isDark ? AppColors.accentBlue : AppColors.primary,
                  size: 20,
                ),
              ),
              onPressed: () {
                // Handle search
              },
            ),
          ),
          // Add button with gradient
          Container(
            margin: const EdgeInsets.only(right: 16),
            child: IconButton(
              icon: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: isDark 
                      ? [AppColors.accentBlue, AppColors.accentPurple]
                      : [AppColors.primary, AppColors.primaryDark],
                  ),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: (isDark ? AppColors.accentBlue : AppColors.primary).withOpacity(0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.add_rounded,
                  color: AppColors.white,
                  size: 20,
                ),
              ),
              onPressed: _addToWatchlist,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Enhanced Filter Tabs with better design
          Container(
            height: 70,
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: isDark ? AppColors.backgroundDark : AppColors.white,
              boxShadow: isDark ? [] : [
                BoxShadow(
                  color: AppColors.grey900.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: _filters.length,
              itemBuilder: (context, index) {
                final filter = _filters[index];
                final isSelected = filter == _selectedFilter;
                return Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedFilter = filter;
                      });
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      decoration: BoxDecoration(
                        gradient: isSelected 
                          ? LinearGradient(
                              colors: isDark 
                                ? [AppColors.accentBlue, AppColors.accentPurple]
                                : [AppColors.primary, AppColors.primaryDark],
                            )
                          : null,
                        color: isSelected 
                          ? null 
                          : isDark 
                            ? AppColors.glassDark.withOpacity(0.1)
                            : AppColors.grey100,
                        borderRadius: BorderRadius.circular(25),
                        border: isSelected 
                          ? null
                          : Border.all(
                              color: isDark 
                                ? AppColors.glassDark.withOpacity(0.3)
                                : AppColors.grey300,
                              width: 1,
                            ),
                        boxShadow: isSelected ? [
                          BoxShadow(
                            color: (isDark ? AppColors.accentBlue : AppColors.primary).withOpacity(0.3),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ] : [],
                      ),
                      child: Text(
                        filter,
                        style: TextStyle(
                          color: isSelected 
                            ? AppColors.white 
                            : isDark 
                              ? AppColors.grey300
                              : AppColors.grey600,
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          // Enhanced Movies Grid
          Expanded(
            child: _filteredMovies.isEmpty
                ? _buildEmptyState()
                : Padding(
                    padding: const EdgeInsets.all(16),
                    child: GridView.builder(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        childAspectRatio: 1.2,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                      ),
                      itemCount: _filteredMovies.length,
                      itemBuilder: (context, index) {
                        final movie = _filteredMovies[index];
                        return _buildMovieCard(movie, index);
                      },
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Animated gradient container
          Container(
            width: 140,
            height: 140,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isDark 
                  ? [
                      AppColors.accentBlue.withOpacity(0.2),
                      AppColors.accentPurple.withOpacity(0.1),
                    ]
                  : [
                      AppColors.primary.withOpacity(0.1),
                      AppColors.primaryDark.withOpacity(0.05),
                    ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(70),
              border: isDark 
                ? Border.all(color: AppColors.glassDark.withOpacity(0.3))
                : null,
            ),
            child: Icon(
              Icons.movie_creation_outlined,
              size: 70,
              color: isDark ? AppColors.accentBlue : AppColors.primary,
            ),
          ),
          const SizedBox(height: 32),
          Text(
            _selectedFilter == 'All' 
                ? 'Your watchlist is empty'
                : 'No movies in this category',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w800,
              color: isDark ? AppColors.white : AppColors.grey900,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Text(
              _selectedFilter == 'All'
                  ? 'Start adding movies to keep track of what you want to watch'
                  : 'Try adding some movies or switch to a different filter',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: isDark ? AppColors.grey400 : AppColors.grey600,
                fontWeight: FontWeight.w500,
                height: 1.5,
              ),
            ),
          ),
          const SizedBox(height: 40),
          // Enhanced CTA button
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isDark 
                  ? [AppColors.accentBlue, AppColors.accentPurple]
                  : [AppColors.primary, AppColors.primaryDark],
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: (isDark ? AppColors.accentBlue : AppColors.primary).withOpacity(0.4),
                  blurRadius: 20,
                  spreadRadius: 0,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: ElevatedButton.icon(
              onPressed: _addToWatchlist,
              icon: const Icon(
                Icons.add_rounded,
                color: AppColors.white,
                size: 24,
              ),
              label: const Text(
                'Add Movie',
                style: TextStyle(
                  color: AppColors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                  letterSpacing: 0.5,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMovieCard(Movie movie, int index) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : AppColors.white,
        borderRadius: BorderRadius.circular(20),
        border: isDark 
          ? Border.all(color: AppColors.glassDark.withOpacity(0.2))
          : Border.all(color: AppColors.grey100),
        boxShadow: [
          BoxShadow(
            color: isDark 
              ? AppColors.black.withOpacity(0.2)
              : AppColors.grey900.withOpacity(0.08),
            blurRadius: isDark ? 12 : 20,
            spreadRadius: 0,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Enhanced Movie Poster with glassmorphism
          Expanded(
            flex: 4,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: isDark 
                    ? [
                        AppColors.accentBlue.withOpacity(0.8),
                        AppColors.accentPurple.withOpacity(0.6),
                      ]
                    : [
                        AppColors.primary.withOpacity(0.9),
                        AppColors.primaryDark.withOpacity(0.7),
                      ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Stack(
                children: [
                  // Background pattern
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                        ),
                        gradient: LinearGradient(
                          colors: [
                            Colors.white.withOpacity(0.1),
                            Colors.transparent,
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.center,
                        ),
                      ),
                    ),
                  ),
                  // Movie icon with better styling
                  Center(
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.white.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppColors.white.withOpacity(0.2),
                          width: 1,
                        ),
                      ),
                      child: Icon(
                        Icons.movie_filter_rounded,
                        size: 28,
                        color: AppColors.white,
                      ),
                    ),
                  ),
                  // Status Badge with better design
                  Positioned(
                    top: 10,
                    right: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                      decoration: BoxDecoration(
                        color: _getStatusColor(movie.status),
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: _getStatusColor(movie.status).withOpacity(0.3),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Text(
                        _getStatusShort(movie.status),
                        style: const TextStyle(
                          color: AppColors.white,
                          fontSize: 9,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ),
                  // More Options with glassmorphism
                  Positioned(
                    top: 10,
                    left: 10,
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.black.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: AppColors.white.withOpacity(0.2),
                        ),
                      ),
                      child: PopupMenuButton<String>(
                        icon: const Icon(
                          Icons.more_horiz_rounded,
                          color: AppColors.white,
                          size: 16,
                        ),
                        padding: const EdgeInsets.all(4),
                        iconSize: 16,
                        onSelected: (value) {
                          if (value == 'delete') {
                            _removeFromWatchlist(index);
                          }
                        },
                        color: isDark ? AppColors.cardDark : AppColors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        itemBuilder: (context) => [
                          PopupMenuItem(
                            value: 'edit',
                            height: 44,
                            child: Row(
                              children: [
                                Icon(
                                  Icons.edit_rounded, 
                                  size: 18,
                                  color: isDark ? AppColors.accentBlue : AppColors.primary,
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  'Edit',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: isDark ? AppColors.white : AppColors.grey900,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          PopupMenuItem(
                            value: 'delete',
                            height: 44,
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.delete_rounded, 
                                  size: 18,
                                  color: AppColors.error,
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  'Remove',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: isDark ? AppColors.white : AppColors.grey900,
                                  ),
                                ),
                              ],
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
          // Compact Movie Info with better spacing
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title with better typography
                  Flexible(
                    child: Text(
                      movie.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        color: isDark ? AppColors.white : AppColors.grey900,
                        height: 1.2,
                        letterSpacing: -0.2,
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  // Year and Genre with better styling
                  Text(
                    '${movie.year} • ${movie.genre}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 12,
                      color: isDark ? AppColors.grey400 : AppColors.grey600,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.2,
                    ),
                  ),
                  const Spacer(),
                  // Rating with enhanced design
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                        decoration: BoxDecoration(
                          color: isDark 
                            ? Colors.amber.withOpacity(0.15)
                            : Colors.amber.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(
                            color: Colors.amber.withOpacity(0.3),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.star_rounded,
                              size: 12,
                              color: Colors.amber[700],
                            ),
                            const SizedBox(width: 3),
                            Text(
                              movie.rating.toString(),
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w800,
                                color: isDark ? AppColors.white : AppColors.grey900,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getStatusShort(String status) {
    switch (status) {
      case 'To Watch':
        return 'TO WATCH';
      case 'Watching':
        return 'WATCHING';
      case 'Completed':
        return 'DONE';
      default:
        return 'UNKNOWN';
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'To Watch':
        return AppColors.info;
      case 'Watching':
        return AppColors.warning;
      case 'Completed':
        return AppColors.success;
      default:
        return AppColors.grey500;
    }
  }
}

class _AddMovieDialog extends StatefulWidget {
  final Function(Movie) onAdd;

  const _AddMovieDialog({required this.onAdd});

  @override
  State<_AddMovieDialog> createState() => _AddMovieDialogState();
}

class _AddMovieDialogState extends State<_AddMovieDialog> {
  final _titleController = TextEditingController();
  final _yearController = TextEditingController();
  final _genreController = TextEditingController();
  String _selectedStatus = 'To Watch';
  final List<String> _statuses = ['To Watch', 'Watching', 'Completed'];

  @override
  void dispose() {
    _titleController.dispose();
    _yearController.dispose();
    _genreController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return AlertDialog(
      backgroundColor: isDark ? AppColors.cardDark : AppColors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      title: Text(
        'Add Movie',
        style: TextStyle(
          fontWeight: FontWeight.w800,
          fontSize: 24,
          color: isDark ? AppColors.white : AppColors.grey900,
          letterSpacing: -0.5,
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildTextField(
            controller: _titleController,
            label: 'Movie Title',
            icon: Icons.movie_rounded,
            isDark: isDark,
          ),
          const SizedBox(height: 20),
          _buildTextField(
            controller: _yearController,
            label: 'Year',
            icon: Icons.calendar_today_rounded,
            isDark: isDark,
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 20),
          _buildTextField(
            controller: _genreController,
            label: 'Genre',
            icon: Icons.category_rounded,
            isDark: isDark,
          ),
          const SizedBox(height: 20),
          Container(
            decoration: BoxDecoration(
              color: isDark 
                ? AppColors.glassDark.withOpacity(0.1)
                : AppColors.grey50,
              borderRadius: BorderRadius.circular(16),
              border: isDark 
                ? Border.all(color: AppColors.glassDark.withOpacity(0.3))
                : Border.all(color: AppColors.grey200),
            ),
            child: DropdownButtonFormField<String>(
              value: _selectedStatus,
              decoration: InputDecoration(
                labelText: 'Status',
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                prefixIcon: Icon(
                  Icons.flag_rounded,
                  color: isDark ? AppColors.accentBlue : AppColors.primary,
                ),
                labelStyle: TextStyle(
                  color: isDark ? AppColors.grey400 : AppColors.grey600,
                  fontWeight: FontWeight.w600,
                ),
              ),
              dropdownColor: isDark ? AppColors.cardDark : AppColors.white,
              items: _statuses.map((status) {
                return DropdownMenuItem(
                  value: status,
                  child: Text(
                    status,
                    style: TextStyle(
                      color: isDark ? AppColors.white : AppColors.grey900,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedStatus = value!;
                });
              },
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(
            'Cancel',
            style: TextStyle(
              color: isDark ? AppColors.grey400 : AppColors.grey600,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: isDark 
                ? [AppColors.accentBlue, AppColors.accentPurple]
                : [AppColors.primary, AppColors.primaryDark],
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: ElevatedButton(
            onPressed: () {
              if (_titleController.text.isNotEmpty &&
                  _yearController.text.isNotEmpty &&
                  _genreController.text.isNotEmpty) {
                final movie = Movie(
                  title: _titleController.text,
                  year: int.tryParse(_yearController.text) ?? 2023,
                  genre: _genreController.text,
                  rating: 8.0, // Default rating
                  status: _selectedStatus,
                  posterUrl: 'https://via.placeholder.com/300x450/6366F1/FFFFFF?text=${_titleController.text.substring(0, 3).toUpperCase()}',
                );
                widget.onAdd(movie);
                Navigator.pop(context);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: const Text(
              'Add Movie',
              style: TextStyle(
                color: AppColors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required bool isDark,
    TextInputType? keyboardType,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: isDark 
          ? AppColors.glassDark.withOpacity(0.1)
          : AppColors.grey50,
        borderRadius: BorderRadius.circular(16),
        border: isDark 
          ? Border.all(color: AppColors.glassDark.withOpacity(0.3))
          : Border.all(color: AppColors.grey200),
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        style: TextStyle(
          color: isDark ? AppColors.white : AppColors.grey900,
          fontWeight: FontWeight.w600,
        ),
        decoration: InputDecoration(
          labelText: label,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          prefixIcon: Icon(
            icon,
            color: isDark ? AppColors.accentBlue : AppColors.primary,
          ),
          labelStyle: TextStyle(
            color: isDark ? AppColors.grey400 : AppColors.grey600,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

class Movie {
  final String title;
  final int year;
  final String genre;
  final double rating;
  final String status;
  final String posterUrl;

  Movie({
    required this.title,
    required this.year,
    required this.genre,
    required this.rating,
    required this.status,
    required this.posterUrl,
  });
}
