import 'package:big_tip/big_tip.dart';
import 'package:flutter/material.dart';

class ErrorPage extends StatelessWidget {
  const ErrorPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BigTip(
        title: const Text('An error occurred'),
        subtitle: const Text('This page is not available'),
        action: TextButton(
          child: const Text('Go back'),
          onPressed: () => Navigator.pop(context),
        ),
        child: const Icon(Icons.error_outline),
      ),
    );
  }
}
