import 'package:injectable/injectable.dart';
import 'package:spending_pal/src/config/database/app_database.dart';
import 'package:uuid/uuid.dart';

@module
abstract class AppDatabaseModule {
  @singleton
  AppDatabase get appDatabase => AppDatabase();

  @lazySingleton
  Uuid get uuid => const Uuid();
}
