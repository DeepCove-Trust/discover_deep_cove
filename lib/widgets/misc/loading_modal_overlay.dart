import 'package:discover_deep_cove/widgets/misc/text/body.dart';
import 'package:flutter/material.dart';

class LoadingModalOverlay extends StatelessWidget {
  final String loadingMessage;
  final Icon icon;

  LoadingModalOverlay({@required this.loadingMessage, this.icon});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Opacity(
          opacity: 0.9,
          child: const ModalBarrier(
            dismissible: false,
            color: Colors.black,
          ),
        ),
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              icon ?? CircularProgressIndicator(),
              SizedBox(height: 50),
              Body(
                loadingMessage,
                align: TextAlign.center,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
