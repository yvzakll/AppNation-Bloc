import 'package:bloc_appnation/constants/constants.dart';
import 'package:bloc_appnation/service/dog_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DogBreedBottomSheet extends StatefulWidget {
  final String breed;
  final List<String> subBreeds;

  const DogBreedBottomSheet({
    Key? key,
    required this.breed,
    required this.subBreeds,
  }) : super(key: key);

  @override
  _DogBreedBottomSheetState createState() => _DogBreedBottomSheetState();
}

class _DogBreedBottomSheetState extends State<DogBreedBottomSheet> {
  Future<void> _showImageOnlyBottomSheet(
      BuildContext context, String imageUrl) async {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  imageUrl,
                  width: MediaQuery.of(context).size.width * 0.7,
                  fit: BoxFit.cover,
                ),
              ),
              TextButton(
                child: const Icon(
                  Icons.close,
                  size: 24,
                  color: Colors.white,
                ),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
        );
      },
    );
  }

  String? _imageUrl;

  Future<void> _generateRandomImage() async {
    final imageUrl = await context
        .read<DogApiService>()
        .fetchRandomImageForBreed(widget.breed);
    setState(() {
      _imageUrl = imageUrl;
    });
  }

  @override
  void initState() {
    super.initState();
    _generateRandomImage();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: MyConstants.BottomSheetPadding,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (_imageUrl != null)
            Expanded(
              child: Image.network(_imageUrl!, fit: BoxFit.cover),
            ),
          Text(widget.breed, style: MyConstants.bottomSheetTextStyle),
          ...widget.subBreeds.map((subBreed) => Text(subBreed)).toList(),
          ElevatedButton(
            child: const Text('Generate'),
            onPressed: () async {
              Navigator.pop(context);

              final imageUrl = await context
                  .read<DogApiService>()
                  .fetchRandomImageForBreed(widget.breed);

              _showImageOnlyBottomSheet(context, imageUrl);
            },
          ),
        ],
      ),
    );
  }
}
