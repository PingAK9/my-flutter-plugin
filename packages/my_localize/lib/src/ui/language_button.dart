import 'package:flutter/material.dart';
import '../app_translations.dart';
import '../localize_data.dart';

import '../../my_localize.dart';

class LanguageButton extends StatefulWidget {
  const LanguageButton(this.flagPath);

  final String flagPath;

  @override
  _LanguageButtonState createState() => _LanguageButtonState();
}

class _LanguageButtonState extends State<LanguageButton> {
  List<LocalizeData> get languages => MyLocalize.instance.languages;

  String getImagePath(String code) {
    return '${widget.flagPath}$code.png';
  }

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      child: Image.asset(
        getImagePath(context.currentLanguage),
        width: 26,
        height: 26,
      ),
      onSelected: (code) async {
        await MyLocalize.instance.changeLanguage(code);
      },
      itemBuilder: (context) => <PopupMenuEntry<String>>[
        for (final item in languages)
          PopupMenuItem<String>(
            value: item.code,
            child: Row(
              children: <Widget>[
                Image.asset(
                  getImagePath(item.code),
                  width: 24,
                  height: 24,
                ),
                const SizedBox(width: 8),
                Text(
                  item.name,
                  style: TextStyle(
                      fontWeight: context.currentLanguage == item.code
                          ? FontWeight.w800
                          : FontWeight.w400),
                ),
              ],
            ),
          ),
      ],
    );
  }

  String code;

  Future clickLanguage(String code) async {
    await MyLocalize.instance.changeLanguage(code);
    setState(() {});
  }
}
