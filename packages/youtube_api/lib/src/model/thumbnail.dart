
/// https://developers.google.com/youtube/v3/docs/thumbnails
class Thumbnails {
  Thumbnails({
    this.thumbnail,
    this.medium,
    this.high,
    this.standard,
    this.maxres,
  });

  /// default: The default thumbnail image.
  /// 120px wide and 90px tall
  Thumbnail thumbnail;
  /// medium: A higher resolution version of the thumbnail image
  /// 320px wide and 180px tall
  Thumbnail medium;
  /// high: A high resolution version of the thumbnail image
  /// 480px wide and 360px tall
  Thumbnail high;
  /// standard: An even higher resolution version of the thumbnail image
  /// 640px wide and 480px tall
  Thumbnail standard;
  /// maxres: The highest resolution version of the thumbnail image
  /// 1280px wide and 720px tall
  Thumbnail maxres;

  Thumbnails.fromJson(Map<String, dynamic> json) {
    if (json != null) {
      if (json["default"] != null) {
        thumbnail = Thumbnail.fromJson(json["default"]);
      }
      if (json["default"] != null) {
        medium = Thumbnail.fromJson(json["medium"]);
      }
      if (json["default"] != null) {
        high = Thumbnail.fromJson(json["high"]);
      }
      if (json["default"] != null) {
        standard = Thumbnail.fromJson(json["standard"]);
      }
      if (json["default"] != null) {
        maxres = Thumbnail.fromJson(json["maxres"]);
      }
    }
  }

  Map<String, dynamic> toJson() => {
        "default": thumbnail.toJson(),
        "medium": medium.toJson(),
        "high": high.toJson(),
        "standard": standard.toJson(),
        "maxres": maxres.toJson(),
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

  factory Thumbnail.fromJson(Map<String, dynamic> json) {
    if (json == null) {
      return null;
    }
    return Thumbnail(
      url: json["url"],
      width: json["width"],
      height: json["height"],
    );
  }

  Map<String, dynamic> toJson() => {
        "url": url,
        "width": width,
        "height": height,
      };
}
