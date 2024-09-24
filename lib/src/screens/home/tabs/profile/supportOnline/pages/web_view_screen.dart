import 'package:flutter/cupertino.dart';
import 'package:impo/src/components/loading_view_screen.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewScreen extends StatelessWidget{
  final String? url;

  WebViewScreen({Key? key,this.url}):super(key:key);

  @override
  Widget build(BuildContext context) {
    WebViewController controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor( Color(0xffffffff))
      ..setNavigationDelegate(
        NavigationDelegate(
          // onProgress: (int progress) {
          //   return Center(child: LoadingViewScreen());
          // },
          // onPageStarted: (String url) {
          //   return Center(child: LoadingViewScreen());
          // },
          onPageFinished: (String url) {},
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.startsWith(url!)) {
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse('https://flutter.dev'));
    return WebViewWidget(controller: controller);
  }

}