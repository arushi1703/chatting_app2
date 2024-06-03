class UserProfile {
  String? uid;
  String? name;
  String? pfpURL;

  UserProfile({
    required this.uid,
    required this.name,
    required this.pfpURL,
  });

  //helper function which allows to take in json and return representation of the userprofile
  UserProfile.fromJson(Map<String, dynamic> json) {
    uid = json['uid'];
    name = json['name'];
    pfpURL = json['pfpURL'];
  }

  //turn the user profile into json
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['pfpURL'] = pfpURL;
    data['uid'] = uid;
    return data;
  }
}