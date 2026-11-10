import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kitchenary/core/constants/app_constants.dart';
import 'package:kitchenary/core/constants/legal_content.dart';
import 'package:kitchenary/core/theme/app_theme.dart';
import 'package:kitchenary/models/legal_document.dart';
import 'package:kitchenary/views/widgets/legal/legal_document_view.dart';

void main() {
  const documents = [
    LegalContent.privacy,
    LegalContent.terms,
    LegalContent.about,
  ];

  String textOf(LegalDocument document) => document.allText.join('\n');

  test('support email is the one real address', () {
    expect(AppConstants.supportEmail, 'sujinksureshofcl@gmail.com');
  });

  test('privacy policy is dated 9 November 2026', () {
    expect(LegalContent.privacy.updated, '9 November 2026');
  });

  test('privacy policy contact uses the support email', () {
    final contact = LegalContent.privacy.sections.last.blocks
        .whereType<LegalBulletList>()
        .expand((list) => list.items)
        .singleWhere((item) => item.label == 'Contact');
    expect(contact.text, contains(AppConstants.supportEmail));
  });

  test('every document shows the support email', () {
    for (final document in documents) {
      expect(textOf(document), contains(AppConstants.supportEmail));
    }
  });

  test('no placeholder text or other email addresses remain', () {
    final emailPattern = RegExp(r'[\w.+-]+@[\w-]+(?:\.[\w-]+)+');
    for (final document in documents) {
      final text = textOf(document);
      for (final placeholder in [
        'example.com',
        'TODO',
        'REPLACE',
        'your@',
        'YOUR_',
        'email@',
        'support@',
      ]) {
        expect(text, isNot(contains(placeholder)), reason: document.slug);
      }
      final emails = emailPattern.allMatches(text).map((m) => m.group(0));
      expect(
        emails.every((e) => e == AppConstants.supportEmail),
        isTrue,
        reason: document.slug,
      );
    }
  });

  test('only the Terms mention licences, pointing to Open-source notices', () {
    final licences = RegExp('licen[cs]es', caseSensitive: false);
    for (final document in [LegalContent.privacy, LegalContent.about]) {
      expect(
        textOf(document),
        isNot(matches(licences)),
        reason: document.slug,
      );
    }
    final mentions = LegalContent.terms.allText
        .where(licences.hasMatch)
        .toList();
    expect(mentions, hasLength(1));
    expect(mentions.single, contains('Open-source notices in Profile > About'));
  });

  test('bySlug finds each document', () {
    for (final document in documents) {
      expect(LegalContent.bySlug(document.slug), same(document));
    }
    expect(LegalContent.bySlug('missing'), isNull);
  });

  for (final dark in [false, true]) {
    testWidgets('privacy policy renders in ${dark ? 'dark' : 'light'} mode', (
      tester,
    ) async {
      await tester.pumpWidget(
        ScreenUtilInit(
          designSize: const Size(390, 844),
          builder: (_, _) => MaterialApp(
            theme: dark ? AppTheme.dark : AppTheme.light,
            home: const Scaffold(
              body: LegalDocumentView(document: LegalContent.privacy),
            ),
          ),
        ),
      );
      expect(find.text('Last updated: 9 November 2026'), findsOneWidget);
      await tester.scrollUntilVisible(find.text('Summary'), 200);
      await tester.scrollUntilVisible(
        find.textContaining(AppConstants.supportEmail, findRichText: true),
        300,
      );
      expect(tester.takeException(), isNull);
    });
  }
}
