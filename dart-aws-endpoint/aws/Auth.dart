import 'package:amazon_cognito_identity_dart/cognito.dart';

class Auth {
  CognitoUserPool _userPool;

  Auth(String userPoolId, String userClientId) {
    _userPool = CognitoUserPool(userPoolId, userClientId);
  }

  Future<CognitoUserSession> login(String username, String password) {
    final user = CognitoUser(username, _userPool);
    final authDetails =
        AuthenticationDetails(username: username, password: password);

    return user.authenticateUser(authDetails);
  }
}
