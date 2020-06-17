import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:mylocalize/my_localize.dart';

void main() {
  MyLocalize.instance.init(
    defaultLanguage:
        LocalizeData(code: "en", name: "English", files: ["common_en"]),
    path: "assets/json/",
    languages: [
      LocalizeData(code: "vi", name: "Tiếng Việt", files: ["common_vi"]),
      LocalizeData(code: "fr", name: "France", files: ["common_fr"]),
    ],
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return WidgetLocalize(
      builder: (context, code) {
        return MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            primarySwatch: Colors.blue,
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          localeResolutionCallback: (deviceLocale, supportedLocales) {
            return context.appTranslation?.locale ?? deviceLocale;
          },
          localizationsDelegates: [
            AppTranslationsDelegate.delegate,
            GlobalCupertinoLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
          ],
          supportedLocales: MyLocalize.instance.supportedLocales(),
          home: MyHomePage(),
        );
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.text("title")),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: LanguageButton("assets/image/"),
          )
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(context.text("message")),
            RaisedButton(
              child: Text(context.text("change_language")),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => LanguageSelectorPage(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
