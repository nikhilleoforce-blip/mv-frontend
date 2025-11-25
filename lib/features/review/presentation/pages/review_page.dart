import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

class ReviewPage extends StatefulWidget {
  const ReviewPage({super.key});

  @override
  State<ReviewPage> createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage> with TickerProviderStateMixin {
  final List<Review> _reviews = [];
  late AnimationController _animationController;
  String _selectedFilter = 'All';
  final List<String> _filters = ['All', '5★', '4★', '3★', '2★', '1★'];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    // Add some sample reviews
    _reviews.addAll([
      Review(
        movieTitle: 'The Shawshank Redemption',
        rating: 5,
        reviewText: 'An absolute masterpiece! The story, acting, and direction are all top-notch. A film that stays with you long after watching.',
        reviewerName: 'John Doe',
        date: DateTime.now().subtract(const Duration(days: 2)),
      ),
      Review(
        movieTitle: 'Inception',
        rating: 4,
        reviewText: 'Mind-bending and visually stunning. Nolan at his finest, though it can be confusing on first watch.',
        reviewerName: 'Jane Smith',
        date: DateTime.now().subtract(const Duration(days: 5)),
      ),
      Review(
        movieTitle: 'The Dark Knight',
        rating: 5,
        reviewText: 'Heath Ledger\'s Joker is unforgettable. A dark, intense, and brilliantly crafted superhero film.',
        reviewerName: 'Mike Johnson',
        date: DateTime.now().subtract(const Duration(days: 10)),
      ),
    ]);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _addReview() {
    showDialog(
      context: context,
      builder: (context) => _AddReviewDialog(
        onAdd: (review) {
          setState(() {
            _reviews.insert(0, review);
          });
          _animationController.forward().then((_) => _animationController.reset());
        },
      ),
    );
  }

  void _deleteReview(int index) {
    setState(() {
      _reviews.removeAt(index);
    });
  }

  List<Review> get _filteredReviews {
    if (_selectedFilter == 'All') return _reviews;
    final rating = int.parse(_selectedFilter.substring(0, 1));
    return _reviews.where((review) => review.rating == rating).toList();
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
          'Movie Reviews',
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
                  Icons.rate_review_rounded,
                  color: AppColors.white,
                  size: 20,
                ),
              ),
              onPressed: _addReview,
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
          // Enhanced Reviews List
          Expanded(
            child: _filteredReviews.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    padding: const EdgeInsets.all(20),
                    itemCount: _filteredReviews.length,
                    itemBuilder: (context, index) {
                      final review = _filteredReviews[index];
                      return _buildReviewCard(review, index);
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: Container(
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
        child: FloatingActionButton(
          onPressed: _addReview,
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: const Icon(
            Icons.rate_review_rounded,
            color: AppColors.white,
            size: 28,
          ),
        ),
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
              Icons.rate_review_outlined,
              size: 70,
              color: isDark ? AppColors.accentBlue : AppColors.primary,
            ),
          ),
          const SizedBox(height: 32),
          Text(
            _selectedFilter == 'All' 
                ? 'No reviews yet'
                : 'No ${_selectedFilter} reviews',
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
                  ? 'Share your thoughts about movies you\'ve watched'
                  : 'Try switching to a different rating filter',
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
              onPressed: _addReview,
              icon: const Icon(
                Icons.rate_review_rounded,
                color: AppColors.white,
                size: 24,
              ),
              label: const Text(
                'Write Review',
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

  Widget _buildReviewCard(Review review, int index) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: isDark 
          ? Border.all(color: AppColors.glassDark.withOpacity(0.3))
          : null,
        boxShadow: [
          BoxShadow(
            color: isDark 
              ? AppColors.black.withOpacity(0.2)
              : AppColors.grey900.withOpacity(0.05),
            blurRadius: isDark ? 8 : 6,
            spreadRadius: 0,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Compact Header
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        review.movieTitle,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: isDark ? AppColors.white : AppColors.grey900,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'by ${review.reviewerName} • ${_formatDate(review.date)}',
                        style: TextStyle(
                          fontSize: 11,
                          color: isDark ? AppColors.grey400 : AppColors.grey600,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                // Compact Rating and actions
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: _getRatingColor(review.rating),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.star_rounded,
                            size: 12,
                            color: AppColors.white,
                          ),
                          const SizedBox(width: 3),
                          Text(
                            review.rating.toString(),
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: AppColors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      decoration: BoxDecoration(
                        color: isDark 
                          ? AppColors.glassDark.withOpacity(0.2)
                          : AppColors.grey100,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: PopupMenuButton<String>(
                        icon: Icon(
                          Icons.more_vert_rounded,
                          color: isDark ? AppColors.grey400 : AppColors.grey500,
                          size: 16,
                        ),
                        onSelected: (value) {
                          if (value == 'delete') {
                            _deleteReview(index);
                          }
                        },
                        itemBuilder: (context) => [
                          const PopupMenuItem(
                            value: 'edit',
                            child: Row(
                              children: [
                                Icon(Icons.edit_rounded, size: 14),
                                SizedBox(width: 6),
                                Text('Edit', style: TextStyle(fontSize: 12)),
                              ],
                            ),
                          ),
                          const PopupMenuItem(
                            value: 'delete',
                            child: Row(
                              children: [
                                Icon(Icons.delete_rounded, size: 14),
                                SizedBox(width: 6),
                                Text('Delete', style: TextStyle(fontSize: 12)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),
            // Compact Review text
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isDark 
                  ? AppColors.glassDark.withOpacity(0.1)
                  : AppColors.grey50,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                review.reviewText,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 12,
                  color: isDark ? AppColors.grey300 : AppColors.grey700,
                  fontWeight: FontWeight.w500,
                  height: 1.4,
                ),
              ),
            ),
            const SizedBox(height: 8),
            // Compact Action buttons
            Row(
              children: [
                _buildActionButton(
                  icon: Icons.thumb_up_rounded,
                  label: 'Helpful',
                  onTap: () {
                    // Handle helpful
                  },
                  isDark: isDark,
                ),
                const SizedBox(width: 12),
                _buildActionButton(
                  icon: Icons.share_rounded,
                  label: 'Share',
                  onTap: () {
                    // Handle share
                  },
                  isDark: isDark,
                ),
                const SizedBox(width: 12),
                _buildActionButton(
                  icon: Icons.flag_rounded,
                  label: 'Report',
                  onTap: () {
                    // Handle report
                  },
                  isDark: isDark,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    required bool isDark,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: isDark 
            ? AppColors.glassDark.withOpacity(0.1)
            : AppColors.grey100,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 12,
              color: isDark ? AppColors.grey400 : AppColors.grey500,
            ),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                color: isDark ? AppColors.grey400 : AppColors.grey500,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getRatingColor(int rating) {
    if (rating >= 4) return AppColors.success;
    if (rating >= 3) return AppColors.warning;
    return AppColors.error;
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);
    
    if (difference.inDays == 0) {
      return 'Today';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}

class _AddReviewDialog extends StatefulWidget {
  final Function(Review) onAdd;

  const _AddReviewDialog({required this.onAdd});

  @override
  State<_AddReviewDialog> createState() => _AddReviewDialogState();
}

class _AddReviewDialogState extends State<_AddReviewDialog> {
  final _movieTitleController = TextEditingController();
  final _reviewTextController = TextEditingController();
  final _reviewerNameController = TextEditingController();
  int _rating = 5;

  @override
  void dispose() {
    _movieTitleController.dispose();
    _reviewTextController.dispose();
    _reviewerNameController.dispose();
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
        'Write Review',
        style: TextStyle(
          fontWeight: FontWeight.w800,
          fontSize: 24,
          color: isDark ? AppColors.white : AppColors.grey900,
          letterSpacing: -0.5,
        ),
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildTextField(
              controller: _movieTitleController,
              label: 'Movie Title',
              icon: Icons.movie_rounded,
              isDark: isDark,
            ),
            const SizedBox(height: 20),
            _buildTextField(
              controller: _reviewerNameController,
              label: 'Your Name',
              icon: Icons.person_rounded,
              isDark: isDark,
            ),
            const SizedBox(height: 20),
            // Enhanced Rating picker
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: isDark 
                  ? AppColors.glassDark.withOpacity(0.1)
                  : AppColors.grey50,
                borderRadius: BorderRadius.circular(16),
                border: isDark 
                  ? Border.all(color: AppColors.glassDark.withOpacity(0.3))
                  : Border.all(color: AppColors.grey200),
              ),
              child: Column(
                children: [
                  Text(
                    'Rating',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: isDark ? AppColors.white : AppColors.grey900,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(5, (index) {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _rating = index + 1;
                          });
                        },
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          child: Icon(
                            index < _rating ? Icons.star_rounded : Icons.star_border_rounded,
                            color: Colors.amber,
                            size: 36,
                          ),
                        ),
                      );
                    }),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            _buildTextField(
              controller: _reviewTextController,
              label: 'Your Review',
              icon: Icons.rate_review_rounded,
              isDark: isDark,
              maxLines: 4,
            ),
          ],
        ),
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
              if (_movieTitleController.text.isNotEmpty &&
                  _reviewTextController.text.isNotEmpty &&
                  _reviewerNameController.text.isNotEmpty) {
                final review = Review(
                  movieTitle: _movieTitleController.text,
                  rating: _rating,
                  reviewText: _reviewTextController.text,
                  reviewerName: _reviewerNameController.text,
                  date: DateTime.now(),
                );
                widget.onAdd(review);
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
              'Submit Review',
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
    int maxLines = 1,
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
        maxLines: maxLines,
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

class Review {
  final String movieTitle;
  final int rating;
  final String reviewText;
  final String reviewerName;
  final DateTime date;

  Review({
    required this.movieTitle,
    required this.rating,
    required this.reviewText,
    required this.reviewerName,
    required this.date,
  });
}
