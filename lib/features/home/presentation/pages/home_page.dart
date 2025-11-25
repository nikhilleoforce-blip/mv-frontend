import 'package:flutter/material.dart';
import '../../../../shared/widgets/responsive_navigation_shell.dart';
import '../../../chat/presentation/pages/chat_page.dart';
import '../../../watchlist/presentation/pages/watchlist_page.dart';
import '../../../review/presentation/pages/review_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  
  final List<Widget> _pages = [
    const ChatPage(),
    const WatchListPage(),
    const ReviewPage(),
  ];

  final List<NavigationItem> _navigationItems = [
    const NavigationItem(
      icon: Icons.chat_outlined,
      activeIcon: Icons.chat,
      label: 'Chat',
    ),
    const NavigationItem(
      icon: Icons.movie_outlined,
      activeIcon: Icons.movie,
      label: 'Watchlist',
    ),
    const NavigationItem(
      icon: Icons.rate_review_outlined,
      activeIcon: Icons.rate_review,
      label: 'Review',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return ResponsiveNavigationShell(
      title: widget.title,
      items: _navigationItems,
      pages: _pages,
      currentIndex: _currentIndex,
      onNavigationChanged: (index) {
        setState(() {
          _currentIndex = index;
        });
      },
    );
  }
}
