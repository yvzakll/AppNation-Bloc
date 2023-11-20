import 'package:bloc_appnation/model/dog_model.dart';
import 'package:bloc_appnation/service/dog_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Events
abstract class DogBreedEvent {}

class LoadDogBreeds extends DogBreedEvent {}

class UpdateSearchTerm extends DogBreedEvent {
  final String searchTerm;

  UpdateSearchTerm(this.searchTerm);
}

// States
abstract class DogBreedState {}

class DogBreedInitial extends DogBreedState {}

class DogBreedLoading extends DogBreedState {}

class DogBreedLoaded extends DogBreedState {
  final List<DogBreed> breeds;

  DogBreedLoaded(this.breeds);
}

class DogBreedError extends DogBreedState {}

// Bloc
class DogBreedBloc extends Bloc<DogBreedEvent, DogBreedState> {
  final DogApiService apiService;
  List<DogBreed> _allBreeds = [];

  DogBreedBloc({required this.apiService}) : super(DogBreedInitial()) {
    on<LoadDogBreeds>(_onLoadDogBreeds);
    on<UpdateSearchTerm>(_onUpdateSearchTerm);
  }

  Future<void> _onLoadDogBreeds(
      LoadDogBreeds event, Emitter<DogBreedState> emit) async {
    emit(DogBreedLoading());
    try {
      final breedsData = await apiService.fetchAllBreeds();
      _allBreeds = await Future.wait(breedsData.keys.map((breed) async {
        final imageUrl = await apiService.fetchRandomImageForBreed(breed);
        return DogBreed(breed: breed, imageUrl: imageUrl);
      }));
      emit(DogBreedLoaded(_allBreeds));
    } catch (_) {
      emit(DogBreedError());
    }
  }

  void _onUpdateSearchTerm(
      UpdateSearchTerm event, Emitter<DogBreedState> emit) {
    if (state is DogBreedLoaded) {
      final filteredBreeds = _allBreeds
          .where((breed) => breed.breed
              .toLowerCase()
              .contains(event.searchTerm.toLowerCase()))
          .toList();
      emit(DogBreedLoaded(filteredBreeds));
    }
  }
}
