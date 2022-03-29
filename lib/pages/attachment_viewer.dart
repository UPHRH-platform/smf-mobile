import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smf_mobile/constants/color_constants.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'dart:async';

class AttachmentViewer extends StatefulWidget {
  final String fileUrl;
  const AttachmentViewer({Key? key, required this.fileUrl}) : super(key: key);
  @override
  _AttachmentViewerState createState() => _AttachmentViewerState();
}

class _AttachmentViewerState extends State<AttachmentViewer> {
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();
  late String _fileUrl;
  bool _isLoading = true;
  @override
  void initState() {
    super.initState();
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
            child: Image.file(File(widget.fileUrl))));
  }
}
