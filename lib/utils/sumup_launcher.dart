import 'package:url_launcher/url_launcher.dart';

class SumUpLauncher {
  static Future<void> launchSumUpPayment(double amount) async {
    final url = Uri.parse("https://pay.sumup.com/b2c/QLA0FER7");
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch SumUp payment URL';
    }
  }
}
