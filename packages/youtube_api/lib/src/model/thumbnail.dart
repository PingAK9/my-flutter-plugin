class Thumbnails {
  Thumbnails({
    this.thumbnail,
    this.medium,
    this.high,
    this.standard,
    this.maxres,
  });

  Thumbnail thumbnail;
  Thumbnail medium;
  Thumbnail high;
  Thumbnail standard;
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
