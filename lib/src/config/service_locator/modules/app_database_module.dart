import 'package:injectable/injectable.dart';
import 'package:spending_pal/src/config/database/app_database.dart';

@module
abstract class AppDatabaseModule {
  @singleton
  AppDatabase get appDatabase => AppDatabase();
}
