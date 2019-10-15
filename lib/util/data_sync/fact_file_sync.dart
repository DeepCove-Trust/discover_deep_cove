import 'dart:convert';

import 'package:discover_deep_cove/data/db.dart';
import 'package:discover_deep_cove/data/models/factfile/fact_file_category.dart';
import 'package:discover_deep_cove/data/models/factfile/fact_file_entry.dart';
import 'package:discover_deep_cove/data/models/factfile/fact_file_entry_image.dart';
import 'package:discover_deep_cove/data/models/factfile/fact_file_nugget.dart';
import 'package:discover_deep_cove/env.dart';
import 'package:discover_deep_cove/util/network_util.dart';

class FactFileData {
  int id;
  DateTime updatedAt;

  FactFileData.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    updatedAt = DateTime.parse(map['updated_at']);
  }
}

class FactFileSync {
  final CmsServerLocation server;
  final FactFileEntryBean factFileEntryBean;
  final FactFileCategoryBean factFileCategoryBean;
  final FactFileEntryImageBean factFileEntryImageBean;
  final FactFileNuggetBean factFileNuggetBean;

  FactFileSync(SqfliteAdapter adapter, {this.server})
      : factFileEntryBean = FactFileEntryBean(adapter),
        factFileNuggetBean = FactFileNuggetBean(adapter),
        factFileCategoryBean = FactFileCategoryBean(adapter),
        factFileEntryImageBean = FactFileEntryImageBean(adapter);

  Future<void> sync() async {
    // Sync fact file categories
    await _syncCategories();

    // Sync fact file entries, nuggets and entry images
    await _syncFactFiles();
  }

  Future<List<FactFileCategory>> _getCategoriesSummary() async {
    String jsonString =
        await NetworkUtil.requestDataString(Env.factFileCategoriesListUrl(server));
    List<dynamic> data = json.decode(jsonString);
    return data.map((m) => factFileCategoryBean.fromMap(m)).toList();
  }

  Future<void> _downloadFactFile(int id) async {
    // Request json string from server
    String jsonString =
        await NetworkUtil.requestDataString(Env.factFileDetailsUrl(server, id));
    Map<String, dynamic> decodedJson = json.decode(jsonString);

    // Deserialize all data
    FactFileEntry entry = factFileEntryBean.fromMap(decodedJson);
    List<dynamic> imageData = decodedJson['images'];
    List<dynamic> nuggetData = decodedJson['nuggets'];
    List<FactFileNugget> nuggets =
        nuggetData.map((map) => factFileNuggetBean.fromMap(map)).toList();

    // Insert fact file entry into database
    await factFileEntryBean.insert(entry);

    // Insert all entry image records
    List<int> imageIds = imageData.cast<int>().toList();
    await _createEntryImagesFor(id, imageIds);

    // Insert all nuggets
    if (nuggets.length > 0) {
      await factFileNuggetBean.insertMany(nuggets);
    }

    print('Downloaded fact file $id (${entry.primaryName})');
  }

  Future<void> _deleteFactFile(int id) async {
    // First, delete all related records in other tables
    await _deleteEntryImagesFor(id);
    await _deleteNuggetsFor(id);

    // Todo: Potential issue if activities are linked to this fact file...

    // Delete the fact file itself
    factFileEntryBean.remove(id);

    print('Deleted fact file $id');
  }

  Future<void> _updateFactFile(int id) async {
    await _deleteFactFile(id);
    await _downloadFactFile(id);
  }

  Future<void> _deleteCategory(int categoryId) async {
    await _deleteFactFilesFor(categoryId);
    await factFileCategoryBean.remove(categoryId);
    print('Deleted category $categoryId');
  }

  Future<void> _deleteFactFilesFor(int categoryId) async {
    List<FactFileEntry> entries =
        await factFileEntryBean.findByFactFileCategory(categoryId);

    for (FactFileEntry entry in entries) {
      _deleteFactFile(entry.id);
    }
  }

  Future<void> _deleteNuggetsFor(int factFileId) async {
    await factFileNuggetBean.removeByFactFileEntry(factFileId);
  }

  Future<void> _deleteEntryImagesFor(int factFileId) async {
    await factFileEntryImageBean.removeByFactFileEntry(factFileId);
  }

  Future<void> _createEntryImagesFor(int factFileId, List<int> mediaIds) async {
    if (mediaIds.length == 0) return;

    // Create list of entry image objects
    List<FactFileEntryImage> entryImages =
        mediaIds.map((m) => FactFileEntryImage.make(factFileId, m)).toList();

    // Insert to database
    await factFileEntryImageBean.insertMany(entryImages);
  }

  Future<void> _syncCategories() async {
    // Get all local categories
    List<FactFileCategory> localCats = await factFileCategoryBean.getAll();

    // Get summary of all fact files from server
    List<FactFileCategory> serverCats = await _getCategoriesSummary();

    Set<int> idSet = localCats
        .map((c) => c.id)
        .toSet()
        .union(serverCats.map((c) => c.id).toSet());

    for (int id in idSet) {
      // If local doesn't have a copy, insert
      if (!localCats.any((c) => c.id == id)) {
        await factFileCategoryBean
            .insert(serverCats.firstWhere((c) => c.id == id));
      }
      // If server doesn't have, delete from local, cascading
      else if (!serverCats.any((c) => c.id == id)) {
        await _deleteCategory(id);
      } else {
        // Update local with server, just in case the name has changed
        await factFileCategoryBean
            .update(serverCats.firstWhere((c) => c.id == id));
      }
    }
  }

  Future<void> _syncFactFiles() async {
    // Get local entries
    List<FactFileEntry> localEntries = await factFileEntryBean.getAll();

    // Get server entries
    List<FactFileData> serverEntries = await _getFactFilesSummary();

    Set<int> idSet = localEntries
        .map((e) => e.id)
        .toSet()
        .union(serverEntries.map((e) => e.id).toSet());

    for (int id in idSet) {
      if (!localEntries.any((e) => e.id == id)) {
        // Download new fact file
        await _downloadFactFile(id);
      } else if (!serverEntries.any((e) => e.id == id)) {
        // Delete old fact file from local
        await _deleteFactFile(id);
      } else if (localEntries
          .firstWhere((e) => e.id == id)
          .updatedAt
          .isAfter(serverEntries.firstWhere((e) => e.id == id).updatedAt)) {
        // Update factfile entry
        await _updateFactFile(id);
      }
    }
  }

  Future<List<FactFileData>> _getFactFilesSummary() async {
    String jsonString =
        await NetworkUtil.requestDataString(Env.factFilesListUrl(server));
    List<dynamic> decodedJson = json.decode(jsonString);
    return decodedJson.map((map) => FactFileData.fromMap(map)).toList();
  }
}
