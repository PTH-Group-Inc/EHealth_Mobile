import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:e_health/app/route_manager.dart';
import 'package:e_health/app/theme/app_color.dart';
import 'package:e_health/app/app_global_provider.dart';
import 'package:e_health/app/dependency_injection/configure_injectable.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_easyloading_plus/flutter_easyloading_plus.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:e_health/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await initializeDateFormatting('vi_VN', null);
  configureDependencies(environment: 'dev');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return AppGlobalProvider(
      child: MaterialApp.router(
        routerConfig: appRouter,
        builder: EasyLoading.init(),
        title: 'EHealth',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          textTheme: GoogleFonts.beVietnamProTextTheme(),
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.white,
            elevation: 0,
            scrolledUnderElevation: 0,
            surfaceTintColor: Colors.transparent,
            centerTitle: true,
          ),
          colorScheme: ColorScheme.fromSeed(
            seedColor: AppColors.primary,
            primary: AppColors.primary,
          ),
        ),
      ),
    );
  }
}
