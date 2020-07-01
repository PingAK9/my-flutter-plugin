library youtube_api;

import 'package:flutter/material.dart';

export 'src/model/category.dart';
export 'src/model/channel.dart';
export 'src/model/playlist.dart';
export 'src/model/region.dart';
export 'src/model/thumbnail.dart';
export 'src/model/video.dart';

export 'src/category_api.dart';
export 'src/channel_api.dart';
export 'src/playlist_api.dart';
export 'src/region_api.dart';
export 'src/video_api.dart';

class YoutubeAPI {
  static init(String key, {String regionCode, String locale}) {
    YoutubeAPI.key = key;
    YoutubeAPI.regionCode = regionCode;
  }

  static String key;
  static const String baseURL = 'www.googleapis.com';
  /// default US
  static String regionCode;

  /// todo: update locale later
  /// Default en-US
  static String locale;
}

void log(Object message) {
  debugPrint('$message');
}

String listStringToString(List<String> list) {
  if (list == null || list.isEmpty) {
    return "";
  }
  final buffer = StringBuffer(list[0]);
  for (int i = 1; i < list.length; i++) {
    buffer.write(",${list[i]}");
  }
  return buffer.toString();
}

abstract class BaseAPI<T>{
  Map<String, String> options;
  List<T> results;
}