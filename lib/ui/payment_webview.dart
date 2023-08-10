import 'package:flutter/material.dart';
import 'package:nike_ecommerce/ui/receipt/receipt.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PaymentGatewayScreen extends StatelessWidget {
  final String bankGatewayUrl;

  const PaymentGatewayScreen({Key? key, required this.bankGatewayUrl})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WebView(
      initialUrl: bankGatewayUrl,
      javascriptMode: JavascriptMode.unrestricted,
      onPageStarted: (url) {
        final uri = Uri.parse(url);
        if (uri.host == 'expertdevelopers.ir' &&
            uri.pathSegments.contains('appCheckout')) {
          final orderId = int.parse(uri.queryParameters['order_id']!);

          Navigator.of(context).pop();
          Navigator.of(context).push(MaterialPageRoute(
              builder: ((context) => ReceiptScreen(orderId: orderId))));
        }
      },
    );
  }
}
