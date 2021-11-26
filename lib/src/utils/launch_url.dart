import 'package:url_launcher/url_launcher.dart';

class LaunchUrl {

  static Future phoneCall(int phoneNumber) async {
    String phoneUrl = 'tel://+502$phoneNumber';

    await canLaunch(phoneUrl) ? await launch(phoneUrl) : null;
  }

  static Future sendEmail(String email) async {
    Uri emailUrl = Uri(scheme: 'mailto', path: email);
    await canLaunch(emailUrl.toString()) ? await launch(emailUrl.toString()) : null;
  }

  static Future<void> openWaze(double latitude, double longitude) async {
    String url = 'waze://?ll=$latitude,$longitude';
    String fallbackUrl = 'https://waze.com/ul?ll=$latitude,$longitude&navigate=yes';

    try {
      bool launched = await launch(url, forceSafariVC: false, forceWebView: false);
      if (!launched) await launch(fallbackUrl, forceSafariVC: false, forceWebView: false);
      
    } catch (e) {
      print('Error: $e');
      await launch(fallbackUrl, forceSafariVC: false, forceWebView: false);
    }
  }

  static Future<void> openGoogleMaps(double latitude, double longitude) async {
    String url = 'google.navigation:q=$latitude,$longitude';
    String fallbackUrl = 'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';

    try {
      bool launched = await launch(url, forceSafariVC: false, forceWebView: false);
      if (!launched) await launch(fallbackUrl, forceSafariVC: false, forceWebView: false);

    } catch (e) {
      print('Error: $e');
      await launch(fallbackUrl, forceSafariVC: false, forceWebView: false);
    }
  }

}