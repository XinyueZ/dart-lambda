import 'dart:core';

import 'aws/Auth.dart';
import 'aws/Service.dart';
import 'aws/config.dart';

class App {
  void loadCars(String area) async {
    final auth = await Auth(userPoolId, userClientId);
    try {
      final session = await auth.login(username, password);

      print("$username =>");
      print("JWT-Token: ${session.accessToken.jwtToken}");

      Gateway gateway = Gateway(temp_token, area);

      final list = await gateway.getCars();

      print("List =>");
      print("${list}");
    } catch (e) {
      print("Error:");
      print(e);
    }
  }
}

void run(App app) {
  app.loadCars(area_h);
  app.loadCars(area_hh);
}

void main() {
  run(App());
}
