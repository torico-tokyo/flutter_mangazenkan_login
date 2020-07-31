import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:mangazenkan_login/schemes/auth_result.dart';
import 'package:mangazenkan_login/src/chrome_custom_tab.dart';

/// The status after a Twitter login flow has completed.
enum LoginStatus {
  /// The login was successful and the user is now logged in.
  loggedIn,

  /// The user cancelled the login flow.
  cancelledByUser,

  /// The Twitter login completed with an error
  error,
}

class MangazenkanLogin {
  // Client ID
  final String clientId;

  // Redirect URI
  final String redirectURI;

  // ResponseType
  final List<String> responseType;

  static const MethodChannel _methodChannel =
      const MethodChannel('mangazenkan_login');
  static const EventChannel _eventChannel =
      const EventChannel('mangazenkan_login/event');
  static final Stream<dynamic> _eventStream =
      _eventChannel.receiveBroadcastStream();

  MangazenkanLogin({
    this.clientId,
    this.redirectURI,
    this.responseType,
  });

  Future<AuthResult> login() async {
    try {
      final authorizeURI = getAuthorizeURI();
      String resultURI = '';

      if (Platform.isIOS) {
        resultURI = await _methodChannel.invokeMethod('authentication', {
          'url': authorizeURI,
          'redirectURL': redirectURI,
        });
      } else if (Platform.isAndroid) {
        final uri = Uri.parse(redirectURI);
        await _methodChannel.invokeMethod('setScheme', uri.scheme);
        final completer = Completer<String>();
        final subscribe = _eventStream.listen((data) async {
          if (data['type'] == 'url') {
            completer.complete(data['url']?.toString());
          }
        });
        final browser = ChromeCustomTab(onClose: () {
          if (!completer.isCompleted) {
            completer.complete(null);
          }
        });
        await browser.open(url: authorizeURI.toString());
        resultURI = await completer.future;
        subscribe.cancel();
      } else {
        throw Exception('not supported');
      }

      if (resultURI?.isEmpty ?? true) {
        return AuthResult(
          accessToken: null,
          status: LoginStatus.cancelledByUser,
          errorMessage: 'The user cancelled the login flow',
        );
      }
      // custom Links からToken を取得する
      final params = {};
      final query = resultURI.split('#').last.split('&');
      query.forEach((value) {
        final k = value.split('=').first;
        final v = value.split('=').last;
        params[k] = v;
      });

      if (params['access_token'].isEmpty ?? true) {
        return AuthResult(
          accessToken: null,
          status: LoginStatus.error,
          errorMessage: 'Failed to login',
        );
      }
      return AuthResult(
        accessToken: params['access_token'],
        status: LoginStatus.loggedIn,
        errorMessage: '',
      );
    } catch (error) {
      return AuthResult(
        accessToken: null,
        status: LoginStatus.error,
        errorMessage: error?.toString(),
      );
    }
  }

  String getAuthorizeURI() {
    final params = {
      'client_id': clientId,
      'redirect_uri': redirectURI,
      'response_type': responseType.join(',')
    };
    final query = Uri.encodeQueryComponent('?${getQueryString(params)}');
    return 'https://login.mangazenkan.com/login/?next=/o/authorize/$query';
  }

  String getQueryString(Map<String, dynamic> obj) {
    return obj.keys.map((key) => '$key=${obj[key]}').toList().join('&');
  }
}
