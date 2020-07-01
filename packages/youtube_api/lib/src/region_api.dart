import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import '../youtube_api.dart';

/// Returns a list of videos that match the API request parameters.
class RegionAPI extends BaseAPI<Region> {
  String _unencodedPath;

  /// Cost 1
  /// https://www.googleapis.com/youtube/v3/i18nRegions?part=snippet&key=[YoutubeAPI.key]
  /// Returns a list of content regions that the YouTube website supports.
  RegionAPI.results() {
    options = {
      "part": "snippet",
      "key": YoutubeAPI.key,
    };
    _unencodedPath = "youtube/v3/i18nRegions";
  }

  /// Cost 1
  /// https://www.googleapis.com/youtube/v3/i18nLanguages?part=snippet&key=[YoutubeAPI.key]
  /// Returns a list of application languages that the YouTube website supports.
  RegionAPI.language() {
    options = {
      "part": "snippet",
      "key": YoutubeAPI.key,
    };
    _unencodedPath = "youtube/v3/i18nLanguages";
  }

  Future<List<Region>> _load() async {
    final Uri url = Uri.https(YoutubeAPI.baseURL, _unencodedPath, options);

    final res = await http.get(url, headers: {"Accept": "application/json"});
    final jsonData = json.decode(res.body);

    if (jsonData == null) {
      return [];
    }
    final List<Region> result = [];
    for (final item in jsonData['items']) {
      result.add(Region.fromJson(item));
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
      return _load();
    } catch (e) {
      log(e);
      return null;
    }
  }
}
