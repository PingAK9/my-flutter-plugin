import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import '../youtube_api.dart';

/// Returns a list of videos that match the API request parameters.
class ChannelAPI {
  Map<String, String> _options;
  List<Channel> results;

  /// https://www.googleapis.com/youtube/v3/channels?part=snippet,statistics&forUsername=[forUsername]&key=[KEY]
  ChannelAPI.forUsername({
    String forUsername,
    bool statistics = false,
  }) {
    final List<String> part = [
      "snippet",
      if (statistics) "statistics",
    ];
    _options = {
      "part": listStringToString(part),
      "key": YoutubeAPI.key,
      "forUsername": forUsername
    };
  }

  /// https://www.googleapis.com/youtube/v3/channels?part=snippet,statistics&id=[id]&key=[KEY]
  ChannelAPI.byChannelID({
    String id,
    bool statistics = false,
  }) {
    final List<String> part = [
      "snippet",
      if (statistics) "statistics",
    ];
    _options = {
      "part": listStringToString(part),
      "key": YoutubeAPI.key,
      "id": id
    };
  }

  /// optional
  /// part=contentDetails,statistics,snippet
  Future<List<Channel>> _load(Map<String, String> options) async {
    final Uri url =
        Uri.https(YoutubeAPI.baseURL, "youtube/v3/videoCategories", options);

    final res = await http.get(url, headers: {"Accept": "application/json"});
    final jsonData = json.decode(res.body);

    if (jsonData == null) {
      return [];
    }
    final List<Channel> result = [];
    for (final item in jsonData['items']) {
      result.add(Channel.fromJson(item));
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
