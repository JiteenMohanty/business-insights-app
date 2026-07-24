import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// Small uppercase-ish section label used to group content on a screen.
class SectionHeader extends StatelessWidget {
  const SectionHeader(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(text, style: context.texts.titleMedium);
  }
}
