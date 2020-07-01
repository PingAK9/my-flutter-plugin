import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import '../youtube_api.dart';

/// Returns a list of videos that match the API request parameters.
class ChannelAPI extends BaseAPI<Channel> {
  /// cost 1
  /// It uses the forUsername request parameter to identify the channel by its YouTube username.
  /// https://www.googleapis.com/youtube/v3/channels?part=snippet,statistics&forUsername=[forUsername]&key=[YoutubeAPI.key]
  /// Returns a collection of zero or more channel resources that match the request criteria.
  ChannelAPI.forUsername({
    String forUsername,
    String locale,
    bool statistics = false,
  }) {
    final List<String> part = [
      "snippet",
      if (statistics) "statistics",
    ];
    options = {
      "forUsername": forUsername,
      "part": listStringToString(part),
      "hl": locale ?? YoutubeAPI.locale,
      "key": YoutubeAPI.key,
    };
  }

  ///  It uses the id request parameter to identify the channel by its YouTube channel ID.
  /// https://www.googleapis.com/youtube/v3/channels?part=snippet,statistics&id=[id]&key=[YoutubeAPI.key]
  ChannelAPI.byChannelID({
    String id,
    String locale,
    bool statistics = false,
  }) {
    final List<String> part = [
      "snippet",
      if (statistics) "statistics",
    ];
    options = {
      "id": id,
      "part": listStringToString(part),
      "hl": locale ?? YoutubeAPI.locale,
      "key": YoutubeAPI.key,
    };
  }

  /// youtube/v3/videoCategories
  Future<List<Channel>> _load() async {
    final Uri url =
        Uri.https(YoutubeAPI.baseURL, "youtube/v3/videoCategories", options);
    log(url);

    final res = await http.get(url, headers: {"Accept": "application/json"});
    final jsonData = json.decode(res.body);

    if (jsonData == null) {
      return [];
    }
    final List<Channel> result = [];
    for (final item in jsonData['items']) {
      result.add(Channel.fromJson(item));
    }
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
