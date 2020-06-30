import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import '../youtube_api.dart';
import 'model/video.dart';

/// Returns a list of videos that match the API request parameters.
class VideoAPI {
  String nextPageToken;
  int page = -1;
  int totalResults;
  int resultsPerPage;
  int maxResults;
  Map<String, String> options;
  List<Video> videos;
  String unencodedPath;

  /// cost snippet 3
  /// cost contentDetails 2
  /// cost statistics 2
  /// https://www.googleapis.com/youtube/v3/videos?chart=mostPopular&part=snippet
  /// Return List trending
  VideoAPI.mostPopular({
    this.maxResults = 10,
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
    };
    unencodedPath = "youtube/v3/videos";
  }

  /// https://www.googleapis.com/youtube/v3/videos?id=[videoID]&part=snippet
  ///  This example retrieves information about a specific video.
  ///  It uses the id parameter to identify the video.
  VideoAPI.videoID(
    String videoID, {
    this.maxResults = 10,
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
    unencodedPath = "youtube/v3/videos";
  }

  /// https://www.googleapis.com/youtube/v3/videos?id=[videoIDs_0,videoIDs_1]&part=snippet
  ///  List by ID
  VideoAPI.multipleVideoID(
    List<String> videoIDs, {
    this.maxResults = 10,
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
    unencodedPath = "youtube/v3/videos";
  }

  /// https://www.googleapis.com/youtube/v3/search?d=[keyword]&part=snippet
  ///  Search by keyword
  VideoAPI.searchVideo(String keyword,
      {this.maxResults = 10, String regionCode}) {
    page = 0;
    options = {
      "d": keyword,
      "type": "video",
      "regionCode": regionCode ?? YoutubeAPI.regionCode,
      "key": YoutubeAPI.key,
      "maxResults": "$maxResults",
      "part": "snippet",
    };
    unencodedPath = "youtube/v3/search";
  }

  /// https://www.googleapis.com/youtube/v3/search?relatedToVideoId=[id]&part=snippet
  ///  Search by keyword
  VideoAPI.relatedToVideoId(String id,
      {this.maxResults = 10, String regionCode}) {
    page = 0;
    options = {
      "relatedToVideoId": id,
      "type": "video",
      "regionCode": regionCode ?? YoutubeAPI.regionCode,
      "key": YoutubeAPI.key,
      "maxResults": "$maxResults",
      "part": "snippet",
    };
    unencodedPath = "youtube/v3/search";
  }

  /// optional
  /// part=contentDetails,statistics,snippet
  Future<List<Video>> _load(Map<String, String> options) async {
    final Uri url = Uri.https(YoutubeAPI.baseURL, unencodedPath, options);

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
      result.add(Video.fromJson(jsonData['items'][i]));
    }
    log(url);
    log({"totalResults": totalResults, "resultsPerPage": resultsPerPage});
    return result;
  }

  Future<List> loadFirstPage() async {
    try {
      videos = await _load(options);
      page = 0;
      return videos;
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
      page--;
      videos.addAll(result);
      return result;
    } catch (e) {
      log(e);
      return null;
    }
  }
}
