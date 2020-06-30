import 'package:youtube_api/youtube_api.dart';

class Video {
  ContentDetailsVideo contentDetails;
  String id;
  SnippetVideo snippet;
  StatisticsVideo statistics;

  Video.fromJson(Map data) {
    if (data['id'] is String) {
      id = data['id'];
    } else {
      id = data['id']["videoId"];
    }
    snippet = SnippetVideo.fromJson(data["snippet"]);
    if (data['contentDetails'] != null) {
      contentDetails = ContentDetailsVideo.fromJson(data['contentDetails']);
    }
    if (data['statistics'] != null) {
      statistics = StatisticsVideo.fromJson(data["statistics"]);
    }
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "contentDetails": contentDetails?.toJson(),
        "statistics": statistics?.toJson(),
        "snippet": snippet?.toJson()
      };

  String viewCountDisplay() {
    return "2.3m views";
  }

  String publishedAtDisplay() {
    return "3 days ago";
  }
}

class ContentDetailsVideo {
  ContentDetailsVideo({
    this.duration,
    this.dimension,
    this.definition,
    this.caption,
    this.licensedContent,
    this.projection,
  });

  String duration;
  String dimension;
  String definition;
  String caption;
  bool licensedContent;
  String projection;

  String _getDuration(String text) {
    if (text.isEmpty) {
      return null;
    }
    String duration = text.replaceFirst("PT", "");

    final validDuration = ["H", "M", "S"];
    if (!duration.contains(RegExp(r'[HMS]'))) {
      return null;
    }
    var hour = 0, min = 0, sec = 0;
    for (int i = 0; i < validDuration.length; i++) {
      final index = duration.indexOf(validDuration[i]);
      if (index != -1) {
        final valInString = duration.substring(0, index);
        final val = int.parse(valInString);
        if (i == 0) {
          hour = val;
        } else if (i == 1) {
          min = val;
        } else if (i == 2) {
          sec = val;
        }
        duration = duration.substring(valInString.length + 1);
      }
    }
    final List buff = [];
    if (hour != 0) {
      buff.add(hour);
    }
    if (min == 0) {
      if (hour != 0) {
        buff.add(min.toString().padLeft(2, '0'));
      }
    } else {
      buff.add(min.toString().padLeft(2, '0'));
    }
    buff.add(sec.toString().padLeft(2, '0'));

    return buff.join(":");
  }

  factory ContentDetailsVideo.fromJson(Map<String, dynamic> json) => ContentDetailsVideo(
        duration: json["duration"],
        dimension: json["dimension"],
        definition: json["definition"],
        caption: json["caption"],
        licensedContent: json["licensedContent"],
        projection: json["projection"],
      );

  Map<String, dynamic> toJson() => {
        "duration": duration,
        "dimension": dimension,
        "definition": definition,
        "caption": caption,
        "licensedContent": licensedContent,
        "projection": projection,
      };
}

class StatisticsVideo {
  StatisticsVideo({
    this.viewCount,
    this.likeCount,
    this.dislikeCount,
    this.favoriteCount,
    this.commentCount,
  });

  String viewCount;
  String likeCount;
  String dislikeCount;
  String favoriteCount;
  String commentCount;

  factory StatisticsVideo.fromJson(Map<String, dynamic> json) =>
      StatisticsVideo(
        viewCount: json["viewCount"],
        likeCount: json["likeCount"],
        dislikeCount: json["dislikeCount"],
        favoriteCount: json["favoriteCount"],
        commentCount: json["commentCount"],
      );

  Map<String, dynamic> toJson() => {
        "viewCount": viewCount,
        "likeCount": likeCount,
        "dislikeCount": dislikeCount,
        "favoriteCount": favoriteCount,
        "commentCount": commentCount,
      };
}

class SnippetVideo {
  SnippetVideo({
    this.publishedAt,
    this.channelId,
    this.title,
    this.description,
    this.thumbnails,
    this.channelTitle,
    this.tags,
    this.categoryId,
    this.liveBroadcastContent,
    this.defaultAudioLanguage,
  });

  DateTime publishedAt;
  String channelId;
  String title;
  String description;
  Thumbnails thumbnails;
  String channelTitle;
  List<String> tags;
  String categoryId;
  String liveBroadcastContent;
  String defaultAudioLanguage;

  String get channelUrl => "https://www.youtube.com/channel/$channelId";

  factory SnippetVideo.fromJson(Map<String, dynamic> json) => SnippetVideo(
        publishedAt: DateTime.parse(json["publishedAt"]),
        channelId: json["channelId"],
        title: json["title"],
        description: json["description"],
        thumbnails: Thumbnails.fromJson(json["thumbnails"]),
        channelTitle: json["channelTitle"],
        tags: List<String>.from(json["tags"].map((x) => x)),
        categoryId: json["categoryId"],
        liveBroadcastContent: json["liveBroadcastContent"],
        defaultAudioLanguage: json["defaultAudioLanguage"],
      );

  Map<String, dynamic> toJson() => {
        "publishedAt": publishedAt.toIso8601String(),
        "channelId": channelId,
        "title": title,
        "description": description,
        "thumbnails": thumbnails.toJson(),
        "channelTitle": channelTitle,
        "tags": List<dynamic>.from(tags.map((x) => x)),
        "categoryId": categoryId,
        "liveBroadcastContent": liveBroadcastContent,
        "defaultAudioLanguage": defaultAudioLanguage,
      };
}