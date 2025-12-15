import 'dart:html' as html;

/// Web implementation for injecting Client ID into HTML meta tag
void injectClientIdToHtml(String clientId) {
  final metaTag = html.document.querySelector('meta[name="google-signin-client_id"]');
  if (metaTag != null) {
    metaTag.setAttribute('content', clientId);
  }
}
