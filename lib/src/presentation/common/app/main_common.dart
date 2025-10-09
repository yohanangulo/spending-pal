import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:spending_pal/src/config/config/config.dart';
import 'package:spending_pal/src/config/config/env.dart';
import 'package:spending_pal/src/config/service_locator/service_locator.dart';
import 'package:spending_pal/src/presentation/common/app/app.dart';
import 'package:spending_pal/src/presentation/common/global/globals.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> mainCommon({
  required Flavor flavor,
  required FirebaseOptions firebaseOptions,
}) async {
  WidgetsFlutterBinding.ensureInitialized();
  await Config.initialize(flavor);
  await configureDependencies();
  await Firebase.initializeApp(options: firebaseOptions);
  await Supabase.initialize(url: Env.supabaseUrl, anonKey: Env.supabaseAnonKey);
  runApp(const Globals(child: App()));
}
