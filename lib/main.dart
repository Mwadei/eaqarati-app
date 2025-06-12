import 'package:eaqarati_app/config/app_routes.dart';
import 'package:eaqarati_app/config/app_theme.dart';
import 'package:eaqarati_app/core/services/settings_service.dart';
import 'package:eaqarati_app/features/presentation/blocs/annual_financial_statement/annual_financial_statement_bloc.dart';
import 'package:eaqarati_app/features/presentation/blocs/lease/lease_bloc.dart';
import 'package:eaqarati_app/features/presentation/blocs/payment/payment_bloc.dart';
import 'package:eaqarati_app/features/presentation/blocs/property/property_bloc.dart';
import 'package:eaqarati_app/features/presentation/blocs/scheduled_payment/scheduled_payment_bloc.dart';
import 'package:eaqarati_app/features/presentation/blocs/settings/settings_bloc.dart';
import 'package:eaqarati_app/features/presentation/blocs/tenant/tenant_bloc.dart';
import 'package:eaqarati_app/features/presentation/blocs/units/units_bloc.dart';
import 'package:eaqarati_app/injection_container.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  await init();
  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('ar'), Locale('en')],
      fallbackLocale: const Locale('ar'),
      startLocale: const Locale('ar'),
      path: 'assets/translations',
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final initialThemeMode = sl<SettingsService>().themeMode;
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => sl<SettingsBloc>()..add(LoadInitialSettings()),
        ),
        BlocProvider(create: (_) => sl<PropertyBloc>()),
        BlocProvider(create: (_) => sl<UnitsBloc>()),
        BlocProvider(create: (_) => sl<TenantBloc>()),
        BlocProvider(create: (_) => sl<LeaseBloc>()),
        BlocProvider(create: (_) => sl<ScheduledPaymentBloc>()),
        BlocProvider(create: (_) => sl<PaymentBloc>()),
        BlocProvider(create: (_) => sl<FinancialStatementBloc>()),
      ],
      child: BlocBuilder<SettingsBloc, SettingsState>(
        builder: (context, settingsState) {
          ThemeMode currentThemeMode = initialThemeMode;
          if (settingsState is SettingsLoaded) {
            currentThemeMode = settingsState.themeMode;
          }
          return MaterialApp.router(
            localizationsDelegates: context.localizationDelegates,
            supportedLocales: context.supportedLocales,
            locale: context.locale,
            title: 'Eaqarati app',
            theme: AppTheme().lightTheme(context),
            darkTheme: AppTheme().darkTheme(context),
            themeMode: ThemeMode.system,
            routerConfig: AppRouter.router,
          );
        },
      ),
    );
  }
}
