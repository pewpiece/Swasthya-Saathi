import 'package:flutter/material.dart';

/// Bottom row of big buttons. Put it in `Scaffold.bottomNavigationBar`, so
/// messages such as "Saved" appear above it and never cover a button.
class ActionBar extends StatelessWidget {
  const ActionBar({super.key, required this.children});
  final List<Widget> children;

  @override
  Widget build(BuildContext context) => Material(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
            child: Row(children: children),
          ),
        ),
      );
}
