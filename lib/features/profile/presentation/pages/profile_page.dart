import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  final String _userName = 'John Doe';
  final String _userEmail = 'johndoe@example.com';
  final int _watchedMovies = 142;
  final int _favoriteMovies = 28;
  final int _reviewsWritten = 15;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: CustomScrollView(
            slivers: [
              // Custom App Bar with Profile Header
              SliverAppBar(
                expandedHeight: 280,
                floating: false,
                pinned: true,
                backgroundColor: AppColors.primary,
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          AppColors.primary,
                          AppColors.secondary,
                        ],
                      ),
                    ),
                    child: SafeArea(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(height: 60),
                          
                          // Profile Avatar
                          Container(
                            width: 120,
                            height: 120,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.white,
                                width: 4,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  blurRadius: 20,
                                  offset: const Offset(0, 10),
                                ),
                              ],
                            ),
                            child: ClipOval(
                              child: Container(
                                color: Colors.white,
                                child: Icon(
                                  Icons.person,
                                  size: 60,
                                  color: AppColors.grey400,
                                ),
                              ),
                            ),
                          ),
                          
                          const SizedBox(height: 16),
                          
                          // User Name
                          Text(
                            _userName,
                            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          
                          const SizedBox(height: 4),
                          
                          // User Email
                          Text(
                            _userEmail,
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Colors.white.withOpacity(0.8),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              
              // Profile Content
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Statistics Cards
                      _buildStatsSection(),
                      
                      const SizedBox(height: 24),
                      
                      // Recent Activity Section
                      _buildSectionHeader('Recent Activity'),
                      _buildRecentActivityCard(),
                      
                      const SizedBox(height: 24),
                      
                      // Achievements Section
                      _buildSectionHeader('Achievements'),
                      _buildAchievementsSection(),
                      
                      const SizedBox(height: 24),
                      
                      // Profile Actions
                      _buildSectionHeader('Profile'),
                      _buildProfileActions(),
                      
                      const SizedBox(height: 24),
                      
                      // Account Actions
                      _buildSectionHeader('Account'),
                      _buildAccountActions(),
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

  Widget _buildStatsSection() {
    return Row(
      children: [
        Expanded(child: _buildStatCard('Movies Watched', _watchedMovies, Icons.movie, AppColors.primary)),
        const SizedBox(width: 12),
        Expanded(child: _buildStatCard('Favorites', _favoriteMovies, Icons.favorite, AppColors.error)),
        const SizedBox(width: 12),
        Expanded(child: _buildStatCard('Reviews', _reviewsWritten, Icons.rate_review, AppColors.secondary)),
      ],
    );
  }

  Widget _buildStatCard(String title, int value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(height: 8),
          Text(
            value.toString(),
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.grey900,
            ),
          ),
          Text(
            title,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppColors.grey600,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.bold,
          color: AppColors.grey900,
        ),
      ),
    );
  }

  Widget _buildRecentActivityCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildActivityItem(
              'Added "Inception" to watchlist',
              '2 hours ago',
              Icons.add_circle_outline,
              AppColors.success,
            ),
            const Divider(height: 24),
            _buildActivityItem(
              'Reviewed "The Dark Knight"',
              '1 day ago',
              Icons.rate_review,
              AppColors.secondary,
            ),
            const Divider(height: 24),
            _buildActivityItem(
              'Marked "Pulp Fiction" as watched',
              '3 days ago',
              Icons.check_circle_outline,
              AppColors.primary,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActivityItem(String title, String time, IconData icon, Color color) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                time,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.grey600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAchievementsSection() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _buildAchievementBadge('Movie Buff', '100+ movies watched', Icons.local_movies, true),
          const SizedBox(width: 12),
          _buildAchievementBadge('Critic', '10+ reviews written', Icons.rate_review, true),
          const SizedBox(width: 12),
          _buildAchievementBadge('Genre Explorer', 'Watch 5 different genres', Icons.explore, false),
          const SizedBox(width: 12),
          _buildAchievementBadge('Night Owl', 'Watch 10 movies after midnight', Icons.nights_stay, false),
        ],
      ),
    );
  }

  Widget _buildAchievementBadge(String title, String description, IconData icon, bool achieved) {
    return Container(
      width: 140,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: achieved ? AppColors.primary.withOpacity(0.1) : AppColors.grey100,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: achieved ? AppColors.primary : AppColors.grey300,
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            size: 32,
            color: achieved ? AppColors.primary : AppColors.grey400,
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: achieved ? AppColors.primary : AppColors.grey500,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            description,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: achieved ? AppColors.grey700 : AppColors.grey500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildProfileActions() {
    return Column(
      children: [
        _buildActionTile(
          title: 'Edit Profile',
          subtitle: 'Update your personal information',
          icon: Icons.edit,
          onTap: () {
            // TODO: Navigate to edit profile
          },
        ),
        _buildActionTile(
          title: 'Preferences',
          subtitle: 'Customize your movie preferences',
          icon: Icons.tune,
          onTap: () {
            // TODO: Navigate to preferences
          },
        ),
        _buildActionTile(
          title: 'Privacy Settings',
          subtitle: 'Manage your privacy and data',
          icon: Icons.privacy_tip,
          onTap: () {
            // TODO: Navigate to privacy settings
          },
        ),
      ],
    );
  }

  Widget _buildAccountActions() {
    return Column(
      children: [
        _buildActionTile(
          title: 'Export Data',
          subtitle: 'Download your watchlist and reviews',
          icon: Icons.download,
          onTap: () {
            // TODO: Export data
          },
        ),
        _buildActionTile(
          title: 'Help & Support',
          subtitle: 'Get help with your account',
          icon: Icons.help_outline,
          onTap: () {
            // TODO: Navigate to help
          },
        ),
        _buildActionTile(
          title: 'Sign Out',
          subtitle: 'Sign out of your account',
          icon: Icons.logout,
          color: AppColors.error,
          onTap: () {
            _showSignOutDialog();
          },
        ),
      ],
    );
  }

  Widget _buildActionTile({
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onTap,
    Color? color,
  }) {
    final tileColor = color ?? AppColors.grey700;
    
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: tileColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: tileColor, size: 20),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: tileColor,
          ),
        ),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }

  void _showSignOutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sign Out'),
        content: const Text('Are you sure you want to sign out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // TODO: Implement sign out logic
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
            ),
            child: const Text('Sign Out'),
          ),
        ],
      ),
    );
  }
}
