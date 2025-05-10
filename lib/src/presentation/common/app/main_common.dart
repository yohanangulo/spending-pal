import 'package:flutter/material.dart';
import 'package:spending_pal/src/config/config/config.dart';
import 'package:spending_pal/src/presentation/common/app/app.dart';

Future<void> mainCommon(Flavor flavor) async {
  await Config.initialize(flavor);
  runApp(const App());
}
