import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'features/pokemon/data/models/pokemon_list_item_model.dart';
import 'features/pokemon/presentation/screens/splash_screen.dart';
import 'features/pokemon/presentation/cubit/home_cubit.dart';
import 'core/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  await Hive.initFlutter();
  Hive.registerAdapter(PokemonListItemModelAdapter());
  await Hive.openBox<PokemonListItemModel>('pokemon_master_list');

  runApp(
    BlocProvider<HomeCubit>(
      create: (_) => HomeCubit()..loadInitialData(),
      child: const PokemonApp(),
    ),
  );
}

class PokemonApp extends StatelessWidget {
  const PokemonApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smart Combat Analytics',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: const DynamicSplashScreen(),
    );
  }
}
