import 'package:spending_pal/src/config/config/config.dart';
import 'package:spending_pal/src/config/config/firebase_options_dev.dart';
import 'package:spending_pal/src/presentation/common/app/main_common.dart';

Future<void> main() async => mainCommon(
  flavor: Flavor.dev,
  firebaseOptions: DefaultFirebaseOptions.currentPlatform,
);
