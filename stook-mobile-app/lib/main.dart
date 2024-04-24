import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart' as bloc_concurrency;
import 'package:intl/date_symbol_data_local.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:loader_overlay/loader_overlay.dart';

import 'src/common/infrastructure/bloc_global_observer.dart';
import 'src/common/infrastructure/di_configurator.dart';
import 'src/common/themes/dark_theme.dart';
import 'src/common/themes/light_theme.dart';
import 'src/common/widget/app.dart';
import 'src/feature/calendar/bloc/calendar_bloc.dart';
import 'src/feature/notes/bloc/note_bloc.dart';
import 'src/feature/resources/bloc/resource_bloc.dart';
import 'src/feature/schedule_put/bloc/schedule_put_bloc.dart';
import 'src/feature/tasks/bloc/task_bloc.dart';

/// Точка входа в приложение.
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  DiConfigurator.configure();
  await initializeDateFormatting('ru_RU', null);
  Bloc.observer = BlocGlobalObserver();
  Bloc.transformer = bloc_concurrency.sequential();

  final savedTheme = await AdaptiveTheme.getThemeMode();
  runApp(MyApp(savedTheme: savedTheme));
}

/// Главный виджет приложения.
class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
    this.savedTheme,
  });

  final AdaptiveThemeMode? savedTheme;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ISchedulePutBloc>(
          create: (context) => injector.get<ISchedulePutBloc>(),
        ),
        BlocProvider<ICalendarBloc>(
          create: (context) => injector.get<ICalendarBloc>(),
        ),
        BlocProvider<ITaskBloc>(
          create: (context) => injector.get<ITaskBloc>(),
        ),
        BlocProvider<INoteBloc>(
          create: (context) => injector.get<INoteBloc>(),
        ),
        BlocProvider<IResourceBloc>(
          create: (context) => injector.get<IResourceBloc>(),
        ),
      ],
      child: AdaptiveTheme(
        light: lightThemeData,
        dark: darkThemeData,
        initial: savedTheme ?? AdaptiveThemeMode.light,
        builder: (light, dark) => MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Stook Mobile App',
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('ru', 'RU'),
          ],
          theme: light,
          darkTheme: dark,
          home: LoaderOverlay(
            overlayColor: Colors.white.withOpacity(0.75),
            child: const App(),
          ),
        ),
      ),
    );
  }
}
