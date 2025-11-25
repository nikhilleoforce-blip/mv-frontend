import 'package:flutter/material.dart';
import '../../core/utils/app_utils.dart';
import '../../core/constants/app_constants.dart';

class ResponsiveNavigationShell extends StatefulWidget {
  final List<NavigationItem> items;
  final List<Widget> pages;
  final int currentIndex;
  final Function(int) onNavigationChanged;
  final String title;

  const ResponsiveNavigationShell({
    super.key,
    required this.items,
    required this.pages,
    required this.currentIndex,
    required this.onNavigationChanged,
    this.title = 'CineMatch',
  });

  @override
  State<ResponsiveNavigationShell> createState() =>
      _ResponsiveNavigationShellState();
}

class _ResponsiveNavigationShellState extends State<ResponsiveNavigationShell>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = context.isMobile;

        return FadeTransition(
          opacity: _fadeAnimation,
          child: isMobile ? _buildMobileLayout() : _buildWebLayout(),
        );
      },
    );
  }

  Widget _buildMobileLayout() {
    return Scaffold(
      extendBody: true,
      body: IndexedStack(index: widget.currentIndex, children: widget.pages),
      bottomNavigationBar: Container(
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 20),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.black.withValues(alpha: 0.4)
                  : Colors.black.withValues(alpha: 0.1),
              blurRadius: 20,
              spreadRadius: 0,
              offset: const Offset(0, 8),
            ),
            BoxShadow(
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.black.withValues(alpha: 0.2)
                  : Colors.black.withValues(alpha: 0.05),
              blurRadius: 6,
              spreadRadius: 0,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: BottomNavigationBar(
            currentIndex: widget.currentIndex,
            onTap: (index) {
              _animationController.reset();
              _animationController.forward();
              widget.onNavigationChanged(index);
            },
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.transparent,
            selectedItemColor: const Color(0xFF667eea),
            unselectedItemColor: Theme.of(
              context,
            ).colorScheme.onSurface.withValues(alpha: 0.6),
            elevation: 0,
            selectedFontSize: 12,
            unselectedFontSize: 11,
            selectedLabelStyle: const TextStyle(
              fontWeight: FontWeight.w600,
              height: 1.5,
            ),
            unselectedLabelStyle: const TextStyle(
              fontWeight: FontWeight.w500,
              height: 1.5,
            ),
            items: widget.items.asMap().entries.map((entry) {
              final index = entry.key;
              final item = entry.value;
              final isSelected = index == widget.currentIndex;

              return BottomNavigationBarItem(
                icon: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    gradient: isSelected
                        ? const LinearGradient(
                            colors: [Color(0xFF667eea), Color(0xFF764ba2)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          )
                        : null,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    item.icon,
                    size: 24,
                    color: isSelected ? Colors.white : null,
                  ),
                ),
                activeIcon: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF667eea), Color(0xFF764ba2)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    item.activeIcon ?? item.icon,
                    size: 24,
                    color: Colors.white,
                  ),
                ),
                label: item.label,
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  Widget _buildWebLayout() {
    final sidebarWidth = ResponsiveUtils.getNavigationWidth(
      context.screenWidth,
    );

    return Scaffold(
      body: Row(
        children: [
          // Modern Left sidebar navigation
          Container(
            width: sidebarWidth,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: Theme.of(context).brightness == Brightness.dark
                    ? [const Color(0xFF1F2937), const Color(0xFF111827)]
                    : [const Color(0xFFF8FAFC), const Color(0xFFF1F5F9)],
              ),
              border: Border(
                right: BorderSide(
                  color: Theme.of(
                    context,
                  ).colorScheme.outline.withValues(alpha: 0.1),
                  width: 1,
                ),
              ),
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.black.withValues(alpha: 0.2)
                      : Colors.black.withValues(alpha: 0.03),
                  blurRadius: 20,
                  spreadRadius: 0,
                  offset: const Offset(4, 0),
                ),
              ],
            ),
            child: Column(
              children: [
                // Enhanced App title/logo section
                Container(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(
                                0xFF667eea,
                              ).withValues(alpha: 0.3),
                              blurRadius: 10,
                              spreadRadius: 0,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Image.asset(
                          AppConstants.logoPath,
                          width: 40,
                          height: 40,
                          fit: BoxFit.contain,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.title,
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 18,
                                color:
                                    Theme.of(context).brightness ==
                                        Brightness.dark
                                    ? const Color(0xFFF1F5F9)
                                    : const Color(0xFF1E293B),
                                letterSpacing: -0.3,
                              ),
                            ),
                            const SizedBox(height: 1),
                            Text(
                              'Movie Suggestions',
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 10,
                                color:
                                    Theme.of(context).brightness ==
                                        Brightness.dark
                                    ? const Color(0xFF9CA3AF)
                                    : const Color(0xFF64748B),
                                letterSpacing: 0.3,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // Elegant divider
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  height: 1,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.transparent,
                        Theme.of(
                          context,
                        ).colorScheme.outline.withValues(alpha: 0.2),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                // Navigation items with enhanced styling
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    itemCount: widget.items.length,
                    itemBuilder: (context, index) {
                      final item = widget.items[index];
                      final isSelected = index == widget.currentIndex;

                      return Container(
                        margin: const EdgeInsets.only(bottom: 2),
                        child: _NavigationTile(
                          item: item,
                          isSelected: isSelected,
                          onTap: () {
                            _animationController.reset();
                            _animationController.forward();
                            widget.onNavigationChanged(index);
                          },
                        ),
                      );
                    },
                  ),
                ),

                // Footer section
                Container(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    children: [
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          vertical: 8,
                          horizontal: 12,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF667eea).withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: const Color(
                              0xFF667eea,
                            ).withValues(alpha: 0.2),
                          ),
                        ),
                        child: const Row(
                          children: [
                            Icon(
                              Icons.tips_and_updates_outlined,
                              size: 14,
                              color: Color(0xFF667eea),
                            ),
                            SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                'Get personalized movie recommendations',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Color(0xFF667eea),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Main content area with improved styling
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).brightness == Brightness.dark
                    ? const Color(0xFF0F172A)
                    : const Color(0xFFFAFAFA),
              ),
              child: IndexedStack(
                index: widget.currentIndex,
                children: widget.pages,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _NavigationTile extends StatefulWidget {
  final NavigationItem item;
  final bool isSelected;
  final VoidCallback onTap;

  const _NavigationTile({
    required this.item,
    required this.isSelected,
    required this.onTap,
  });

  @override
  State<_NavigationTile> createState() => _NavigationTileState();
}

class _NavigationTileState extends State<_NavigationTile>
    with SingleTickerProviderStateMixin {
  bool _isHovered = false;
  late AnimationController _hoverController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _hoverController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.01).animate(
      CurvedAnimation(parent: _hoverController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _hoverController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) {
        setState(() => _isHovered = true);
        if (!widget.isSelected) _hoverController.forward();
      },
      onExit: (_) {
        setState(() => _isHovered = false);
        _hoverController.reverse();
      },
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          decoration: BoxDecoration(
            gradient: widget.isSelected
                ? const LinearGradient(
                    colors: [Color(0xFF667eea), Color(0xFF764ba2)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                : _isHovered
                ? LinearGradient(
                    colors: [
                      const Color(0xFF667eea).withValues(alpha: 0.1),
                      const Color(0xFF764ba2).withValues(alpha: 0.1),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                : null,
            borderRadius: BorderRadius.circular(8),
            border: widget.isSelected
                ? null
                : _isHovered
                ? Border.all(
                    color: const Color(0xFF667eea).withValues(alpha: 0.3),
                    width: 1,
                  )
                : null,
            boxShadow: widget.isSelected
                ? [
                    BoxShadow(
                      color: const Color(0xFF667eea).withValues(alpha: 0.25),
                      blurRadius: 8,
                      spreadRadius: 0,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : _isHovered
                ? [
                    BoxShadow(
                      color: const Color(0xFF667eea).withValues(alpha: 0.08),
                      blurRadius: 6,
                      spreadRadius: 0,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: ListTile(
            leading: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: widget.isSelected
                    ? Colors.white.withValues(alpha: 0.2)
                    : _isHovered
                    ? const Color(0xFF667eea).withValues(alpha: 0.1)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(6),
              ),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child: Icon(
                  widget.isSelected
                      ? (widget.item.activeIcon ?? widget.item.icon)
                      : widget.item.icon,
                  key: ValueKey(widget.isSelected),
                  color: widget.isSelected
                      ? Colors.white
                      : _isHovered
                      ? const Color(0xFF667eea)
                      : Theme.of(context).brightness == Brightness.dark
                      ? const Color(0xFF9CA3AF)
                      : const Color(0xFF64748B),
                  size: 16,
                ),
              ),
            ),
            title: Text(
              widget.item.label,
              style: TextStyle(
                color: widget.isSelected
                    ? Colors.white
                    : _isHovered
                    ? const Color(0xFF667eea)
                    : Theme.of(context).brightness == Brightness.dark
                    ? const Color(0xFFE2E8F0)
                    : const Color(0xFF334155),
                fontWeight: widget.isSelected
                    ? FontWeight.w600
                    : FontWeight.w500,
                fontSize: 12,
                letterSpacing: 0.1,
              ),
            ),
            onTap: widget.onTap,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 8,
              vertical: 4,
            ),
          ),
        ),
      ),
    );
  }
}

class NavigationItem {
  final IconData icon;
  final IconData? activeIcon;
  final String label;

  const NavigationItem({
    required this.icon,
    this.activeIcon,
    required this.label,
  });
}
