/// One headed section of a legal document.
class LegalSection {
  const LegalSection(this.heading, this.paragraphs);

  final String heading;
  final List<String> paragraphs;
}

/// A document shown in the app: Privacy Policy, Terms or About.
class LegalDocument {
  const LegalDocument({
    required this.slug,
    required this.title,
    required this.updated,
    required this.intro,
    required this.sections,
  });

  /// Used in the route, e.g. `/legal/privacy`.
  final String slug;
  final String title;
  final String updated;
  final String intro;
  final List<LegalSection> sections;
}
