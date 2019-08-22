import 'package:discover_deep_cove/data/models/activity/activity.dart';
import 'package:discover_deep_cove/util/hex_color.dart';
import 'package:discover_deep_cove/util/screen.dart';
import 'package:discover_deep_cove/widgets/misc/bottom_back_button.dart';
import 'package:discover_deep_cove/widgets/misc/text/body.dart';
import 'package:discover_deep_cove/widgets/misc/text/heading.dart';
import 'package:flutter/material.dart';

enum UnlockStatus { success, alreadyUnlocked, failure }

class ActivityUnlock extends StatelessWidget {
  final TextEditingController textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          buildContent(context),
        ],
      ),
      backgroundColor: Theme.of(context).backgroundColor,
      bottomNavigationBar: BottomBackButton(),
    );
  }

  void verifyCode(BuildContext context) async {
    // Navigator.pushNamed(context, '/activity',
    //     arguments: ActivityScreenArgs(activity: activity));
    // UnlockStatus status;

    // Activity activity = await ActivityBean.of(context).findByCode(textController.text);

    // if (activity != null) {
    //   if (activity.unlocked) {
    //     status = UnlockStatus.alreadyUnlocked;
    //   } else {
    //     activity.unlocked = true;
    //     await ActivityBean.of(context).update(activity);
    //     status = UnlockStatus.success;
    //   }

    //   widget.refreshCallback();
    //   Navigator.of(context).pop();
    // } else {
    //   status = UnlockStatus.failure;
    // }

    // switch (status) {
    //   case UnlockStatus.success:
    //     Util.showToast(context, 'Quiz unlocked');
    //     break;
    //   case UnlockStatus.alreadyUnlocked:
    //     Util.showToast(context, 'Quiz already unlocked');
    //     break;
    //   default:
    //     Util.showToast(context, 'Invalid code entered');
    // }
  }

  getBottomHalf(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: Screen.width(context) <= 350 ? 20 : 50),
              child: Body(
                "Example QR code.",
                size: Screen.width(context) <= 600 ? 0 : 30,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                  vertical: Screen.height(context, percentage: 2),
                  horizontal: Screen.width(context) <= 350 ? 20 : 50),
              child: Container(
                width: Screen.width(context,
                    percentage: Screen.width(context) <= 350
                        ? 50
                        : !Screen.isPortrait(context) ? 40 : 60),
                height: Screen.width(context,
                    percentage: Screen.width(context) <= 350
                        ? 50
                        : !Screen.isPortrait(context) ? 40 : 60),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  image: DecorationImage(
                    image: AssetImage('assets/invalidQRcode.png'),
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  getTopHalf(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: Screen.isTablet(context) ? 8.0 : 8.0,
            vertical: Screen.width(context,
                percentage: Screen.width(context) <= 350 ? 2 : 15),
          ),
          child: Container(
            width: Screen.width(context,
                percentage: Screen.width(context) < 600 ? 100 : 80),
            color: Theme.of(context).primaryColor,
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(
                    top: Screen.width(context, percentage: 5),
                    bottom: Screen.width(context, percentage: 5),
                  ),
                  child: Heading(
                    "Enter QR unlock code:",
                  ),
                ),
                Transform.scale(
                  scale: Screen.isTablet(context) ? 1.25 : 1,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
                    child: Container(
                      width: Screen.width(
                        context,
                        percentage: Screen.isTablet(context) ? 30 : 62.5,
                      ),
                      color: Colors.white,
                      child: TextField(
                        controller: textController,
                        style: TextStyle(color: Colors.black),
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
                      ),
                    ),
                    onPressed: () => verifyCode(context),
                    borderSide: BorderSide(
                      color: HexColor("FFFFFFFF"),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  buildContent(BuildContext context) {
    return (Screen.isTablet(context) && !Screen.isPortrait(context))
        ? GridView.count(
            crossAxisCount: 2,
            children: [
              getBottomHalf(context),
              getTopHalf(context),
            ],
          )
        : SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                getTopHalf(context),
                getBottomHalf(context),
              ],
            ),
          );
  }
}
