import 'package:picsum_photos/config.dart';
import 'package:picsum_photos/domain/photo_list.dart';
import 'package:picsum_photos/service/gateway.dart';
import 'package:picsum_photos/service/http_client_provider.dart';
import 'package:sprintf/sprintf.dart';

main() async {
  final Service service = Service(HttpClientProvider());

  for (int page = START_PAGE; page < 20; page++) {
    final PhotoList photoList = await service.getPhotoList(page, DEFAULT_LIMIT);
    print("===========================================================");
    print(sprintf("page: %d (0 based index), limit: %d", [page, DEFAULT_LIMIT]));
    print("===========================================================");
    print(photoList);
  }
}
