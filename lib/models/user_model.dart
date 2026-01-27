// models/user_model.dart

class UserModel {
  final String id;
  final String phone;
  final String email;
  final String firstName;
  final String lastName;
  final String? alternatePhone;
  final String? maaAssociation;
  final String? companyName;
  final String? companyAddress;
  final String? companyPhone;
  final String? city;
  final String? website;
  final String? facebook;
  final String? instagram;
  final String? linkedIn;
  final String profilePhotoUrl;
  final String role;
  final bool isPremium;
  final String? gender;
  final String? department;
  final String? indiaState;
  final List<SocialLink> socialLinks;

  UserModel({
    required this.id,
    required this.phone,
    required this.email,
    required this.firstName,
    required this.lastName,
    this.alternatePhone,
    this.maaAssociation,
    this.companyName,
    this.companyAddress,
    this.companyPhone,
    this.city,
    this.website,
    this.facebook,
    this.instagram,
    this.linkedIn,
    required this.profilePhotoUrl,
    required this.role,
    required this.isPremium,
    this.gender,
    this.department,
    this.indiaState,
    required this.socialLinks,
  });

  factory UserModel.fromAuthResponse(Map<String, dynamic> json) {
    final user = json["user"];
    final profile = json["profile"];
    print(profile);

    final List<dynamic> linksJson = json['socialLinks'] ?? [];
    return UserModel(
      id: user["id"],
      phone: "+91 ${user["phone"] ?? ""}",
      email: user["email"] ?? "",
      role: profile["role"] ?? "",
      firstName: user["firstName"] ?? profile["first_name"] ?? "User",
      lastName: user["lastName"] ?? profile["last_name"] ?? "",
      alternatePhone: user["alternatePhone"] ?? "",
      maaAssociation: user["maaAssociation"] ?? "",
      companyName: user["companyName"] ?? "",
      companyAddress: user["companyAddress"] ?? "",
      companyPhone: user["companyPhone"] ?? "",
      profilePhotoUrl: profile["profile_photo_url"] ?? "",
      isPremium: profile["is_premium"] == true,
      socialLinks: linksJson.map((e) => SocialLink.fromJson(e)).toList(),
    );
  }

  // Optional: fromJson for local storage
  // factory UserModel.fromJson(Map<String, dynamic> json) {
  //   return UserModel(
  //     id: json["id"],
  //     phone: json["phone"],
  //     email: json["email"],
  //     role: json["role"],
  //     firstName: json["firstName"],
  //     lastName: json["lastName"],

  //     profilePhotoUrl: json["profilePhotoUrl"] ?? "",
  //     isPremium: json["isPremium"],
  //     socialLinks: linksJson.map((e) => SocialLink.fromJson(e)).toList(),
  //   );
  // }

  Map<String, dynamic> toJson() => {
    "id": id,
    "phone": phone,
    "email": email,
    "role": role,
    "firstName": firstName,
    "lastName": lastName,
    "alternatePhone": alternatePhone,
    "maaAssociation": maaAssociation,

    "profilePhotoUrl": profilePhotoUrl,
    "isPremium": isPremium,
  };
}

class SocialLink {
  final String platform;
  final String url;
  final bool isCustom;

  SocialLink({
    required this.platform,
    required this.url,
    required this.isCustom,
  });

  factory SocialLink.fromJson(Map<String, dynamic> json) {
    return SocialLink(
      platform: json['platform']?.toString() ?? '',
      url: json['url']?.toString() ?? '',
      isCustom: json['is_custom'] == true,
    );
  }
}
