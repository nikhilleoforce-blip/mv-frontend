import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ResponsiveUtils {
  // Breakpoint constants
  static const double mobileBreakpoint = 768;
  static const double tabletBreakpoint = 1024;
  
  static bool isMobile(double width) => width < mobileBreakpoint;
  static bool isTablet(double width) => width >= mobileBreakpoint && width < tabletBreakpoint;
  static bool isDesktop(double width) => width >= tabletBreakpoint;
  static bool isWeb() => kIsWeb;
  
  // Check if the current platform should use mobile layout
  static bool shouldUseMobileLayout(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return isMobile(screenWidth);
  }
  
  // Check if the current platform should use desktop layout
  static bool shouldUseDesktopLayout(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return isDesktop(screenWidth) || (isWeb() && !isMobile(screenWidth));
  }
  
  static double getResponsiveFontSize(double width, {
    double mobile = 14,
    double tablet = 16,
    double desktop = 18,
  }) {
    if (isMobile(width)) return mobile;
    if (isTablet(width)) return tablet;
    return desktop;
  }
  
  static double getResponsivePadding(double width, {
    double mobile = 16,
    double tablet = 24,
    double desktop = 32,
  }) {
    if (isMobile(width)) return mobile;
    if (isTablet(width)) return tablet;
    return desktop;
  }

  // Get responsive navigation width for sidebar
  static double getNavigationWidth(double screenWidth) {
    if (isMobile(screenWidth)) return 0; // No sidebar on mobile
    if (isTablet(screenWidth)) return 240;
    return 280; // Desktop
  }
}

// Extension for easier responsive checking in widgets
extension ResponsiveExtension on BuildContext {
  bool get isMobile => ResponsiveUtils.shouldUseMobileLayout(this);
  bool get isDesktop => ResponsiveUtils.shouldUseDesktopLayout(this);
  bool get isTablet => !isMobile && !isDesktop;
  
  double get screenWidth => MediaQuery.of(this).size.width;
  double get screenHeight => MediaQuery.of(this).size.height;
}

class ValidationUtils {
  static bool isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }
  
  static bool isValidPhone(String phone) {
    return RegExp(r'^[+]?[0-9]{10,15}$').hasMatch(phone);
  }
  
  static bool isValidPassword(String password) {
    // At least 8 characters, 1 uppercase, 1 lowercase, 1 number
    return RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[a-zA-Z\d@$!%*?&]{8,}$')
        .hasMatch(password);
  }
}

class DateTimeUtils {
  static String formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
  
  static String formatTime(DateTime time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }
  
  static String timeAgo(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);
    
    if (difference.inDays > 7) {
      return formatDate(date);
    } else if (difference.inDays > 0) {
      return '${difference.inDays} day${difference.inDays > 1 ? 's' : ''} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hour${difference.inHours > 1 ? 's' : ''} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minute${difference.inMinutes > 1 ? 's' : ''} ago';
    } else {
      return 'Just now';
    }
  }
}
