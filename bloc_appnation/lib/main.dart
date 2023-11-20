import 'package:bloc_appnation/bloc/bloc_management.dart';
import 'package:bloc_appnation/feature/home_page.dart';
import 'package:bloc_appnation/feature/settings_screen.dart';
import 'package:bloc_appnation/feature/splash_screen.dart';
import 'package:bloc_appnation/service/dog_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider(create: (context) => DogApiService()),
        BlocProvider(
            create: (context) => DogBreedBloc(
                apiService:
                    Provider.of<DogApiService>(context, listen: false))),
      ],
      child: MaterialApp(
        routes: {
          '/home': (context) => HomePage(),
          '/splash': (context) => SplashScreen(),
          '/settings': (context) => SettingsScreen(),
        },
        debugShowCheckedModeBanner: false,
        title: 'Dog Breeds App',
        theme: ThemeData(
          appBarTheme: const AppBarTheme(
              elevation: 0,
              backgroundColor: Colors.transparent,
              shadowColor: Colors.black,
              titleTextStyle:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.w900),
              centerTitle: true,
              iconTheme: IconThemeData(color: Colors.black)),
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: SplashScreen(),
      ),
    );
  }
}
