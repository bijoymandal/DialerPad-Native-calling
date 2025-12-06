import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:crafts/core/storage/secure_storage.dart';

class ApiService {
  static const String baseUrl = "https://24-krafts-backend.vercel.app/api/";

  // -----------------------------
  // Send OTP
  // -----------------------------
  static Future<Map<String, dynamic>> sendOtp({required String number}) async {
    final url = Uri.parse("${baseUrl}auth/send-otp");

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"phone": number}),
    );

    return jsonDecode(response.body);
  }

  // -----------------------------
  // Verify OTP
  // -----------------------------
  static Future<Map<String, dynamic>> verifyOtp({
    required String number,
    required String otp,
  }) async {
    final url = Uri.parse("${baseUrl}auth/verify-otp");

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"phone": number, "otp": otp}),
    );

    return jsonDecode(response.body);
  }

  // -----------------------------
  // Complete Signup (Multipart)
  // -----------------------------
  static Future<Map<String, dynamic>> completeSignup({
    required String phone,
    required String? otp,
    required String firstName,
    required String lastName,
    required String email,
    String? alternativePhone,
    String? maaAssociativeNumber,
    required String gender,
    required String department,
    required String indiaState,
    required String city,
    required String companyName,
    String? companyPhone,
    String? companyAddress,
    String? website,
    String? facebook,
    String? instagram,
    String? linkedIn,
    String? role,
    File? companyLogo,
    List<File>? galleryImages,
  }) async {
    try {
      final url = Uri.parse("${baseUrl}auth/signup");
      // print("object",url);

      var request = http.MultipartRequest("POST", url);
      request.headers.addAll({"Content-Type": "multipart/form-data"});

      // Add text fields
      // request.fields["phone"] = phone;
      // request.fields["otp"] = otp;
      // request.fields["firstName"] = firstName;
      // request.fields["lastName"] = lastName;
      // request.fields["email"] = email;
      // request.fields["gender"] = gender;
      // request.fields["department"] = department;
      // request.fields["city"] = city;
      // request.fields["companyName"] = companyName;

      request.fields.addAll({
        "phone": phone,
        "otp": otp ?? "",
        "firstName": firstName,
        "lastName": lastName,
        "email": email,
        "gender": gender,
        "department": department,
        "state": indiaState,
        "city": city,
        "companyName": companyName,
        "role": "user",
      });

      // Optional fields
      if (alternativePhone?.isNotEmpty ?? false) {
        request.fields["alternativePhone"] = alternativePhone!;
      }
      if (maaAssociativeNumber?.isNotEmpty ?? false) {
        request.fields["maaAssociativeNumber"] = maaAssociativeNumber!;
      }
      if (companyPhone?.isNotEmpty ?? false) {
        request.fields["companyPhone"] = companyPhone!;
      }
      if (companyAddress?.isNotEmpty ?? false) {
        request.fields["companyAddress"] = companyAddress!;
      }
      if (website?.isNotEmpty ?? false) request.fields["website"] = website!;
      if (facebook?.isNotEmpty ?? false) request.fields["facebook"] = facebook!;
      if (instagram?.isNotEmpty ?? false) {
        request.fields["instagram"] = instagram!;
      }
      if (linkedIn?.isNotEmpty ?? false) request.fields["linkedIn"] = linkedIn!;

      // Files
      if (companyLogo != null) {
        request.files.add(
          await http.MultipartFile.fromPath("companyLogo", companyLogo.path),
        );
      }
      if (galleryImages != null && galleryImages.isNotEmpty) {
        for (var img in galleryImages) {
          request.files.add(
            await http.MultipartFile.fromPath("galleryImages", img.path),
          );
        }
      }

      print("Uploading Profile ...");
      final streamResponse = await request.send();
      // final response = await http.Response.fromStream(streamResponse);
      final response = await http.Response.fromStream(streamResponse);
      // final Map<String, dynamic> data = jsonDecode(response.body);
      // return jsonDecode(response.body);
      final body = response.body;
      dynamic jsonResponse;
      try {
        jsonResponse = jsonDecode(body);
      } catch (e) {
        return {"success": false, "message": "Invalid JSON from server"};
      }

      // If message is a List (error), convert to string
      if (jsonResponse is Map<String, dynamic>) {
        if (jsonResponse["message"] is List) {
          return {
            "success": false,
            "message": (jsonResponse["message"] as List).join(", "),
            "statusCode": response.statusCode,
          };
        }
        return jsonResponse;
      }

      return {"success": false, "message": "Unknown error"};
    } catch (e) {
      print("Signup Error: $e");
      return {"success": false, "message": "Network error"};
    }
  }

  // ----------------------------
  // User Profile show
  // ----------------------------

  static Future<Map<String, dynamic>> getProfile() async {
    final token = await SecureStorage.getToken();
    if (token == null) {
      throw Exception("No token found. Please login Again");
    }
    final response = await http.get(
      Uri.parse('$baseUrl/auth/profile'),
      headers: {
        'Authorization': "Bearer $token",
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else if (response.statusCode == 401) {
      await SecureStorage.clearAll();
      throw Exception("Session Expired. Please Login");
    } else {
      throw Exception("Failed to load profile");
    }
  }

  //profile update
}
