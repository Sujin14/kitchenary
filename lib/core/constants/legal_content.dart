import 'package:kitchenary/core/constants/app_constants.dart';
import 'package:kitchenary/models/legal_document.dart';

/// The text of the in-app legal pages.
///
/// This is a starting draft written for how Kitchenary works today. Before
/// publishing on the Play Store: replace [AppConstants.supportEmail], have a
/// lawyer review it, host the same text at a public URL (Play Console asks
/// for a privacy policy link), and re-read it whenever a feature changes.
abstract final class LegalContent {
  static const String slugPrivacy = 'privacy';
  static const String slugTerms = 'terms';
  static const String slugAbout = 'about';

  static const String _updated = '4 October 2026';

  static LegalDocument? bySlug(String slug) => switch (slug) {
        slugPrivacy => privacy,
        slugTerms => terms,
        slugAbout => about,
        _ => null,
      };

  static const LegalDocument privacy = LegalDocument(
    slug: slugPrivacy,
    title: 'Privacy Policy',
    updated: _updated,
    intro:
        'Kitchenary is a free cooking app. We built it to keep your data on '
        'your phone, not on our servers. This page explains what that means.',
    sections: [
      LegalSection('What we collect', [
        'Kitchenary has no accounts and no sign-up. We do not run a server '
            'that stores information about you, and we do not collect your '
            'name, email address, phone number or location.',
        'Everything you create in the app stays on your device: the name '
            'you enter on the Profile screen, the recipes you save, the '
            'recipes you recently viewed, the recipes you write yourself and '
            'your theme choice.',
      ]),
      LegalSection('Data on your device', [
        'This data is stored only in the app\'s private storage on your '
            'phone. We cannot see it. Uninstalling the app, or using '
            '"Erase my data" on the Profile screen, deletes it.',
      ]),
      LegalSection('Recipes and photos from other services', [
        'Recipes and recipe photos are loaded from TheMealDB '
            '(www.themealdb.com). When the app loads them, TheMealDB and its '
            'hosting providers receive technical information that any website '
            'receives, such as your IP address and the words you searched '
            'for. Their own privacy policy applies to that information.',
        'Some recipes link to a video on YouTube or to the original recipe '
            'page. These open in your browser or in another app, and that '
            'service\'s privacy policy applies there.',
      ]),
      LegalSection('Analytics, ads and tracking', [
        'Kitchenary contains no advertising, no analytics tools and no '
            'tracking of any kind.',
      ]),
      LegalSection('Permissions', [
        'The app asks only for what it needs: internet access to load '
            'recipes, and, if you use cooking timers, permission to show a '
            'notification when a timer finishes. Timers and their '
            'notifications are scheduled on your device only.',
      ]),
      LegalSection('Children', [
        'Kitchenary is meant for a general audience and does not knowingly '
            'collect any information from anyone, including children. Since '
            'nothing is collected, there is nothing to share or sell.',
      ]),
      LegalSection('Your choices', [
        'You can erase everything the app has stored at any time from '
            'Profile, then "Erase my data". You can also clear your history '
            'from the Recently viewed screen, or delete individual saved '
            'recipes and your own recipes.',
      ]),
      LegalSection('Changes to this policy', [
        'If the app changes in a way that affects your privacy, we will '
            'update this page and the date at the top.',
      ]),
      LegalSection('Contact', [
        'Questions about privacy? Write to ${AppConstants.supportEmail}.',
      ]),
    ],
  );

  static const LegalDocument terms = LegalDocument(
    slug: slugTerms,
    title: 'Terms of Use',
    updated: _updated,
    intro:
        'By using Kitchenary you agree to these terms. If you do not agree, '
        'please do not use the app.',
    sections: [
      LegalSection('What Kitchenary is', [
        'Kitchenary is a free app that helps you find recipes, cook them '
            'step by step and keep your own recipe collection. It is provided '
            'for personal, non-commercial use.',
      ]),
      LegalSection('Cooking safety and allergies', [
        'Cooking involves heat, sharp tools and raw food. You are '
            'responsible for cooking safely: wash your hands, cook meat '
            'thoroughly, store food properly and never leave a hot stove '
            'unattended.',
        'Recipes may contain ingredients that cause allergic reactions. '
            'The ingredient lists, the veg / non-veg marks and the difficulty '
            'labels in the app are provided for convenience and may be '
            'incomplete or wrong. Always check ingredients and labels '
            'yourself, especially if you or the people you cook for have '
            'allergies or dietary needs. Kitchenary gives no medical or '
            'nutritional advice.',
      ]),
      LegalSection('Recipe content from others', [
        'Recipes and photos come from TheMealDB and are provided as they '
            'are. We do not check them and do not promise they are accurate, '
            'complete or that they will turn out well. Their copyright '
            'belongs to their respective owners.',
      ]),
      LegalSection('Your own recipes', [
        'Recipes you write stay on your device and remain yours. Please '
            'only enter content you have the right to use.',
      ]),
      LegalSection('Links to other services', [
        'The app may link to other websites and apps, such as YouTube or '
            'grocery services. We do not control them and are not '
            'responsible for them or for anything you buy through them.',
      ]),
      LegalSection('Using the app fairly', [
        'Do not misuse the app: do not try to break it, copy its code or '
            'design, overload the services it depends on, or use it for '
            'anything unlawful.',
      ]),
      LegalSection('Ownership', [
        'The Kitchenary name, logo, design and code belong to the '
            'developer. Open-source components are used under their own '
            'licences (see About and the open-source licences screen).',
      ]),
      LegalSection('No warranty', [
        'The app is provided "as is" and "as available", without promises '
            'of any kind. Recipe services may be slow, change or stop at any '
            'time, and the app may contain mistakes.',
      ]),
      LegalSection('Limit of liability', [
        'To the extent the law allows, the developer is not liable for any '
            'loss, injury, illness or damage that results from using the app '
            'or from cooking or eating food prepared with it.',
      ]),
      LegalSection('Changes', [
        'We may change the app or these terms. The date at the top shows '
            'when they were last updated. Continuing to use the app after a '
            'change means you accept the new terms.',
      ]),
      LegalSection('Governing law', [
        'These terms are governed by the laws of India. Disputes are '
            'subject to the courts of India.',
      ]),
      LegalSection('Contact', [
        'Questions about these terms? Write to ${AppConstants.supportEmail}.',
      ]),
    ],
  );

  static const LegalDocument about = LegalDocument(
    slug: slugAbout,
    title: 'About Kitchenary',
    updated: _updated,
    intro:
        'Kitchenary is a free cooking companion: learn a dish, shop for it, '
        'then cook it step by step.',
    sections: [
      LegalSection('Version', [AppConstants.appVersion]),
      LegalSection('Credits', [
        'Recipes and photos: TheMealDB (www.themealdb.com), a free, '
            'community-built recipe database.',
        'Fonts: Fraunces and DM Sans, used under the SIL Open Font '
            'License 1.1.',
        'Built with Flutter and open-source packages. Their licences are '
            'listed under "Open-source licences" on the Profile screen.',
      ]),
      LegalSection('Feedback', [
        'Found a mistake or have an idea? Write to '
            '${AppConstants.supportEmail}.',
      ]),
    ],
  );
}
