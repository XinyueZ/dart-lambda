import 'aws/Auth.dart';
import 'aws/Service.dart';
import 'aws/config.dart';
import 'aws/model/Vehicle.dart';

void main() async {
  final auth = await Auth(userPoolId, userClientId);
  try {
    final session = await auth.login(username, password);

    print("$username =>");
    print("JWT-Token: ${session.accessToken.jwtToken}");

    Gateway gateway = Gateway(session.accessToken.jwtToken, area);

    List<Vehicle> list = await gateway.getVehicles();

    print("List =>");
    print("${list}");
  } catch (e) {
    print("Error:");
    print(e);
  }
}
