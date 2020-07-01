import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import '../youtube_api.dart';

/// Returns a list of videos that match the API request parameters.
class CategoryAPI {
  Map<String, String> _options;
  List<Category> results;

  /// Cost 1
  /// https://www.googleapis.com/youtube/v3/videoCategories?part=snippet&regionCode=EN&key=[KEY]
  /// Returns a list of categories that can be associated with YouTube videos.
  CategoryAPI.results({String regionCode, String language}) {
    _options = {
      "part": "snippet",
      if (language != null) "hl": language,
      "key": YoutubeAPI.key,
      "regionCode": regionCode ?? YoutubeAPI.regionCode
    };
  }

  /// optional
  /// part=contentDetails,statistics,snippet
  Future<List<Category>> _load(Map<String, String> options) async {
    final Uri url =
        Uri.https(YoutubeAPI.baseURL, "youtube/v3/videoCategories", options);

    final res = await http.get(url, headers: {"Accept": "application/json"});
    final jsonData = json.decode(res.body);

    if (jsonData == null) {
      return [];
    }
    final List<Category> result = [];
    for (final item in jsonData['items']) {
      result.add(Category.fromJson(item));
    }
    log(url);
    log({"totalResults": result.length});
    return result;
  }

  Future<List> load() async {
    if (results != null) {
      return results;
    }
    try {
      return _load(_options);
    } catch (e) {
      log(e);
      return null;
    }
  }
}
