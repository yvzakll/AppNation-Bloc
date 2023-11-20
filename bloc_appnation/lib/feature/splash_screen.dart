import 'package:bloc_appnation/bloc/bloc_management.dart';
import 'package:bloc_appnation/feature/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    context.read<DogBreedBloc>().add(LoadDogBreeds());

    return BlocListener<DogBreedBloc, DogBreedState>(
      listener: (context, state) {
        if (state is DogBreedLoaded) {
          Navigator.pushNamed(context, '/home');
        }
      },
      child: const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}
