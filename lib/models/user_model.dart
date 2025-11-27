// lib/models/user_model.dart
class UserModel {
  final String name;
  final String email;
  final String phone;
  final String aadharLast4;
  final String alternatePhone;
  final String maaAssociation;
  final String gender;
  final String department;
  final String companyName;
  final String companyEmail;
  final String companyPhone;
  final String address;
  final bool isKycVerified;
  final String avatarUrl;

  UserModel({
    required this.name,
    required this.email,
    required this.phone,
    required this.aadharLast4,
    required this.alternatePhone,
    required this.maaAssociation,
    required this.gender,
    required this.department,
    required this.companyName,
    required this.companyEmail,
    required this.companyPhone,
    required this.address,
    required this.isKycVerified,
    required this.avatarUrl,
  });

  // Dummy data (replace with real API later)
  static UserModel dummy = UserModel(
    name: "Pavan Vijay Kumar",
    email: "p1dntne@gmail.com",
    phone: "+91 8297808410",
    aadharLast4: "8765",
    alternatePhone: "8887779990",
    maaAssociation: "MAA2314",
    gender: "Male",
    department: "Director, Producer",
    companyName: "NighaTech",
    companyEmail: "NighaTechs@gmail.com",
    companyPhone: "3399887721",
    address: "123, MG Road, Sector 15, Gurugram, Haryana - 122001",
    isKycVerified: true,
    avatarUrl: "https://randomuser.me/api/portraits/men/86.jpg",
  );
}
