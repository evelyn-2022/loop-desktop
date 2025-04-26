import 'dart:async';
import 'dart:io';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:url_launcher/url_launcher.dart';

class OAuthService {
  HttpServer? _server;

  Future<int> startLocalServer() async {
    _server = await HttpServer.bind(
        InternetAddress.loopbackIPv4, 0);
    return _server!.port;
  }

  Future<String?> listenForAuthCode() async {
    if (_server == null) return null;

    final completer = Completer<String?>();

    _server!.listen((HttpRequest request) async {
      final uri = request.uri;
      final code = uri.queryParameters['code'];

      if (code != null) {
        completer.complete(code);

        request.response
          ..statusCode = 200
          ..headers.set('Content-Type', 'text/html')
          ..write(
              // TODO: Change this to a more user-friendly page
              '<h1>Login successful! You can close this window.</h1>')
          ..close();
      } else {
        completer.complete(null);

        request.response
          ..statusCode = 400
          ..headers.set('Content-Type', 'text/html')
          ..write('<h1>Login failed.</h1>')
          ..close();
      }

      await _server!.close();
      _server = null;
    });

    return completer.future;
  }

  Future<String?> loginWithGoogle() async {
    final port = await startLocalServer();

    final params = {
      'client_id': dotenv.env['GOOGLE_CLIENT_ID'],
      'redirect_uri': 'http://localhost:$port',
      'response_type': 'code',
      'scope': 'openid email profile',
    };

    final url = Uri.https('accounts.google.com',
            '/o/oauth2/v2/auth', params)
        .toString();

    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url),
          mode: LaunchMode.externalApplication);

      final code = await listenForAuthCode();
      if (code != null) {
        print('🔥🔥 Authorization code received: $code');
        print('port is: $port');
        return code;
      } else {
        print('Failed to receive code');
      }
    } else {
      throw 'Could not launch $url';
    }
  }
}
