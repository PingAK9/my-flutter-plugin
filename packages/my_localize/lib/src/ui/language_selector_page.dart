import 'package:flutter/material.dart';
import '../app_translations.dart';
import '../localize_data.dart';
import '../../my_localize.dart';

class LanguageSelectorPage extends StatefulWidget {
  @override
  _LanguageSelectorPageState createState() => _LanguageSelectorPageState();
}

class _LanguageSelectorPageState extends State<LanguageSelectorPage> {
  List<LocalizeData> languages = MyLocalize.instance.languages;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          context.text("change_language"),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const SizedBox(
            height: 32,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              context.text("change_language"),
              style: Theme.of(context).textTheme.headline6,
            ),
          ),
          Column(
            children: languages.map(buildButtonLanguage).toList(),
          )
        ],
      ),
    );
  }

  Widget buildButtonLanguage(LocalizeData item) {
    return RadioListTile<String>(
      activeColor: Theme.of(context).primaryColor,
      value: item.code,
      groupValue: context.currentLanguage,
      onChanged: onChangeMyLanguage,
      title: Text(item.name),
    );
  }

  Future onChangeMyLanguage(String value) async {
    await MyLocalize.instance.changeLanguage(value);
  }
}
