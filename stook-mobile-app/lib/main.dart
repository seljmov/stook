import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart' as bloc_concurrency;
import 'package:intl/date_symbol_data_local.dart';
import 'package:loader_overlay/loader_overlay.dart';

import 'src/common/infrastructure/bloc_global_observer.dart';
import 'src/common/infrastructure/di_configurator.dart';
import 'src/common/widget/app.dart';
import 'src/feature/schedule_put/bloc/schedule_put_bloc.dart';

/// Точка входа в приложение.
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  DiConfigurator.configure();
  await initializeDateFormatting('ru_RU', null);
  Bloc.observer = BlocGlobalObserver();
  Bloc.transformer = bloc_concurrency.sequential();
  runApp(const MyApp());
}

/// Главный виджет приложения.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ISchedulePutBloc>(
          create: (context) => injector.get<ISchedulePutBloc>(),
        ),
      ],
      child: MaterialApp(
        title: 'Stook Mobile App',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: LoaderOverlay(
          overlayColor: Colors.white.withOpacity(0.75),
          child: const App(),
        ),
      ),
    );
  }
}
