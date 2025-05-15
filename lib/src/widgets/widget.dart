import 'package:flutter_tex/src/models/widget_meta.dart';

abstract class TeXViewWidget {
  const TeXViewWidget();

  TeXViewWidgetMeta meta();

  void onTapCallback(String id) {}

  void onWheelCallback(String id) {}

  Map<dynamic, dynamic> toJson();
}
