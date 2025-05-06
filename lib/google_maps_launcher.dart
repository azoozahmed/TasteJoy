import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class GoogleMapsLauncher extends StatelessWidget {
  const GoogleMapsLauncher({super.key});


  void launchGoogleMaps(double latitude, double longitude) async {
    String googleMapsUrl =
        'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';

    Uri uri = Uri.parse(googleMapsUrl);

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not launch $uri';
    }
  }

  @override
  Widget build(BuildContext context) {
    return const SizedBox();
  }
}
