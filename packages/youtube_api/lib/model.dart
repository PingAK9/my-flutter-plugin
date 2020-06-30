class Video {
  String duration;
  String id;
  Snippet snippet;

  Video(Map data) {
    id = data['id'];
    duration = data['contentDetails']['duration'];
    snippet = Snippet.fromJson(data["snippet"]);
    duration = _getDuration(data["contentDetails"]["duration"]);
  }

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

}

class Snippet {
  Snippet({
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

  factory Snippet.fromJson(Map<String, dynamic> json) => Snippet(
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

class Thumbnails {
  Thumbnails({
    this.thumbnailsDefault,
    this.medium,
    this.high,
    this.standard,
  });

  Thumbnail thumbnailsDefault;
  Thumbnail medium;
  Thumbnail high;
  Thumbnail standard;

  factory Thumbnails.fromJson(Map<String, dynamic> json) => Thumbnails(
        thumbnailsDefault: Thumbnail.fromJson(json["default"]),
        medium: Thumbnail.fromJson(json["medium"]),
        high: Thumbnail.fromJson(json["high"]),
        standard: Thumbnail.fromJson(json["standard"]),
      );

  Map<String, dynamic> toJson() => {
        "default": thumbnailsDefault.toJson(),
        "medium": medium.toJson(),
        "high": high.toJson(),
        "standard": standard.toJson(),
      };
}

class Thumbnail {
  Thumbnail({
    this.url,
    this.width,
    this.height,
  });

  String url;
  int width;
  int height;

  factory Thumbnail.fromJson(Map<String, dynamic> json) => Thumbnail(
        url: json["url"],
        width: json["width"],
        height: json["height"],
      );

  Map<String, dynamic> toJson() => {
        "url": url,
        "width": width,
        "height": height,
      };
}
