import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

const _legalDocumentsNames = [
  'Бонусная программа',
  'Калорийность и состав',
  'Полные условия акций',
  'Оферта',
  'Условия обработки персональных данных',
  'Анализ сетей пиццерий в России и Казахстане',
  'Пользовательское соглашение',
];

final _legalDocumentsUrls = <String, String>{
  'Бонусная программа': 'flutter.dev',
  'Калорийность и состав':
      'docs.google.com/document/d/1Jk9bxG_9HYiC9w3PjZ9gWmVhYVhR3kZlnsiDIRSA3a8',
  'Полные условия акций':
      'docs.google.com/document/d/1Jk9bxG_9HYiC9w3PjZ9gWmVhYVhR3kZlnsiDIRSA3a8',
  'Оферта':
      'docs.google.com/document/d/1Jk9bxG_9HYiC9w3PjZ9gWmVhYVhR3kZlnsiDIRSA3a8',
  'Условия обработки персональных данных':
      'docs.google.com/document/d/1Jk9bxG_9HYiC9w3PjZ9gWmVhYVhR3kZlnsiDIRSA3a8',
  'Анализ сетей пиццерий в России и Казахстане':
      'docs.google.com/document/d/1Jk9bxG_9HYiC9w3PjZ9gWmVhYVhR3kZlnsiDIRSA3a8',
  'Пользовательское соглашение':
      'docs.google.com/document/d/1Jk9bxG_9HYiC9w3PjZ9gWmVhYVhR3kZlnsiDIRSA3a8',
};

class LegalDocumentsView extends StatelessWidget {
  const LegalDocumentsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.black,
        title: const Text('Правовые документы'),
        leading: IconButton(
          icon: Icon(Icons.adaptive.arrow_back),
          onPressed: Navigator.of(context).pop,
        ),
      ),
      body: Column(
        children: List.generate(
          _legalDocumentsNames.length,
          (index) => ListTile(
            onTap: () {
              final url = Uri(
                scheme: 'https',
                path: _legalDocumentsUrls[_legalDocumentsNames[index]],
              );
              launchUrl(
                url,
                mode: LaunchMode.inAppWebView,
              );
            },
            title: Text(_legalDocumentsNames[index]),
          ),
        ),
      ),
    );
  }
}
