import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import '../youtube_api.dart';
import 'model/video.dart';

/// Returns a list of videos that match the API request parameters.
class VideoAPI extends BaseAPI<Video> {
  String nextPageToken;
  int page = -1;
  int totalResults;
  int resultsPerPage;

  /// max 50
  int maxResults;
  String _unencodedPath;
  String videoCategoryId;

  /// cost snippet 3
  /// cost contentDetails 2
  /// cost statistics 2
  /// https://www.googleapis.com/youtube/v3/videos?chart=mostPopular&part=snippet
  /// Return List trending
  VideoAPI.mostPopular({
    this.maxResults = 50,
    this.videoCategoryId,
    String regionCode,
    bool contentDetails = true,
    bool statistics = true,
  }) {
    final List<String> part = [
      "snippet",
      if (contentDetails) "contentDetails",
      if (statistics) "statistics",
    ];
    options = {
      "chart": "mostPopular",
      "regionCode": regionCode ?? YoutubeAPI.regionCode,
      "key": YoutubeAPI.key,
      "maxResults": "$maxResults",
      "part": listStringToString(part),
      if (videoCategoryId != null) "videoCategoryId": videoCategoryId
    };
    _unencodedPath = "youtube/v3/videos";
  }

  /// https://www.googleapis.com/youtube/v3/videos?id=[videoID]&part=snippet
  ///  This example retrieves information about a specific video.
  ///  It uses the id parameter to identify the video.
  VideoAPI.videoID(
    String videoID, {
    this.maxResults = 50,
    String regionCode,
    bool contentDetails = true,
    bool statistics = true,
  }) {
    final List<String> part = [
      "snippet",
      if (contentDetails) "contentDetails",
      if (statistics) "statistics",
    ];
    options = {
      "chart": "mostPopular",
      "id": videoID,
      "regionCode": regionCode ?? YoutubeAPI.regionCode,
      "key": YoutubeAPI.key,
      "maxResults": "$maxResults",
      "part": listStringToString(part),
    };
    _unencodedPath = "youtube/v3/videos";
  }

  /// https://www.googleapis.com/youtube/v3/videos?id=[videoIDs_0,videoIDs_1]&part=snippet
  ///  List by ID
  VideoAPI.multipleVideoID(
    List<String> videoIDs, {
    this.maxResults = 50,
    String regionCode,
    bool contentDetails = true,
    bool statistics = true,
  }) {
    final List<String> part = [
      "snippet",
      if (contentDetails) "contentDetails",
      if (statistics) "statistics",
    ];
    options = {
      "chart": "mostPopular",
      "id": listStringToString(videoIDs),
      "regionCode": regionCode ?? YoutubeAPI.regionCode,
      "key": YoutubeAPI.key,
      "maxResults": "$maxResults",
      "part": listStringToString(part),
    };
    _unencodedPath = "youtube/v3/videos";
  }

  /// https://www.googleapis.com/youtube/v3/search?d=[keyword]&part=snippet
  ///  Search by keyword
  VideoAPI.searchVideo(
    String keyword, {
    this.maxResults = 50,
    this.videoCategoryId,
    String regionCode,
  }) {
    options = {
      "d": keyword,
      "type": "video",
      "regionCode": regionCode ?? YoutubeAPI.regionCode,
      "key": YoutubeAPI.key,
      "maxResults": "$maxResults",
      "part": "snippet",
      if (videoCategoryId != null) "videoCategoryId": videoCategoryId
    };
    _unencodedPath = "youtube/v3/search";
  }

  /// https://www.googleapis.com/youtube/v3/search?relatedToVideoId=[id]&part=snippet
  ///  Search by video ID
  VideoAPI.relatedToVideoId(
    String id, {
    this.maxResults = 50,
    this.videoCategoryId,
    String regionCode,
  }) {
    options = {
      "relatedToVideoId": id,
      "type": "video",
      "regionCode": regionCode ?? YoutubeAPI.regionCode,
      "key": YoutubeAPI.key,
      "maxResults": "$maxResults",
      "part": "snippet",
      if (videoCategoryId != null) "videoCategoryId": videoCategoryId
    };
    _unencodedPath = "youtube/v3/search";
  }

  ///  videos by playlistItems
  ///  https://www.googleapis.com/youtube/v3/playlistItems?playlistId=PLOU2XLYxmsIL32BnYVuSqwgS0ClB_csKd
  VideoAPI.playlistItems(
    String playlistId, {
    this.maxResults = 50,
    bool contentDetails = true,
  }) {
    final List<String> part = [
      "snippet",
      if (contentDetails) "contentDetails",
    ];
    options = {
      "playlistId": playlistId,
      "key": YoutubeAPI.key,
      "maxResults": "$maxResults",
      "part": listStringToString(part),
    };
    _unencodedPath = "youtube/v3/playlistItems";
  }

  /// optional
  /// part=contentDetails,statistics,snippet
  Future<List<Video>> _load(Map<String, String> options) async {
    final Uri url = Uri.https(YoutubeAPI.baseURL, _unencodedPath, options);

    final res = await http.get(url, headers: {"Accept": "application/json"});
    final jsonData = json.decode(res.body);

    if (jsonData == null) {
      return [];
    }
    log(url);
    print(res.body);
    nextPageToken = jsonData['nextPageToken'];
    totalResults = jsonData['pageInfo']['totalResults'];
    resultsPerPage = jsonData['pageInfo']['resultsPerPage'];

    final int total = min(totalResults, resultsPerPage);
    final List<Video> result = [];
    for (int i = 0; i < total; i++) {
      result.add(Video.fromJson(jsonData['items'][i]));
    }
    log({"totalResults": totalResults, "resultsPerPage": resultsPerPage});
    return result;
  }

  Future<List> loadFirstPage() async {
    try {
      results = await _load(options);
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
        ..addAll(options);
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
