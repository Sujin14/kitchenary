// One piece of a legal section: a paragraph or a bullet list.
sealed class LegalBlock {
  const LegalBlock();
}

// A plain paragraph.
class LegalParagraph extends LegalBlock {
  const LegalParagraph(this.text);

  final String text;
}

// One bullet, optionally led by a bold [label] (e.g. "Internet").
class LegalBullet {
  const LegalBullet(this.text, {this.label});

  final String text;
  final String? label;
}

// A bulleted list.
class LegalBulletList extends LegalBlock {
  const LegalBulletList(this.items);

  final List<LegalBullet> items;
}

// One headed section of a legal document.
class LegalSection {
  const LegalSection(this.heading, this.blocks);

  final String heading;
  final List<LegalBlock> blocks;
}

// A document shown in the app: Privacy Policy, Terms or About.
class LegalDocument {
  const LegalDocument({
    required this.slug,
    required this.title,
    required this.updated,
    required this.intro,
    required this.sections,
  });

  // Used in the route, e.g. `/legal/privacy`.
  final String slug;
  final String title;
  final String updated;
  final String intro;
  final List<LegalSection> sections;

  // Every piece of text in the document, in reading order.
  Iterable<String> get allText sync* {
    yield title;
    yield intro;
    for (final section in sections) {
      yield section.heading;
      for (final block in section.blocks) {
        switch (block) {
          case LegalParagraph(:final text):
            yield text;
          case LegalBulletList(:final items):
            for (final item in items) {
              if (item.label != null) yield item.label!;
              yield item.text;
            }
        }
      }
    }
  }
}
