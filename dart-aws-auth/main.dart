import 'package:amazon_cognito_identity_dart/cognito.dart';

/**
    Define pool info and login user info in config.dart

    const userPoolId = "eu-west-1_xxxxx";
    const userClientId = "xxxxxxxx";
    const username = "xyz";
    const password = "some one pwd";

 */
import 'config.dart';

class AWSStuffs {
  CognitoUserPool _userPool;

  AWSStuffs(String userPoolId, String userClientId) {
    _userPool = CognitoUserPool(userPoolId, userClientId);
  }

  Future<CognitoUserSession> login(String username, String password) {
    final user = CognitoUser(username, _userPool);
    final authDetails =
    AuthenticationDetails(username: username, password: password);

    return user.authenticateUser(authDetails);
  }

//  Future<CognitoCredentials> getCredentials(String jwtToken) {
//    final credentials = CognitoCredentials(userPoolId, _userPool);
//    credentials.getAwsCredentials(jwtToken);
//    return Future.value(credentials);
//  }
}

void main() async {
  final aws = await AWSStuffs(userPoolId, userClientId);
  try {
    final session = await aws.login(username, password);

    print("$username =>");
    print("JWT-Token: ${session.accessToken.jwtToken}");

//    final credentials = await aws.getCredentials(session.accessToken.jwtToken);
//    print("accessKeyId: ${credentials.accessKeyId}");
//    print("secretAccessKey: ${credentials.secretAccessKey}");
//    print("sessionToken: ${credentials.sessionToken}");

  } catch (e) {
    print("Error:");
    print(e);
  }
}
