import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:visit_tracker/data/remote/api/DioApiService.dart';
import 'package:visit_tracker/features/visit_tracker/domain/bloc/VisitBloc.dart';

import 'common/bloc_utils.dart';
import 'common/size_config.dart';
import 'features/visit_tracker/domain/repository/MainRepository.dart';
import 'features/visit_tracker/domain/repository/MainRepositoryImplementation.dart';
import 'features/visit_tracker/presentation/pages/VisitListingPage.dart';

Future<void> main() async {
  await dotenv.load();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<MainRepository>(
            create: (_) => MainRepositoryImplementation(
              DioApiService(),
            ))
      ],
      child: Builder(
          builder: (context) {
            return MultiBlocProvider(
              providers: [
                BlocProvider(
                    create: (_) =>
                    VisitsBloc(RepositoryProvider.of<MainRepository>(context))
                      ..add(EmptyEvent())),
              ],
              child: MaterialApp(
                title: 'Visit Tracker',
                debugShowCheckedModeBanner: false,
                theme: ThemeData(
                    useMaterial3: false,
                    primaryColor: Colors.blueAccent,
                    appBarTheme:
                    const AppBarTheme(titleTextStyle: TextStyle(fontSize: 18)),
                    colorScheme: const ColorScheme.light(
                      primary: Colors.blueAccent,
                      secondary: Colors.lightGreen,
                      background: Colors.white,
                    ).copyWith(primary: Colors.blueAccent, background: Colors.white)),
                home: Visitlistingpage(),
              ),
            );
          }
      ),
    );
  }
}


