import 'package:flutter/material.dart';
import 'package:sfwf/core/config.dart';
import 'package:sfwf/seo/seo_data.dart';
import 'package:sfwf/seo/seo_provider.dart';
import 'dom_operations.dart';

export 'seo_data.dart';

class SeoController extends ChangeNotifier {
  final SFWFConfig config;
  SeoData _currentData = const SeoData();
  final DomOperations _dom = DomOperations();

  SeoController({required this.config});

  static SeoController of(BuildContext context) {
    return SeoControllerProvider.of(context);
  }

  void updatePage(SeoData data) {
    _currentData = _currentData.merge(data);
    _dom.applyToDom(_currentData, config);
    notifyListeners();
  }

  SeoData get currentData => _currentData;

  void setThemeColor(String color) {
    updatePage(SeoData(themeColor: color));
  }
}
