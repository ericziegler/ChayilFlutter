import 'package:get_it/get_it.dart';
import 'package:chayil/domain/services/network_service.dart';
import 'package:chayil/domain/services/secure_storage_service.dart';
import 'package:chayil/domain/services/cache_service.dart';
import 'package:chayil/domain/repositories/user_repository.dart';

final getIt = GetIt.instance;

void setupDependencies() {
  // Register services
  getIt.registerLazySingleton<SecureStorageService>(
    () => SecureStorageService(),
  );

  getIt.registerLazySingleton<NetworkService>(
    () => NetworkService(baseUrl: 'https://api.chayilmartialarts.com/v1/'),
  );

  getIt.registerLazySingleton<CacheService>(
    () => CacheService(),
  );

  // Register repositories
  getIt.registerLazySingleton<UserRepository>(
    () => UserRepository(
      networkService: getIt<NetworkService>(),
      secureStorageService: getIt<SecureStorageService>(),
    ),
  );
}
