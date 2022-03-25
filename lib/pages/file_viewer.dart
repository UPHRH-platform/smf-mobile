import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smf_mobile/constants/app_constants.dart';
import 'package:smf_mobile/constants/color_constants.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'dart:async';

class FileViewer extends StatefulWidget {
  final String fileType;
  final String fileUrl;
  const FileViewer({Key? key, required this.fileType, required this.fileUrl})
      : super(key: key);
  @override
  _FileViewerState createState() => _FileViewerState();
}

class _FileViewerState extends State<FileViewer> {
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();
  late String _fileUrl;
  bool _isLoading = true;
  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) WebView.platform = AndroidWebView();
    if (widget.fileType == FieldType.image) {
      _fileUrl = widget.fileUrl;
    } else {
      _fileUrl =
          'https://docs.google.com/gview?embedded=true&url=' + widget.fileUrl;
    }
    // print(widget.fileUrl);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          titleSpacing: 10,
          elevation: 0,
          backgroundColor: Colors.white,
          leading: const BackButton(color: AppColors.black60),
          title: Text(
            AppLocalizations.of(context)!.fileViewer,
            style: GoogleFonts.lato(
              color: AppColors.black87,
              fontSize: 16.0,
              letterSpacing: 0.12,
              fontWeight: FontWeight.w600,
            ),
          ),
          // centerTitle: true,
        ),
        // Tab controller
        body: Container(
            color: AppColors.scaffoldBackground,
            height: MediaQuery.of(context).size.height,
            child: Stack(children: <Widget>[
              Builder(builder: (BuildContext context) {
                return WebView(
                  debuggingEnabled: true,
                  initialUrl: _fileUrl,
                  javascriptMode: JavascriptMode.unrestricted,
                  onWebViewCreated: (WebViewController webViewController) {
                    _controller.complete(webViewController);
                  },
                  onPageFinished: (finish) {
                    setState(() {
                      _isLoading = false;
                    });
                  },
                  gestureNavigationEnabled: true,
                );
              }),
              _isLoading
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : Stack(),
            ])));
  }
}
