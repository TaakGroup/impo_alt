import 'package:get/get.dart';
import 'package:taakitecture/taakitecture.dart';

class ServiceDataSource extends BaseRemoteDatasource {
  ServiceDataSource({required super.client, required super.path, required super.model});
}

class ServiceRepository extends BaseRemoteRepository {
  ServiceRepository(super.remoteDataSource, super.networkInfo);
}

class ServiceController<Model extends BaseModel> extends BaseController<Model> {
  ServiceController({required String path, required Model model})
      : super(
          ServiceRepository(
            ServiceDataSource(client: Get.find(), path: path, model: model),
            Get.find(),
          ),
        );
}
