import 'package:youtube_api/youtube_api.dart';

/// A playlist resource represents a YouTube playlist
/// "kind": "youtube#playlist"
/// https://developers.google.com/youtube/v3/docs/playlists
class Playlist {
  Playlist({
    this.id,
    this.snippet,
    this.contentDetails,
  });

  String id;
  SnippetPlaylist snippet;
  ContentDetailsPlaylist contentDetails;

  factory Playlist.fromJson(Map<String, dynamic> json) => Playlist(
    id: json["id"],
    snippet: SnippetPlaylist.fromJson(json["snippet"]),
    contentDetails: ContentDetailsPlaylist.fromJson(json["contentDetails"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "snippet": snippet.toJson(),
    "contentDetails": contentDetails.toJson(),
  };
}

class ContentDetailsPlaylist {
  ContentDetailsPlaylist({
    this.itemCount,
  });

  int itemCount;

  factory ContentDetailsPlaylist.fromJson(Map<String, dynamic> json) => ContentDetailsPlaylist(
    itemCount: json["itemCount"],
  );

  Map<String, dynamic> toJson() => {
    "itemCount": itemCount,
  };
}

class SnippetPlaylist {
  SnippetPlaylist({
    this.publishedAt,
    this.channelId,
    this.title,
    this.description,
    this.thumbnails,
    this.channelTitle,
  });

  DateTime publishedAt;
  String channelId;
  String title;
  String description;
  Thumbnails thumbnails;
  String channelTitle;

  factory SnippetPlaylist.fromJson(Map<String, dynamic> json) => SnippetPlaylist(
    publishedAt: DateTime.parse(json["publishedAt"]),
    channelId: json["channelId"],
    title: json["title"],
    description: json["description"],
    thumbnails: Thumbnails.fromJson(json["thumbnails"]),
    channelTitle: json["channelTitle"],
  );

  Map<String, dynamic> toJson() => {
    "publishedAt": publishedAt.toIso8601String(),
    "channelId": channelId,
    "title": title,
    "description": description,
    "thumbnails": thumbnails.toJson(),
    "channelTitle": channelTitle,
  };
}