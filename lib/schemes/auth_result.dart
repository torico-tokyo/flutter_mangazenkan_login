import 'package:mangazenkan_login/src/mangazenkan_login.dart';

class AuthResult {
  // The access token for using the Mangazenkan APIs
  final String _accessToken;

  // The status after a Mangazenkan login flow has completed
  final LoginStatus _status;

  // The error message when the log in flow completed with an error
  final String _errorMessage;

  AuthResult({
    String accessToken,
    LoginStatus status,
    String errorMessage,
  })  : this._accessToken = accessToken,
        this._status = status,
        this._errorMessage = errorMessage;

  String get accessToken => _accessToken;
  LoginStatus get status => _status;
  String get errorMessage => _errorMessage;
}
