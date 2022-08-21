import 'package:flutter/material.dart';

import '../../data/models/factfile/fact_file_entry.dart';
import '../../env.dart';
import '../../util/screen.dart';
import 'fact_file_tile.dart';

class FactFileTab extends StatefulWidget {
  final List<FactFileEntry> entries;

  const FactFileTab(this.entries);

  @override
  _FactFileTabState createState() => _FactFileTabState();
}

class _FactFileTabState extends State<FactFileTab> {
  bool overlayVisible = false;
  FactFileEntry tappedEntry;

  /// This takes a [count] and builds each [Tile] for this tab page
  List<SmallTile> _buildGridCards(int count, BuildContext context) {
    return widget.entries.map((entry) {
      return SmallTile(
        title: entry.primaryName,
        heroTag: entry.id,
        imagePath: Env.getResourcePath(entry.mainImage.path),
        onTap: () => handleTap(entry.id),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        GridView.count(
          mainAxisSpacing: Screen.width(context, percentage: 2.5),
          crossAxisSpacing: Screen.width(context, percentage: 2.5),
          crossAxisCount: (Screen.isTablet(context) && Screen.isLandscape(context)) ? 3 : 2,
          padding: EdgeInsets.all(
            Screen.width(context, percentage: 2.5),
          ),
          children: _buildGridCards(widget.entries.length, context),
        ),
      ],
    );
  }

  handleTap(int entryId) {
    Navigator.of(context).pushNamed(
      '/factFileDetails',
      arguments: entryId,
    );
  }
}
