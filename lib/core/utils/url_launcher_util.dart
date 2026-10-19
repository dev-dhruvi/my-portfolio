import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

/// Helper to safely launch external URLs, mailto, tel, and web paths.
class UrlLauncherUtil {
  UrlLauncherUtil._();

  static Future<bool> openUrl(String urlString, {BuildContext? context}) async {
    if (urlString.trim().isEmpty) return false;
    try {
      final uri = Uri.parse(urlString.trim());
      final success = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
      if (!success && context != null && context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Could not open: $urlString')));
      }
      return success;
    } catch (e) {
      if (context != null && context.mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Failed to launch URL: $e')));
      }
      return false;
    }
  }

  static Future<bool> openEmail(
    String email, {
    String? subject,
    String? body,
  }) async {
    final query = <String, String>{};
    if (subject != null && subject.isNotEmpty) query['subject'] = subject;
    if (body != null && body.isNotEmpty) query['body'] = body;

    final uri = Uri(
      scheme: 'mailto',
      path: email,
      queryParameters: query.isEmpty ? null : query,
    );
    try {
      return await launchUrl(uri);
    } catch (_) {
      return false;
    }
  }
}
