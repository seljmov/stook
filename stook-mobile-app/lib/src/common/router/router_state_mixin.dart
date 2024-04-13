import 'package:flutter/material.dart';
import 'package:octopus/octopus.dart';

import 'routes.dart';

/// Миксин для работы с роутером.
mixin RouterStateMixin<T extends StatefulWidget> on State<T> {
  late final Octopus router;

  @override
  void initState() {
    router = Octopus(
      routes: Routes.values,
      defaultRoute: Routes.home,
    );
    super.initState();
  }
}
