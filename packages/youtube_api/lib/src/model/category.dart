
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
