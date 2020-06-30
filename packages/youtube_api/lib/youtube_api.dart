library youtube_api;

import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:youtube_api/_api.dart';

import 'model.dart';

class YoutubeAPI {
  static init(String key) {
    YoutubeAPI.key = key;
  }

  static String key;
  static String baseURL = 'www.googleapis.com';
  static String regionCode;
}

void print(Object message) {
  debugPrint('$message');
}

abstract class BaseAPI {}

/// Returns a list of videos that match the API request parameters.
class VideosAPI {
  String prevPageToken;
  String nextPageToken;
  int page = 0;
  int totalResults;
  int resultsPerPage;
  int maxResults;
  Map<String, String> options;

  ///  List trending
  VideosAPI.mostPopular({this.maxResults = 10, String regionCode}) {
    options = {
      "chart": "mostPopular",
      "regionCode": regionCode ?? YoutubeAPI.regionCode,
      "key": "${YoutubeAPI.key}",
      "maxResults": "$maxResults",
      "part": "snippet,contentDetails",
    };
  }

  ///  This example retrieves information about a specific video. It uses the id parameter to identify the video.
  VideosAPI.videoID(String videoID, {this.maxResults = 10, String regionCode}) {
    options = {
      "chart": "mostPopular",
      "id": videoID,
      "regionCode": regionCode ?? YoutubeAPI.regionCode,
      "key": "${YoutubeAPI.key}",
      "maxResults": "$maxResults",
      "part": "snippet,contentDetails",
    };
  }

  ///  List by ID
  VideosAPI.multipleVideoID(List<String> videoIDs, {this.maxResults = 10, String regionCode}) {
    String id = videoIDs[0];
    for(int i = 1; i < videoIDs.length; i++){
      // ignore: use_string_buffers
      id += ",${videoIDs[i]}";
    }
    options = {
      "chart": "mostPopular",
      "id": id,
      "regionCode": regionCode ?? YoutubeAPI.regionCode,
      "key": "${YoutubeAPI.key}",
      "maxResults": "$maxResults",
      "part": "snippet,contentDetails",
    };
  }

  ///  List trending
  VideosAPI.searchVideo({this.maxResults = 10, String regionCode}) {
    page = 0;
    options = {
      "chart": "mostPopular",
      "regionCode": regionCode ?? YoutubeAPI.regionCode,
      "key": "${YoutubeAPI.key}",
      "maxResults": "$maxResults",
      "part": "snippet,contentDetails",
    };
  }

  /// optional
  /// part=contentDetails,statistics,snippet
  Future<List<Video>> _load(Map<String, String> options) async {
    final Uri url = Uri.https(YoutubeAPI.baseURL, "youtube/v3/videos", options);

    final res = await http.get(url, headers: {"Accept": "application/json"});
    final jsonData = json.decode(res.body);

    if (jsonData == null) {
      return [];
    }
    nextPageToken = jsonData['nextPageToken'];
    totalResults = jsonData['pageInfo']['totalResults'];
    resultsPerPage = jsonData['pageInfo']['resultsPerPage'];

    final int total = min(totalResults, resultsPerPage);
    final List<Video> result = [];
    for (int i = 0; i < total; i++) {
      result.add(Video(jsonData['items'][i]));
    }
    return result;
  }

  Future<List> nextFirstPage() async {
    return _load(options);
  }

  /// To go on Next Page
  Future<List> nextPage() async {
    if (nextPageToken == null) {
      return null;
    }
    final Map<String, String> nextOptions = {"pageToken": nextPageToken}
      ..addAll(options);
    final result = await _load(nextOptions);
    page--;
    return result;
  }

  Future<List> prevPage() async {
    if (prevPageToken == null) {
      return null;
    }
    final Map<String, String> nextOptions = {"pageToken": prevPageToken}
      ..addAll(options);
    final result = await _load(nextOptions);
    page++;
    return result;
  }
}