import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;

import '../youtube_api.dart';
import 'model/playlist.dart';

/// Returns a list of videos that match the API request parameters.
class PlaylistAPI {
  /// max 50
  int maxResults;
  int page = -1;
  String nextPageToken;
  int totalResults;
  int resultsPerPage;
  Map<String, String> _options;
  List<Playlist> results;

  /// cost snippet 3
  /// cost contentDetails 2
  /// https://www.googleapis.com/youtube/v3/playlists?part=snippet,contentDetails&channelId=[id]&key=[KEY]
  PlaylistAPI.byChannelID({
    String channelId,
    this.maxResults = 50,
    bool contentDetails = false,
  }) {
    final List<String> part = [
      "snippet",
      if (contentDetails) "contentDetails",
    ];
    _options = {
      "part": listStringToString(part),
      "key": YoutubeAPI.key,
      "channelId": channelId
    };
  }

  /// optional
  /// part=contentDetails,statistics,snippet
  Future<List<Playlist>> _load(Map<String, String> _options) async {
    final Uri url =
        Uri.https(YoutubeAPI.baseURL, "youtube/v3/playlists", _options);

    final res = await http.get(url, headers: {"Accept": "application/json"});
    final jsonData = json.decode(res.body);

    if (jsonData == null) {
      return [];
    }
    final List<Playlist> result = [];
    for (final item in jsonData['items']) {
      result.add(Playlist.fromJson(item));
    }
    log(url);
    log({"totalResults": result.length});
    return result;
  }

  Future<List> loadFirstPage() async {
    try {
      results = await _load(_options);
      page = 0;
      return results;
    } catch (e) {
      log(e);
      return null;
    }
  }

  /// To go on Next Page
  Future<List> nextPage() async {
    if (nextPageToken == null) {
      return null;
    }
    try {
      final Map<String, String> nextOptions = {"pageToken": nextPageToken}
        ..addAll(_options);
      final result = await _load(nextOptions);
      page++;
      results.addAll(result);
      return result;
    } catch (e) {
      log(e);
      return null;
    }
  }
}
