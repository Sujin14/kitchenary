import 'package:kitchenary/core/constants/app_constants.dart';
import 'package:kitchenary/models/legal_document.dart';

// The text of the in-app legal pages.
// Re-read this whenever a feature that touches data or permissions changes,
// update [_updated], and publish the same Privacy Policy at a public URL
// (Play Console asks for a link).
abstract final class LegalContent {
  static const String slugPrivacy = 'privacy';
  static const String slugTerms = 'terms';
  static const String slugAbout = 'about';

  static const String _updated = '9 November 2026';

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
        'Kitchenary is a free cooking app: it needs no account, shows no ads, '
        'and has no analytics or tracking, so we do not collect or sell your '
        'personal information. Everything you create in the app stays on '
        'your phone.',
    sections: [
      LegalSection('Summary', [
        LegalBulletList([
          LegalBullet('You do not sign up or log in.'),
          LegalBullet(
            'The recipes, lists and settings you create are stored only on '
            'your device.',
          ),
          LegalBullet(
            'The app contacts one outside service, TheMealDB, to load '
            'recipes and photos.',
          ),
          LegalBullet(
            'No advertising, analytics or crash-reporting services are built '
            'into the app.',
          ),
          LegalBullet('You can erase all your data inside the app at any time.'),
        ]),
      ]),
      LegalSection('Information stored on your device', [
        LegalParagraph(
          'Kitchenary saves the following on your phone so the app works and '
          'remembers your choices. We never receive a copy of it.',
        ),
        LegalBulletList([
          LegalBullet(
            'Recipes you save, recipes you write yourself, and your recently '
            'viewed recipes.',
          ),
          LegalBullet('Your shopping list, including items you add by hand.'),
          LegalBullet(
            'The first name or nickname you may enter on the Profile screen, '
            'and your theme choice (light, dark or system).',
          ),
          LegalBullet('Active cooking timers and their end times.'),
          LegalBullet(
            'A cache of recipes and photos you have viewed, so they can open '
            'without internet.',
          ),
        ]),
        LegalParagraph(
          'This data lives in the app\'s private storage. Other apps cannot '
          'read it, and it is removed when you erase your data or uninstall '
          'the app.',
        ),
      ]),
      LegalSection('Third-party services', [
        LegalBulletList([
          LegalBullet(
            'Recipes, ingredients and photos come from TheMealDB '
            '(themealdb.com). When you browse, search or open a recipe, the '
            'app sends that request, such as your search words or a category, '
            'directly from your phone to TheMealDB. Like any internet '
            'service, TheMealDB can see your IP address and device type. We '
            'do not send them your name, saved recipes, shopping list or any '
            'other data from the app. Their handling of data is described in '
            'their own terms and privacy information.',
            label: 'TheMealDB',
          ),
          LegalBullet(
            'When you choose to order ingredients, Kitchenary opens a search '
            'for an item in a grocery app or website you pick (Blinkit, '
            'Zepto, Swiggy Instamart or BigBasket). Only the ingredient name '
            'is placed in the link. Once that app or site opens, its own '
            'privacy policy applies, and we do not receive anything from it. '
            'Kitchenary never places an order or handles payment.',
            label: 'Grocery apps',
          ),
          LegalBullet(
            'If you copy your shopping list, it goes to your phone\'s '
            'clipboard only when you tap the button. We do not read the '
            'clipboard at any other time.',
            label: 'Copy and share',
          ),
        ]),
      ]),
      LegalSection('Permissions the app uses', [
        LegalParagraph(
          'Kitchenary asks for only what its features need. None of these '
          'permissions is used to collect data about you.',
        ),
        LegalBulletList([
          LegalBullet(
            'load recipes and photos from TheMealDB.',
            label: 'Internet',
          ),
          LegalBullet(
            'tell you when a cooking timer finishes.',
            label: 'Notifications',
          ),
          LegalBullet(
            'ring the timer at the right second, even if the screen is off. '
            'If you deny it, timers still work but may be a little late.',
            label: 'Alarms and reminders (exact alarms)',
          ),
          LegalBullet(
            'vibrate when a timer finishes.',
            label: 'Vibrate',
          ),
          LegalBullet(
            'restore scheduled timers if your phone restarts.',
            label: 'Run at start-up',
          ),
          LegalBullet(
            'stop the screen from sleeping while you follow steps in cooking '
            'mode.',
            label: 'Keep screen on',
          ),
        ]),
        LegalParagraph(
          'You can turn any of these off in your phone\'s system settings. '
          'The app keeps working, but the related feature may not.',
        ),
      ]),
      LegalSection('How information is used', [
        LegalParagraph(
          'The data stored on your device is used only to run the features '
          'you see: showing your saved recipes, keeping your shopping list, '
          'greeting you by name, remembering your theme, and working '
          'offline. We do not:',
        ),
        LegalBulletList([
          LegalBullet('sell, rent or share your information with anyone;'),
          LegalBullet('show advertising or build an advertising profile;'),
          LegalBullet('track you across apps or websites;'),
          LegalBullet(
            'collect your location, contacts, photos, microphone or camera '
            'data;',
          ),
          LegalBullet(
            'create accounts or collect your email address or phone number.',
          ),
        ]),
      ]),
      LegalSection('Keeping and deleting your data', [
        LegalParagraph(
          'Your data stays on your phone until you remove it. You can delete '
          'a single saved recipe, your own recipe, a shopping item or your '
          'history from the screens where they appear.',
        ),
        LegalParagraph(
          'To remove everything at once, open Profile and choose the '
          'erase-data option, which clears saved recipes, your own recipes, '
          'history, shopping list, your name, settings, the offline recipe '
          'cache and cached photos. Uninstalling the app also removes all '
          'of it.',
        ),
        LegalParagraph(
          'Because we hold no copy of your data on any server, there is '
          'nothing for us to export or delete on our side.',
        ),
      ]),
      LegalSection('Children, security, changes and contact', [
        LegalBulletList([
          LegalBullet(
            'Kitchenary is a general cooking app and is not directed at '
            'children. We do not knowingly collect personal information from '
            'anyone, including children, because the app collects none.',
            label: 'Children',
          ),
          LegalBullet(
            'Your data is kept in the app\'s private storage on your device, '
            'and the app talks to TheMealDB over an encrypted (HTTPS) '
            'connection. Keep your phone locked and updated to protect what '
            'is stored on it.',
            label: 'Security',
          ),
          LegalBullet(
            'Kitchenary is made for users in India. We handle information in '
            'line with applicable Indian law, including the Digital Personal '
            'Data Protection Act, 2023.',
            label: 'Where this applies',
          ),
          LegalBullet(
            'If we add a feature that changes how information is handled, we '
            'will update this page and the date at the top before the change '
            'takes effect, and the in-app Privacy screen will show the new '
            'version.',
            label: 'Changes',
          ),
          LegalBullet(
            'Questions about this policy: ${AppConstants.supportEmail}.',
            label: 'Contact',
          ),
        ]),
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
        LegalParagraph(
          'Kitchenary is a free app that helps you find recipes, cook them '
          'step by step and keep your own recipe collection. It is provided '
          'for personal, non-commercial use.',
        ),
      ]),
      LegalSection('Cooking safety and allergies', [
        LegalParagraph(
          'Cooking involves heat, sharp tools and raw food. You are '
          'responsible for cooking safely: wash your hands, cook meat '
          'thoroughly, store food properly and never leave a hot stove '
          'unattended.',
        ),
        LegalParagraph(
          'Recipes may contain ingredients that cause allergic reactions. '
          'The ingredient lists, the veg / non-veg marks and the difficulty '
          'labels in the app are provided for convenience and may be '
          'incomplete or wrong. Always check ingredients and labels '
          'yourself, especially if you or the people you cook for have '
          'allergies or dietary needs. Kitchenary gives no medical or '
          'nutritional advice.',
        ),
      ]),
      LegalSection('Recipe content from others', [
        LegalParagraph(
          'Recipes and photos come from TheMealDB and are provided as they '
          'are. We do not check them and do not promise they are accurate, '
          'complete or that they will turn out well. Their copyright '
          'belongs to their respective owners.',
        ),
      ]),
      LegalSection('Your own recipes', [
        LegalParagraph(
          'Recipes you write stay on your device and remain yours. Please '
          'only enter content you have the right to use.',
        ),
      ]),
      LegalSection('Links to other services', [
        LegalParagraph(
          'The app may link to other websites and apps, such as YouTube or '
          'grocery services. We do not control them and are not '
          'responsible for them or for anything you buy through them.',
        ),
      ]),
      LegalSection('Using the app fairly', [
        LegalParagraph(
          'Do not misuse the app: do not try to break it, copy its code or '
          'design, overload the services it depends on, or use it for '
          'anything unlawful.',
        ),
      ]),
      LegalSection('Ownership', [
        LegalParagraph(
          'The Kitchenary name, logo, design and code belong to the '
          'developer. Open-source components are used under their own '
          'licences, listed under Open-source notices in Profile > About.',
        ),
      ]),
      LegalSection('No warranty', [
        LegalParagraph(
          'The app is provided "as is" and "as available", without promises '
          'of any kind. Recipe services may be slow, change or stop at any '
          'time, and the app may contain mistakes.',
        ),
      ]),
      LegalSection('Limit of liability', [
        LegalParagraph(
          'To the extent the law allows, the developer is not liable for any '
          'loss, injury, illness or damage that results from using the app '
          'or from cooking or eating food prepared with it.',
        ),
      ]),
      LegalSection('Changes', [
        LegalParagraph(
          'We may change the app or these terms. The date at the top shows '
          'when they were last updated. Continuing to use the app after a '
          'change means you accept the new terms.',
        ),
      ]),
      LegalSection('Governing law', [
        LegalParagraph(
          'These terms are governed by the laws of India. Disputes are '
          'subject to the courts of India.',
        ),
      ]),
      LegalSection('Contact', [
        LegalParagraph(
          'Questions about these terms? Write to ${AppConstants.supportEmail}.',
        ),
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
      LegalSection('Version', [LegalParagraph(AppConstants.appVersion)]),
      LegalSection('Credits', [
        LegalParagraph(
          'Recipes and photos: TheMealDB (www.themealdb.com), a free, '
          'community-built recipe database.',
        ),
        LegalParagraph(
          'Fonts: Fraunces and DM Sans, used under the SIL Open Font '
          'License 1.1.',
        ),
        LegalParagraph('Built with Flutter.'),
      ]),
      LegalSection('Feedback', [
        LegalParagraph(
          'Found a mistake or have an idea? Write to '
          '${AppConstants.supportEmail}.',
        ),
      ]),
    ],
  );
}
