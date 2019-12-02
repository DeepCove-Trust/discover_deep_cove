import 'package:discover_deep_cove/env.dart';
import 'package:discover_deep_cove/util/data_sync/sync_manager.dart';
import 'package:discover_deep_cove/util/screen.dart';
import 'package:discover_deep_cove/util/util.dart';
import 'package:discover_deep_cove/widgets/misc/progress_bar.dart';
import 'package:discover_deep_cove/widgets/misc/text/body_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LoadingScreen extends StatefulWidget {
  final bool isFirstLoad;
  final VoidCallback onComplete;

  LoadingScreen({this.isFirstLoad = false, this.onComplete});

  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  SyncState syncState;
  int filesToDownload;
  int filesDownloaded;
  int downloadSize;
  double percentComplete = 0;

  @override
  void initState() {
    super.initState();
    syncState = SyncState.None;
    manualUpdate();
  }

  Future<void> manualUpdate() async {
    if (Env.debugMessages) print('Checking for new content');
    await SyncManager(onProgressChange: _onProgressUpdate, context: context)
        .sync();
    await Future.delayed(Duration(seconds: 2));

    widget.isFirstLoad
        ? Navigator.of(context).pushReplacementNamed('/')
        : Navigator.of(context).pop();
  }

  String _getMessage() {
    switch (syncState) {
      case SyncState.None:
        return '';
      case SyncState.DataDownload:
        return 'Checking for new data...';
      case SyncState.Error_ServerUnreachable:
        return 'Server could not be reached';
      case SyncState.ServerDiscovered:
        return '';
      case SyncState.MediaDiscovery:
        return 'Checking for new files...';
      case SyncState.MediaDownload:
        return 'Downloading new files...';
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
        return widget.isFirstLoad
            ? 'Downloading initial content'
            : 'Preparing to update...';
      default:
        return '';
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
      case SyncState.MediaDiscovery:
      case SyncState.MediaDownload:
      case SyncState.ServerDiscovered:
      case SyncState.DataDownload:
      case SyncState.None:
        return null;
      default:
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

    if (syncState == SyncState.Error_ServerUnreachable ||
        syncState == SyncState.Error_Other ||
        syncState == SyncState.Error_Storage ||
        syncState == SyncState.Error_Permission && widget.isFirstLoad) {
      _onUpdateFail();
    }
  }

  void _onUpdateFail() async {
    await Future.delayed(Duration(seconds: 2));

    if (widget.isFirstLoad) {
      SystemNavigator.pop(); // quit app if app doesn't yet have content
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => Future<bool>.value(false),
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 90,
                    child: _getIcon(),
                  ),
                  BodyText(
                    _getMessage(),
                    size: Screen.isTablet(context) ? 30 : null,
                  ),
                  SizedBox(height: 30),
                  ProgressBar(percent: percentComplete / 100),
                  SizedBox(height: 30),
                  BodyText(
                    filesToDownload != null
                        ? '$filesDownloaded out of $filesToDownload downloaded \n '
                            '(${Util.bytesToMBString(downloadSize)} total)'
                        : ' \n ',
                    size: Screen.isTablet(context) ? 30 : null,
                  )
                ],
              )
            ],
          ),
        ),
        backgroundColor: Theme.of(context).primaryColorDark,
      ),
    );
  }
}
