

import 'package:youtube_api/youtube_api.dart';

class Channel {
  Channel({
    this.id,
    this.snippet,
    this.statistics,
  });

  String id;
  SnippetChannel snippet;
  StatisticsChannel statistics;

  Channel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    snippet = SnippetChannel.fromJson(json["snippet"]);
    if (json['statistics'] != null) {
      statistics = StatisticsChannel.fromJson(json["statistics"]);
    }
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "snippet": snippet.toJson(),
    "statistics": statistics.toJson(),
  };
}

class SnippetChannel {
  SnippetChannel({
    this.title,
    this.description,
    this.customUrl,
    this.publishedAt,
    this.thumbnails,
    this.country,
  });

  String title;
  String description;
  String customUrl;
  DateTime publishedAt;
  Thumbnails thumbnails;
  String country;

  factory SnippetChannel.fromJson(Map<String, dynamic> json) => SnippetChannel(
    title: json["title"],
    description: json["description"],
    customUrl: json["customUrl"],
    publishedAt: DateTime.parse(json["publishedAt"]),
    thumbnails: Thumbnails.fromJson(json["thumbnails"]),
    country: json["country"],
  );

  Map<String, dynamic> toJson() => {
    "title": title,
    "description": description,
    "customUrl": customUrl,
    "publishedAt": publishedAt.toIso8601String(),
    "thumbnails": thumbnails.toJson(),
    "country": country,
  };
}

class StatisticsChannel {
  StatisticsChannel({
    this.viewCount,
    this.commentCount,
    this.subscriberCount,
    this.hiddenSubscriberCount,
    this.videoCount,
  });

  String viewCount;
  String commentCount;
  String subscriberCount;
  bool hiddenSubscriberCount;
  String videoCount;

  factory StatisticsChannel.fromJson(Map<String, dynamic> json) =>
      StatisticsChannel(
        viewCount: json["viewCount"],
        commentCount: json["commentCount"],
        subscriberCount: json["subscriberCount"],
        hiddenSubscriberCount: json["hiddenSubscriberCount"],
        videoCount: json["videoCount"],
      );

  Map<String, dynamic> toJson() => {
    "viewCount": viewCount,
    "commentCount": commentCount,
    "subscriberCount": subscriberCount,
    "hiddenSubscriberCount": hiddenSubscriberCount,
    "videoCount": videoCount,
  };
}
