import 'package:flutter/material.dart';
import '../../../utility/local_storage.dart';
class LogoDisplay extends StatefulWidget {
  const LogoDisplay({Key? key}) : super(key: key);

  @override
  State<LogoDisplay> createState() => _LogoDisplayState();
}

class _LogoDisplayState extends State<LogoDisplay> {
  String? logoUrl;

  @override
  void initState() {
    super.initState();
    loadLogo();
  }

  void loadLogo() async {
    final url = await StorageHelper.getLogoUrl();
    setState(() {
      logoUrl = url;
    });
  }

  @override

  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: logoUrl != null
          ? Image.network(
        logoUrl!,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) {
          return const SizedBox(); // or use SizedBox()
        },
      )
          : const Icon(Icons.image, size: 40), // or SizedBox()
    );
  }

}
