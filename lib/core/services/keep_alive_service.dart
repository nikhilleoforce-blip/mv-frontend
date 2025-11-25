import 'dart:async';
import 'dart:developer' as dev;
import 'package:dio/dio.dart';
import '../services/api_service.dart';

class KeepAliveService {
  static Timer? _timer;
  static const Duration _keepAliveInterval = Duration(
    minutes: 10,
  ); // Ping every 10 minutes

  /// Starts the keep-alive service
  static void start() {
    if (_timer != null) {
      dev.log(
        'Keep-alive service is already running',
        name: 'KeepAliveService',
      );
      return;
    }

    dev.log('Starting keep-alive service', name: 'KeepAliveService');

    // Make an immediate ping when service starts
    _pingServer();

    // Set up periodic pinging
    _timer = Timer.periodic(_keepAliveInterval, (timer) {
      _pingServer();
    });
  }

  /// Stops the keep-alive service
  static void stop() {
    if (_timer != null) {
      _timer!.cancel();
      _timer = null;
      dev.log('Keep-alive service stopped', name: 'KeepAliveService');
    }
  }

  /// Pings the server to keep it alive
  static Future<void> _pingServer() async {
    try {
      dev.log('Pinging server to keep it alive', name: 'KeepAliveService');

      // Try different endpoints to wake up the server
      final endpoints = ['/health', '/', '/api/health', '/ping'];

      for (String endpoint in endpoints) {
        try {
          final response = await ApiService.get(
            endpoint,
            options: Options(
              sendTimeout: Duration(milliseconds: 5000),
              receiveTimeout: Duration(milliseconds: 10000),
            ),
          ).timeout(Duration(seconds: 15));

          dev.log(
            'Keep-alive ping successful on $endpoint: ${response.statusCode}',
            name: 'KeepAliveService',
          );
          return; // Success, no need to try other endpoints
        } catch (endpointError) {
          dev.log(
            'Endpoint $endpoint failed: $endpointError',
            name: 'KeepAliveService',
          );
          continue; // Try next endpoint
        }
      }

      // If all endpoints failed, log it
      dev.log('All keep-alive endpoints failed', name: 'KeepAliveService');
    } catch (e) {
      dev.log('Keep-alive ping failed: $e', name: 'KeepAliveService');
      // Don't throw error - we don't want to crash the app if ping fails
    }
  }

  /// Force a ping immediately (useful for when app comes to foreground)
  static Future<void> forcePing() async {
    dev.log('Force pinging server', name: 'KeepAliveService');
    await _pingServer();
  }

  /// Check if the service is currently running
  static bool get isRunning => _timer != null && _timer!.isActive;
}
