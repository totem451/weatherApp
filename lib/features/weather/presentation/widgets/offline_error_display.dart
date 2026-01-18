import 'package:flutter/material.dart';

class OfflineErrorDisplay extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  final bool isFullPage;

  const OfflineErrorDisplay({
    super.key,
    required this.message,
    required this.onRetry,
    this.isFullPage = true,
  });

  @override
  Widget build(BuildContext context) {
    final isOffline =
        message.toLowerCase().contains('internet') ||
        message.toLowerCase().contains('connection');

    final content = Padding(
      padding: EdgeInsets.all(isFullPage ? 32.0 : 16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            isOffline ? Icons.cloud_off : Icons.error_outline,
            size: isFullPage ? 64 : 48,
            color: Colors.white54,
          ),
          const SizedBox(height: 16),
          Text(
            isOffline ? "No Internet Connection" : "An error occurred",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: isFullPage ? 18 : 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white70, fontSize: 13),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: onRetry,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white24,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: const Text("Retry"),
          ),
        ],
      ),
    );

    if (isFullPage) {
      return SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: SizedBox(height: 400, child: Center(child: content)),
      );
    } else {
      return content;
    }
  }
}
