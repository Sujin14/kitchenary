import 'package:url_launcher/url_launcher.dart';

/// Opens web pages and external apps.
class UrlLauncherService {
  const UrlLauncherService();

  /// Opens [url] in the browser or the app registered for it. Returns false
  /// when the link is invalid or cannot be opened.
  Future<bool> open(String url) async {
    final uri = Uri.tryParse(url.trim());
    if (uri == null || !uri.hasScheme) return false;
    try {
      return await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (_) {
      return false;
    }
  }
}
