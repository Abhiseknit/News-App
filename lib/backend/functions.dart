import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:quickup_app/components/searchbar.dart';
import 'package:quickup_app/utils/key.dart';

Future<List> fetchnews() async {
  final response = await http.get(
    Uri.parse('https://newsapi.org/v2/top-headlines?category=general&pageSize=100&apiKey=' +
        Key.key +
        '&q=' +
        SearchBar.searchcontroller.text),
  );
  Map result = jsonDecode(response.body);
  print('Fetched');

  return (result['articles']);
}