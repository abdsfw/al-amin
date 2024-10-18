import 'package:alaminedu/features/JCI/data/repo/jci_repo.dart';
import 'package:alaminedu/features/JCI/data/repo/jci_repo_impl.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import '../../features/collages/data/repo/college_repo_impl.dart';
import '../../features/home/data/repo/home_repo_impl.dart';
import '../notifications/notification_services.dart';
import 'api_service.dart';

final getIt = GetIt.instance;
void setupServiceLocator() {
  getIt.registerSingleton<ApiService>(
    ApiService(
      Dio(),
    ),
  );
  getIt.registerSingleton<CollegeRepoImpl>(
    CollegeRepoImpl(getIt.get<ApiService>()),
  );
  getIt.registerSingleton<JCIRepo>(
    JCIRepoImpl(),
  );
  getIt.registerSingleton<HomeRepoImpl>(
    HomeRepoImpl(getIt.get<ApiService>()),
  );
  getIt.registerSingleton<NotificationServices>(
    NotificationServices(),
  );
}
