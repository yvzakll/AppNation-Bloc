import 'package:bloc_appnation/bloc/bloc_management.dart';
import 'package:bloc_appnation/constants/constants.dart';
import 'package:bloc_appnation/feature/settings_screen.dart';
import 'package:bloc_appnation/model/dog_model.dart';
import 'package:bloc_appnation/service/dog_service.dart';
import 'package:bloc_appnation/widgets/dogBottomSheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  final String _appTitle = "Dog Breeds App";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_appTitle),
      ),
      body: Column(
        children: const [
          Expanded(
            child: _BlocBuilder(),
          ),
          _searchableTextWidget(),
        ],
      ),
      bottomNavigationBar: const _BottomNavigationBar(),
    );
  }
}

class _BottomNavigationBar extends StatelessWidget {
  const _BottomNavigationBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings),
          label: 'Settings',
        ),
      ],
      onTap: (index) {
        if (index == 1) {
          Navigator.pushNamed(context, '/settings');
        }
      },
    );
  }
}

class _searchableTextWidget extends StatelessWidget {
  const _searchableTextWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        onChanged: (searchTerm) {
          context.read<DogBreedBloc>().add(UpdateSearchTerm(searchTerm));
        },
        decoration: const InputDecoration(
          labelText: 'Search',
          border: OutlineInputBorder(),
          suffixIcon: Icon(Icons.search),
        ),
      ),
    );
  }
}

class _BlocBuilder extends StatelessWidget {
  const _BlocBuilder({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DogBreedBloc, DogBreedState>(
      builder: (context, state) {
        if (state is DogBreedLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is DogBreedLoaded) {
          if (state.breeds.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text(
                    'No results found',
                    style: MyConstants.noResultTextStyle,
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Try searching with another word',
                    style: MyConstants.tryTextStyle,
                  ),
                ],
              ),
            );
          }

          final breedsWithImages =
              state.breeds.where((breed) => breed.imageUrl.isNotEmpty).toList();

          return _GridViewBuilder(breedsWithImages: breedsWithImages);
        } else if (state is DogBreedError) {
          return const Center(child: Text('Failed to load dog breeds.'));
        } else {
          return const SizedBox();
        }
      },
    );
  }
}

class _GridViewBuilder extends StatelessWidget {
  const _GridViewBuilder({
    required this.breedsWithImages,
  });

  final List<DogBreed> breedsWithImages;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(8),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: breedsWithImages.length,
      itemBuilder: (context, index) {
        final breed = breedsWithImages[index];
        return GestureDetector(
          onTap: () async {
            await _gestureDetectorOnTap(context, breed);
          },
          child: breed.imageUrl.isNotEmpty
              ? _gestureDetectorCard(breed: breed)
              : const SizedBox.shrink(),
        );
      },
    );
  }

  Future<void> _gestureDetectorOnTap(
      BuildContext context, DogBreed breed) async {
    final subBreeds =
        await context.read<DogApiService>().fetchSubBreeds(breed.breed);
    final imageUrl = await context
        .read<DogApiService>()
        .fetchRandomImageForBreed(breed.breed);
    showModalBottomSheet(
      context: context,
      builder: (context) => DogBreedBottomSheet(
        breed: breed.breed,
        subBreeds: subBreeds,
      ),
    );
  }
}

class _gestureDetectorCard extends StatelessWidget {
  const _gestureDetectorCard({
    super.key,
    required this.breed,
  });

  final DogBreed breed;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Image.network(
            breed.imageUrl,
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) =>
                const SizedBox.shrink(),
          ),
          Container(
            color: Colors.black.withOpacity(0.5),
            padding: const EdgeInsets.all(8),
            child: Text(breed.breed, style: MyConstants.breedTextStyle),
          ),
        ],
      ),
    );
  }
}
