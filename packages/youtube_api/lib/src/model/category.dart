
/// A videoCategory resource identifies a category that has been or could be associated with uploaded videos.
/// "kind": "youtube#videoCategory"
/// https://developers.google.com/youtube/v3/docs/videoCategories
class Category {
  Category({
    this.id,
    this.title,
    this.channelId,
  });

  String id;
  String title;
  String channelId;

  factory Category.fromJson(Map<String, dynamic> json) => Category(
    id: json["id"],
    title: json["snippet"]["title"],
    channelId: json["snippet"]["channelId"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "snippet": {"title": title, "channelId": channelId},
  };
}
