import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

class AboutAppView extends StatelessWidget {
  const AboutAppView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.black,
        title: const Text('О приложении'),
        leading: IconButton(
          icon: Icon(Icons.adaptive.arrow_back),
          onPressed: Navigator.of(context).pop,
        ),
      ),
      body: FutureBuilder<PackageInfo>(
        future: PackageInfo.fromPlatform(),
        builder: (ctx, snapshot) {
          if (!snapshot.hasData) {
            return const CircularProgressIndicator.adaptive();
          } else {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const FlutterLogo(
                    size: 200,
                  ),
                  Text(
                    'Версия ${snapshot.data!.version}, сборка ${snapshot.data!.buildNumber}',
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
