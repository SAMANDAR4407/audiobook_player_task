import 'package:audio_service/audio_service.dart';
import 'package:audiobook_player/bloc/detail/detail_bloc.dart';
import 'package:audiobook_player/bloc/saved/saved_bloc.dart';
import 'package:audiobook_player/di/get_it.dart';
import 'package:audiobook_player/pages/navigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/home/home_bloc.dart';
import 'core/audio_helper.dart';

late AudioHandler audioHandler;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setup();
  audioHandler = await initAudioService();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => HomeBloc(),
        ),
        BlocProvider(
          create: (context) => DetailBloc(),
        ),
        BlocProvider(
          create: (context) => SavedBloc(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Audiobooks',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const Navigation(),
      ),
    );
  }
}