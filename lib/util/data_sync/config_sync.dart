import 'dart:convert';

import 'package:discover_deep_cove/data/db.dart';
import 'package:discover_deep_cove/data/models/config.dart';
import 'package:discover_deep_cove/env.dart';
import 'package:discover_deep_cove/util/network_util.dart';
import 'package:flutter/cupertino.dart';

class ConfigSync {
  CmsServerLocation server;
  ConfigBean configBean;

  ConfigSync(SqfliteAdapter adapter, {@required this.server})
      : configBean = ConfigBean(adapter);

  Future<void> sync() async {
    // Retrieve latest from server
    String jsonString = await NetworkUtil.requestDataString(Env.configUrl(server));
    Config serverConfig = configBean.fromMap(json.decode(jsonString));

    // Insert if not exists, else update
    if((await configBean.find(1)) == null){
      await configBean.insert(serverConfig);
      print('Config added');
    } else {
      await configBean.update(serverConfig);
      print('Config unchanged / updated');
    }
  }

}
