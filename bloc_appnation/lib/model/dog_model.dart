class DogBreed {
  final String breed;
  final List<String> subBreeds;
  final String imageUrl;

  DogBreed(
      {required this.breed, required this.imageUrl, this.subBreeds = const []});
}
