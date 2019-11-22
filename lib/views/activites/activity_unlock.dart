import 'package:discover_deep_cove/util/screen.dart';
import 'package:discover_deep_cove/widgets/misc/bottom_back_button.dart';
import 'package:discover_deep_cove/widgets/misc/text/body_text.dart';
import 'package:discover_deep_cove/widgets/misc/text/heading.dart';
import 'package:discover_deep_cove/widgets/misc/text/sub_heading.dart';
import 'package:flutter/material.dart';

class ActivityUnlock extends StatefulWidget {
  final void Function(String code) onCodeEntry;

  ActivityUnlock({@required this.onCodeEntry});

  @override
  _ActivityUnlockState createState() => _ActivityUnlockState();
}

class _ActivityUnlockState extends State<ActivityUnlock> {
  final TextEditingController textController = TextEditingController();
  FocusNode _textFieldFocus = new FocusNode();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _textFieldFocus.unfocus(),
      child: Scaffold(
        body: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            buildContent(context),
          ],
        ),
        backgroundColor: Theme.of(context).backgroundColor,
        bottomNavigationBar: BottomBackButton(),
      ),
    );
  }

  void verifyCode(BuildContext context) async {
    await Future.delayed(Duration(seconds: 1));
    Navigator.of(context).pop();
    widget.onCodeEntry(textController.text);
  }

  buildContent(BuildContext context) {
    return (Screen.isTablet(context) && !Screen.isPortrait(context))
        ? SingleChildScrollView(
            child: Row(
            children: <Widget>[
              Expanded(child: Column(children: buildQRExample(),)),
              Expanded(child: buildInputs())
            ],
          ))
        : SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                buildInputs(),
                SizedBox(height: 30),
                ...buildQRExample(),
              ],
            ),
          );
  }

  buildInputs() {
    return Container(
      width: 1500, // will not overflow
      height: Screen.isLandscape(context)
          ? Screen.height(context) - 50
          : Screen.height(context) * 0.4,
      color: Theme.of(context).primaryColor,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(
              top: Screen.width(context, percentage: 5),
              bottom: Screen.width(context, percentage: 5),
            ),
            child: Heading(
              "Enter QR unlock code:",
              size: Screen.width(context) >= 600
                  ? 30
                  : Screen.width(context) <= 350 ? 16 : 20,
            ),
          ),
          Transform.scale(
            scale: Screen.isTablet(context) ? 1.25 : 1,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10.0),
              child: Container(
                width: Screen.width(
                  context,
                  percentage: Screen.isLandscape(context) ? 30 : 60,
                ),
                color: Colors.white,
                child: TextField(
                  focusNode: _textFieldFocus,
                  controller: textController,
                  keyboardType: TextInputType.phone,
                  style: TextStyle(color: Colors.black, fontSize: 20),
                  decoration: InputDecoration(
                    hintText: 'Enter code...',
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.all(8.0),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              vertical: Screen.width(context, percentage: 5),
            ),
            child: OutlineButton(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Heading(
                  "Unlock",
                  size: Screen.width(context) >= 600
                      ? 30
                      : Screen.width(context) <= 350 ? 16 : 20,
                ),
              ),
              onPressed: () => verifyCode(context),
              borderSide: BorderSide(
                color: Color(0xFFFFFFFF),
              ),
            ),
          ),
        ],
      ),
    );
  }

  buildQRExample() {
    return <Widget>[
      Container(
        height: Screen.isLandscape(context)
            ? Screen.height(context, percentage: 60)
            : Screen.width(context, percentage: 60),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          image: DecorationImage(
            image: AssetImage('assets/invalidQRcode.png'),
            fit: BoxFit.contain,
          ),
        ),
      ),
      SizedBox(height: 25),
      SubHeading('Example QR Code')
    ];
  }
}
