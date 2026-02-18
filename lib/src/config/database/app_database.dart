import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:spending_pal/src/core/categories/infrastructure.dart';
import 'package:spending_pal/src/core/common/common.dart';
import 'package:spending_pal/src/core/transaction/src/infrastructure/datasources/local/transactions_table.dart';

part 'app_database.g.dart';

@DriftDatabase(tables: [Categories, Transactions, SyncStates])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  static QueryExecutor _openConnection() {
    return driftDatabase(
      name: 'database',
      native: const DriftNativeOptions(
        databaseDirectory: getApplicationSupportDirectory,
      ),
    );
  }

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) async {
        await m.createAll();
      },
      onUpgrade: (Migrator m, int from, int to) async {
        if (from < 2) {
          await m.createTable(syncStates);
        }
      },
    );
  }
}
