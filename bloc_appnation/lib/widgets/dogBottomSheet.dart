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
      backgroundColor: Colors.transparent, // Arka planı şeffaf yap
      builder: (BuildContext context) {
        return Center(
          // Ekranın ortasına yerleştir
          child: Column(
            mainAxisSize: MainAxisSize.min, // İçeriği mümkün olduğunca daralt
            children: [
              ClipRRect(
                borderRadius:
                    BorderRadius.circular(8), // Resmin köşelerini yuvarla
                child: Image.network(
                  imageUrl,
                  width: MediaQuery.of(context).size.width *
                      0.7, // Resmi biraz küçült
                  fit: BoxFit.cover,
                ),
              ),
              TextButton(
                child: const Icon(
                  Icons.close,
                  size: 24,
                  color: Colors.white,
                ), // Çarpı ikonunu göster
                onPressed: () =>
                    Navigator.pop(context), // Butona basıldığında kapat
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
    _generateRandomImage(); // İlk resmi yüklemek için
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
            ), // Resim URL'si null değilse göster
          Text(widget.breed, style: MyConstants.bottomSheetTextStyle),
          ...widget.subBreeds.map((subBreed) => Text(subBreed)).toList(),

          ElevatedButton(
            child: const Text('Generate'),
            onPressed: () async {
              // Mevcut bottom sheet'i kapat
              Navigator.pop(context);
              // API'den yeni bir resim getir
              final imageUrl = await context
                  .read<DogApiService>()
                  .fetchRandomImageForBreed(widget.breed);
              // Yeni bottom sheet'i göster
              _showImageOnlyBottomSheet(context, imageUrl);
            },
          ),

          /*  ElevatedButton(
            child: Text('Generate'),
            onPressed:
                _generateRandomImage, // Generate butonuna basıldığında yeni resim getir
          ), */
        ],
      ),
    );
  }
}
