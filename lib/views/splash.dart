import 'package:discover_deep_cove/data/database_adapter.dart';
import 'package:discover_deep_cove/data/models/config.dart';
import 'package:discover_deep_cove/util/data_sync/sync_manager.dart';
import 'package:discover_deep_cove/util/screen.dart';
import 'package:discover_deep_cove/util/util.dart';
import 'package:discover_deep_cove/widgets/misc/progress_bar.dart';
import 'package:discover_deep_cove/widgets/misc/text/body_text.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

// Todo: This screen should replicate the splash screen.
class _SplashState extends State<Splash> {
  SyncState syncState;
  int filesToDownload;
  int filesDownloaded;
  int downloadSize;
  double percentComplete = 0;

  @override
  void initState() {
    super.initState();
    syncState = SyncState.None;
    checkContent();
  }

  // Check whether the database exists
  Future<void> checkContent() async {
    // Check whether the config table exists, a database exception thrown here
    // indicates that this is first time load
    try {
      var config = await ConfigBean(DatabaseAdapter.of(context)).getAll();
    } on DatabaseException catch (ex) {
      print('Application database has not been created, initializing sync.');
      await SyncManager(onProgressChange: _onProgressUpdate).sync();

      // Short delay so user can see the final success/error message
      await Future.delayed(Duration(seconds: 2));
    } finally {
      // Direct the user to the home screen
      Navigator.of(context).pop();
    }
  }

  String _getMessage() {
    switch (syncState) {
      case SyncState.None:
        return '';
      case SyncState.DataDownload:
        return 'Downloading data...';
      case SyncState.Error_ServerUnreachable:
        return 'Server could not be reached';
      case SyncState.ServerDiscovered:
        return '';
      case SyncState.MediaDownload:
        return 'Downloading files...';
      case SyncState.Cleanup:
        return 'Cleaning up...';
      case SyncState.Done:
        return 'Application up to date!';
      case SyncState.Error_Other:
        return 'An error occurred. Please try again later.';
      case SyncState.Error_Permission:
        return 'You need to grant storage permission to the app.';
      case SyncState.Error_Storage:
        return 'You device has insufficient storage space. '
            'Please free some space and try again.';
      case SyncState.Initialization:
        return 'Preparing to update...';
    }
  }

  Icon _getIcon() {
    switch (syncState) {
      case SyncState.Error_Permission:
      case SyncState.Error_Storage:
      case SyncState.Error_Other:
      case SyncState.Error_ServerUnreachable:
        return Icon(Icons.error_outline, color: Colors.red, size: 50);
      case SyncState.Done:
        return Icon(Icons.check_circle_outline,
            color: Colors.lightGreen, size: 50);
      case SyncState.Cleanup:
      case SyncState.Initialization:
      case SyncState.MediaDownload:
      case SyncState.ServerDiscovered:
      case SyncState.DataDownload:
      case SyncState.None:
        return null;
    }
  }

  void _onProgressUpdate(
      SyncState syncState, int percent, int upTo, int outOf, int totalSize) {
    setState(() {
      this.syncState = syncState;
      percentComplete = percent.toDouble();
      filesDownloaded = upTo;
      filesToDownload = outOf;
      downloadSize = totalSize;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Image.asset('assets/splash_logo.png'),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: Screen.height(context, percentage: 10)),
                ProgressBar(percent: percentComplete / 100),
                SizedBox(height: Screen.height(context, percentage: 6)),
                BodyText(
                  _getMessage(),
                  size: Screen.isTablet(context) ? 30 : null,
                ),
                SizedBox(height: Screen.height(context, percentage: 4)),
                _getIcon() ?? Container(),
                filesToDownload != null
                    ? BodyText(
                        '$filesDownloaded out of $filesToDownload '
                        'downloaded \n (${Util.bytesToMBString(downloadSize)} total)',
                        size: Screen.isTablet(context) ? 30 : null)
                    : Container(),
              ],
            )
          ],
        ),
      ),
      backgroundColor: Theme.of(context).primaryColorDark,
    );
  }
}
