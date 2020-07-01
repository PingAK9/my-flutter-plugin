
/// i18nRegion or i18nLanguage
/// "kind": "youtube#i18nRegion"
/// https://developers.google.com/youtube/v3/docs/i18nRegions
/// "kind": "youtube#i18nLanguage"
/// https://developers.google.com/youtube/v3/docs/i18nLanguages
class Region {
  Region({
    this.id,
    this.name,
  });

  String id;
  String name;

  factory Region.fromJson(Map<String, dynamic> json) => Region(
        id: json["id"],
        name: json["snippet"]["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "snippet": {"name": name},
      };
}
