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

}