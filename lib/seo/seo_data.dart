class SeoData {
  final String? title;
  final String? description;
  final String? image;
  final String? ogType;
  final String? twitterCard;
  final String? keywords;
  final String? themeColor;
  final String? canonicalUrl;
  final String? locale;
  final bool? noIndex;
  final Map<String, dynamic>? structuredData;

  const SeoData({
    this.title,
    this.description,
    this.image,
    this.ogType,
    this.twitterCard,
    this.keywords,
    this.themeColor,
    this.canonicalUrl,
    this.locale,
    this.noIndex,
    this.structuredData,
  });

  SeoData merge(SeoData other) => SeoData(
        title: other.title ?? title,
        description: other.description ?? description,
        image: other.image ?? image,
        ogType: other.ogType ?? ogType,
        twitterCard: other.twitterCard ?? twitterCard,
        keywords: other.keywords ?? keywords,
        themeColor: other.themeColor ?? themeColor,
        canonicalUrl: other.canonicalUrl ?? canonicalUrl,
        locale: other.locale ?? locale,
        noIndex: other.noIndex ?? noIndex,
        structuredData: other.structuredData ?? structuredData,
      );
}
