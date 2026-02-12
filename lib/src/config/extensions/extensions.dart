import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spending_pal/src/config/translations/l10n.dart' as localization;
import 'package:spending_pal/src/config/translations/l10n/generated/l10n.dart';
import 'package:spending_pal/src/core/categories/domain.dart';
import 'package:spending_pal/src/presentation/common/screen_wrapper/screen_wrapper.dart';
import 'package:spending_pal/src/presentation/core/auth/auth_bloc.dart';
import 'package:spending_pal/src/presentation/screens/categories/categories_screen.dart';

export 'package:go_router/src/misc/extensions.dart';

export 'category_color_extensions.dart';
export 'category_icon_extensions.dart';

part 'brightness_extensions.dart';
part 'build_context_extensions.dart';
part 'locale_extensions.dart';
part 'user_extensions.dart';
part 'date_time_extensions.dart';
