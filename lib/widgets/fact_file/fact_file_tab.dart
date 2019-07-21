import 'package:discover_deep_cove/data/models/factfile/fact_file_entry.dart';
import 'package:discover_deep_cove/env.dart';
import 'package:discover_deep_cove/widgets/misc/tile.dart';
import 'package:flutter/material.dart';
import 'package:discover_deep_cove/views/fact_file/fact_file_details.dart';
import 'package:discover_deep_cove/widgets/fact_file/card_overlay.dart';
import 'package:discover_deep_cove/widgets/misc/small_tile.dart';


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
    return widget.entries.map((entry){
      return SmallTile(
        title: entry.primaryName,
        imagePath: Env.getResourcePath(entry.mainImage.path),
        onTap: handleTap(entry),
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
            crossAxisCount: 2,
            padding: EdgeInsets.fromLTRB(4.0, 4.0, 4.0, 4.0),
            childAspectRatio: 8.0 / 8.0,
            children: _buildGridCards(widget.entries.length, context),
          ),
        ),
        overlayVisible
            ? CardOverlay(
                entry: tappedEntry,
                onTap: () {
                  this.setState(() {
                    overlayVisible = false;
                  });
                },
                onButtonTap: () {
                  //TODO: do we need hero?
                  Navigator.pushNamed(
                    context,
                    '/factFileDetails',
                    arguments: FactFilesDetails(
                      entry: tappedEntry,
                      heroTag: "Test",
                    ),
                  );
                },
              )
            : Container(),
      ],
    );
  }

  handleTap(FactFileEntry entry) {
    setState(() {
      overlayVisible = true;
      tappedEntry = entry;
    });
  }
}
