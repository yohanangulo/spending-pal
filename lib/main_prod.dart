import 'package:spending_pal/src/config/config/config.dart';
import 'package:spending_pal/src/config/config/firebase_options_prod.dart';
import 'package:spending_pal/src/presentation/common/app/main_common.dart';

Future<void> main() async => mainCommon(
  flavor: Flavor.prod,
  firebaseOptions: DefaultFirebaseOptions.currentPlatform,
);
