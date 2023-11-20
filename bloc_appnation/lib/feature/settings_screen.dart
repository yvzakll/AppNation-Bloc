import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  final String _settingsTitle = "Settings";

  const SettingsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_settingsTitle),
        centerTitle: true,
      ),
      body: const _settingsList(),
    );
  }
}

class _settingsList extends StatelessWidget {
  const _settingsList({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: ListTile.divideTiles(
        // Bu, her bir ListTile arasında bir çizgi çizer.
        context: context,
        tiles: [
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text('Help'),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              // Help sayfasına yönlendirme yapılacak.
            },
          ),
          ListTile(
            leading: const Icon(Icons.star_border),
            title: const Text('Rate Us'),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              // Uygulama mağazası sayfasına yönlendirme yapılacak.
            },
          ),
          ListTile(
            leading: const Icon(Icons.share),
            title: const Text('Share with Friends'),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              // Paylaşım işlemi yapılacak.
            },
          ),
          ListTile(
            leading: const Icon(Icons.description),
            title: const Text('Terms of Use'),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              // Kullanım koşulları sayfasına yönlendirme yapılacak.
            },
          ),
          ListTile(
            leading: const Icon(Icons.lock_outline),
            title: const Text('Privacy Policy'),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              // Gizlilik politikası sayfasına yönlendirme yapılacak.
            },
          ),
          const ListTile(
            leading: Icon(Icons.settings),
            title: Text('OS Version'),
            subtitle: Text(
                '17.0.3'), // Burası dinamik olabilir, cihazın OS versiyonunu gösterir.
          ),
        ],
      ).toList(),
    );
  }
}
