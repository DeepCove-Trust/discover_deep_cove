import 'package:discover_deep_cove/data/models/factfile/fact_file_entry.dart';
import 'package:discover_deep_cove/env.dart';
import 'package:discover_deep_cove/util/screen.dart';
import 'package:discover_deep_cove/widgets/fact_file/fact_file_tile.dart';
import 'package:flutter/material.dart';

class FactFileTab extends StatefulWidget {
  final List<FactFileEntry> entries;

  FactFileTab(this.entries);

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
        onTap: () => handleTap(entry),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        Container(
          child: GridView.count(
            mainAxisSpacing: Screen.width(context, percentage: 2.5),
            crossAxisSpacing: Screen.width(context, percentage: 2.5),
            crossAxisCount:
                (Screen.width(context) >= 600 && !Screen.isPortrait(context))
                    ? 3
                    : 2,
            padding: EdgeInsets.all(
              Screen.width(context, percentage: 2.5),
            ),
            children: _buildGridCards(widget.entries.length, context),
          ),
        ),
      ],
    );
  }

  handleTap(FactFileEntry entry) {
    Navigator.of(context).pushNamed('/factFileOverlay', arguments: entry);
  }
}
