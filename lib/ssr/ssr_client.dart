import 'package:sfwf/seo/seo_controller.dart';
import 'ssr_hydrator.dart';

class SsrClient {
  final SeoController seoController;
  final SsrHydrator _hydrator;

  SsrClient({required this.seoController})
      : _hydrator = SsrHydrator(seoController: seoController);

  void hydrate() {
    _hydrator.hydrate();
  }
}
