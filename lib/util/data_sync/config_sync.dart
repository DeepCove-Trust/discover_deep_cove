import 'dart:convert';

import 'package:flutter/material.dart';

import '../../data/db.dart';
import '../../data/models/config.dart';
import '../../env.dart';
import '../network_util.dart';

class ConfigSync {
  CmsServerLocation server;
  ConfigBean configBean;

  ConfigSync(SqfliteAdapter adapter, {@required this.server}) : configBean = ConfigBean(adapter);

  Future<void> sync() async {
    // Retrieve latest from server
    String jsonString = await NetworkUtil.requestDataString(Env.configUrl(server));
    Config serverConfig = configBean.fromMap(json.decode(jsonString));

    // Insert if not exists, else update
    if ((await configBean.find(1)) == null) {
      await configBean.insert(serverConfig);
      if (Env.debugMessages) print('Config added');
    } else {
      await configBean.update(serverConfig, onlyNonNull: true);
      if (Env.debugMessages) print('Config unchanged / updated');
    }
  }
}
