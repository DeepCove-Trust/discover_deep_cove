import 'package:flutter/material.dart';
import 'package:discover_deep_cove/data/sample_data_fact_file.dart';
import 'package:discover_deep_cove/views/fact_file/fact_file_details.dart';
import 'package:discover_deep_cove/widgets/fact_file/card_overlay.dart';
import 'package:uuid/uuid.dart';

import 'package:discover_deep_cove/widgets/misc/tile.dart';

class TabPage extends StatefulWidget {
  final List<FactFileEntry> entries;

  TabPage(this.entries);

  @override
  _TabPageState createState() => _TabPageState();
}

class _TabPageState extends State<TabPage> {
  final Uuid uuid = Uuid();
  bool overlayVisible = false;
  FactFileEntry tappedEntry;

  /// This takes a [count] and builds each [Tile] for this tab page
  List<Tile> _buildGridCards(int count, BuildContext context) {
    List<Tile> cards = List.generate(count, (int index) {
      String heroTag = uuid.v4();
      return Tile(
        onTap: () => handleTap(widget.entries[index]),
        entry: widget.entries[index],
        hero: heroTag,
        height: (MediaQuery.of(context).size.height / 100) * 5,
      );
    });
    return cards;
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
