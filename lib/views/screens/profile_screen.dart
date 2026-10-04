import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kitchenary/core/constants/legal_content.dart';
import 'package:kitchenary/views/widgets/common/screen_header.dart';
import 'package:kitchenary/views/widgets/profile/erase_data_tile.dart';
import 'package:kitchenary/views/widgets/profile/history_tile.dart';
import 'package:kitchenary/views/widgets/profile/legal_tile.dart';
import 'package:kitchenary/views/widgets/profile/licences_tile.dart';
import 'package:kitchenary/views/widgets/profile/profile_header.dart';
import 'package:kitchenary/views/widgets/profile/settings_section.dart';
import 'package:kitchenary/views/widgets/profile/theme_mode_selector.dart';
import 'package:kitchenary/views/widgets/profile/version_tile.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const ScreenHeader(title: 'Profile'),
            Expanded(
              child: ListView(
                padding: EdgeInsets.fromLTRB(20.w, 4.h, 20.w, 32.h),
                children: [
                  const ProfileHeader(),
                  SizedBox(height: 24.h),
                  const SettingsSection(
                    title: 'APPEARANCE',
                    children: [ThemeModeSelector()],
                  ),
                  SizedBox(height: 24.h),
                  const SettingsSection(
                    title: 'YOUR KITCHEN',
                    children: [HistoryTile()],
                  ),
                  SizedBox(height: 24.h),
                  const SettingsSection(
                    title: 'ABOUT',
                    children: [
                      LegalTile(
                        icon: Icons.privacy_tip_outlined,
                        title: 'Privacy Policy',
                        slug: LegalContent.slugPrivacy,
                      ),
                      LegalTile(
                        icon: Icons.description_outlined,
                        title: 'Terms of Use',
                        slug: LegalContent.slugTerms,
                      ),
                      LegalTile(
                        icon: Icons.favorite_border,
                        title: 'About Kitchenary',
                        slug: LegalContent.slugAbout,
                      ),
                      LicencesTile(),
                      VersionTile(),
                    ],
                  ),
                  SizedBox(height: 24.h),
                  const SettingsSection(
                    title: 'DATA',
                    children: [EraseDataTile()],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
