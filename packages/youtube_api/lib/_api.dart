class API {
  String key;
  int maxResults;
  String order;
  String safeSearch;
  String type;
  String videoDuration;
  String nextPageToken;
  String prevPageToken;
  String query;
  String channelId;
  Object options;
  static String baseURL = 'www.googleapis.com';

  API({this.key, this.type, this.maxResults, this.query});

  Uri searchUri(String query, {String type}) {
    this.query = query;
    this.type = type ?? this.type;
    this.channelId = null;
    final options = getOption();
    final Uri url = Uri.https(baseURL, "youtube/v3/search", options);
    return url;
  }

  Uri channelUri(String channelId, String order) {
    this.order = order ?? 'date';
    this.channelId = channelId;
    final  options = getChannelOption(channelId, this.order);
    final Uri url = Uri.https(baseURL, "youtube/v3/search", options);
    return url;
  }

  Uri videoUri(List<String> videoId) {
    final int length = videoId.length;
    final String videoIds = videoId.join(',');
    final  options = getVideoOption(videoIds, length);
    final Uri url = Uri.https(baseURL, "youtube/v3/videos", options);
    return url;
  }

  /// https://www.googleapis.com/youtube/v3/videos?part=contentDetails&chart=mostPopular&regionCode=IN&maxResults=25&key=AIzaSyCpONvrkea-rPQtyP97OdmbDsb0hyK8rw0
  Uri listUri({String part, String chart}) {
    final Uri url = Uri.https(baseURL, "youtube/v3/videos", options);
    return url;
  }

//  For Getting Getting Next Page
  Uri nextPageUri() {
    final options = this.channelId == null ? getOptions("pageToken", nextPageToken) : getChannelPageOption(channelId, "pageToken", nextPageToken);
    final Uri url = Uri.https(baseURL, "youtube/v3/search", options);
    return url;
  }

//  For Getting Getting Previous Page
  Uri prevPageUri() {
    final options = this.channelId == null ? getOptions("pageToken", prevPageToken) : getChannelPageOption(channelId, "pageToken", prevPageToken);
    final Uri url = Uri.https(baseURL, "youtube/v3/search", options);
    return url;
  }

  Object getOptions(String key, String value) {
    final Object options = {
      key: value,
      "q": "${this.query}",
      "part": "snippet",
      "maxResults": "${this.maxResults}",
      "key": "${this.key}",
      "type": "${this.type}"
    };
    return options;
  }

  Object getOption() {
    final Object options = {
      "q": "${this.query}",
      "part": "snippet",
      "maxResults": "${this.maxResults}",
      "key": "${this.key}",
      "type": "${this.type}"
    };
    return options;
  }

  Object getChannelOption(String channelId, String order) {
    final Object options = {
      'channelId': channelId,
      "part": "snippet",
      'order': this.order,
      "maxResults": "${this.maxResults}",
      "key": "${this.key}",
    };
    return options;
  }

  Object getChannelPageOption(String channelId, String key, String value) {
    final Object options = {
      key: value,
      'channelId': channelId,
      "part": "snippet",
      "maxResults": "${this.maxResults}",
      "key": "${this.key}",
    };
    return options;
  }

  Object getVideoOption(String videoIds, int length) {
    final Object options = {
      "part": "contentDetails",
      "id": videoIds,
      "maxResults": "$length",
      "key": "${this.key}",
    };
    return options;
  }

  String setNextPageToken(String token) => this.nextPageToken = token;
  String setPrevPageToken(String token) => this.nextPageToken = token;
}
