import 'package:discover_deep_cove/data/models/notice.dart';
import 'package:discover_deep_cove/util/noticeboard_sync.dart';
import 'package:discover_deep_cove/util/screen.dart';
import 'package:discover_deep_cove/widgets/misc/bottom_back_button.dart';
import 'package:discover_deep_cove/widgets/misc/text/body_text.dart';
import 'package:discover_deep_cove/widgets/misc/text/sub_heading.dart';
import 'package:discover_deep_cove/widgets/noticeboard/noticeboard_separator.dart';
import 'package:discover_deep_cove/widgets/noticeboard/noticeboard_tile.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Noticeboard extends StatefulWidget {
  @override
  _NoticeboardState createState() => _NoticeboardState();
}

class _NoticeboardState extends State<Noticeboard> {
  List<Notice> notices;

  @override
  void initState() {
    loadNotices();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Container(),
        title: SubHeading(
          'Deep Cove Noticeboard',
          size:
              Screen.isTablet(context) ? 30 : Screen.isSmall(context) ? 20 : 23,
        ),
        centerTitle: true,
        actions: <Widget>[
          Padding(
            padding: EdgeInsets.only(
              right: Screen.width(context, percentage: 1.25),
            ),
            child: IconButton(
              icon: Icon(FontAwesomeIcons.sync,
                  color: Colors.white,
                  size: Screen.isTablet(context) ? 25 : 18),
              onPressed: () {
                refreshNotices();
                setState(() {
                  notices = null;
                });
              },
            ),
          ),
        ],
        backgroundColor: Theme.of(context).backgroundColor,
        brightness: Brightness.dark,
      ),
      body: notices == null
          ? Center(
              child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                CircularProgressIndicator(),
                SizedBox(height: 15),
                BodyText('Loading notices...')
              ],
            ))
          : buildContent(),
      backgroundColor: Theme.of(context).backgroundColor,
      bottomNavigationBar: BottomBackButton(),
    );
  }

  buildContent() {
    return RefreshIndicator(
      onRefresh: refreshNotices,
      child: ListView(
        children: <Widget>[
          Separator("Important Notices"),
          ...getUrgent(),
          Separator("General Notices"),
          ...getOther(),
        ],
      ),
    );
  }

  Future<Null> refreshNotices() async {
    await NoticeboardSync.retrieveNotices(context);
    loadNotices();
    setState(() {});
  }

  bool hasDivider(Notice notice, Iterable<Notice> notices) {
    return notice != notices.last && notices.length != 1;
  }

  Iterable<Widget> getUrgent() =>
      buildTiles(notices.where((n) => n.urgent), urgent: true);

  Iterable<Widget> getOther() =>
      buildTiles(notices.where((n) => !n.urgent), urgent: false);

  List<Widget> buildTiles(Iterable<Notice> notices, {bool urgent}) {
    Iterable<NoticeTile> noticeTiles = notices.map(
      (data) => NoticeTile(
        title: data.title,
        date: data.updatedAt,
        desc: data.shortDesc,
        isUrgent: urgent,
        hasMore: data.longDesc != null,
        hasDivider: hasDivider(data, notices.where((n) => n.urgent == urgent)),
        onTap: data.longDesc != null
            ? () => Navigator.pushNamed(
                  context,
                  '/noticeView',
                  arguments: data,
                )
            : null,
      ),
    );

    return noticeTiles.length > 0
        ? noticeTiles.toList()
        : [
            Padding(
              padding: EdgeInsets.symmetric(vertical: Screen.height(context, percentage: 5)),
              child: Center(
                child: BodyText('No ${urgent ? 'important' : 'general'} notices'),
              ),
            ),
          ];
  }

  Future<void> loadNotices() async {
    notices = await NoticeBean.of(context).getAll();
    await NoticeBean.of(context).preloadExtrasForRange(notices);
    setState(() {});
  }
}
