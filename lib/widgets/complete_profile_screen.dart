import 'package:crafts/core/network/api_service.dart';
import 'package:crafts/core/utils/app_notifications.dart';
import 'package:crafts/models/user_model.dart';
import 'package:crafts/screens/aadhaar_verification_screen.dart';
import 'package:crafts/screens/welcome_back_screen.dart';
import 'package:crafts/widgets/reusable_logo_uploader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../logic/cubit/profile/profile_cubit.dart';
import 'dart:io';
import '../widgets/input/app_input.dart';
import '../widgets/input/app_dropdown.dart';
import '../widgets/input/social_input.dart';
import '../widgets/input/gender_selector.dart';
import 'package:image_picker/image_picker.dart';

class CompleteProfileScreen extends StatefulWidget {
  final String phoneNumber;
  final String? otp;
  final UserModel? existingUser;
  const CompleteProfileScreen({
    super.key,
    required this.phoneNumber,
    required this.otp,
    this.existingUser,
  });

  @override
  State<CompleteProfileScreen> createState() => _CompleteProfileScreenState();
}

class ProfileFormControllers {
  //personal info
  final firstName = TextEditingController();
  final lastName = TextEditingController();
  final email = TextEditingController();
  final alternetPhone = TextEditingController();
  final massAssociation = TextEditingController();
  final gender = TextEditingController();
  final department = TextEditingController();

  //company info
  final companyName = TextEditingController();
  final companyAddress = TextEditingController();
  final compPhone = TextEditingController();
  final compLogo = TextEditingController();
  final city = TextEditingController();
  final website = TextEditingController();

  //social Media
  final facebook = TextEditingController();
  final instragram = TextEditingController();
  final linkedIn = TextEditingController();

  //Dispose all at once
  void dispose() {
    firstName.dispose();
    lastName.dispose();
    email.dispose();
    alternetPhone.dispose();
    massAssociation.dispose();
    gender.dispose();
    department.dispose();

    companyName.dispose();
    companyAddress.dispose();
    compPhone.dispose();
    city.dispose();
    website.dispose();
    facebook.dispose();
    instragram.dispose();
    linkedIn.dispose();
  }

  Map<String, String> get values => {
    'firstName': firstName.text.trim(),
    'lastName': lastName.text.trim(),
    'email': email.text.trim(),
    'alternetPhone': alternetPhone.text.trim(),
    'massAssociation': massAssociation.text.trim(),
    'gender': gender.text.trim(),
    'department': department.text.trim(),
    'companyName': companyName.text.trim(),
    'companyAddress': companyAddress.text.trim(),
    'compPhone': compPhone.text.trim(),
    'city': city.text.trim(),
    'website': website.text.trim(),
    'facebook': facebook.text.trim(),
    'instragram': instragram.text.trim(),
    'linkedIn': linkedIn.text.trim(),
  };
  void clearAll() {
    firstName.clear();
    lastName.clear();
    email.clear();
    alternetPhone.clear();
    massAssociation.clear();
    gender.clear();
    department.clear();
    companyName.clear();
    companyAddress.clear();
    compPhone.clear();
    city.clear();
    website.clear();
    facebook.clear();
    instragram.clear();
    linkedIn.clear();
  }
}

class _CompleteProfileScreenState extends State<CompleteProfileScreen> {
  late final ProfileFormControllers form;

  // Dropdown values (not in controllers)
  String gender = "Male";
  String department = "Others";
  String indiaState = "Delhi";

  final List<File> galleryImages = <File>[];
  File? companyLogo;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    form = ProfileFormControllers();
    // Pre-fill form if editing existing profile
    if (widget.existingUser != null) {
      final user = widget.existingUser!;

      form.firstName.text = user.firstName ?? '';
      form.lastName.text = user.lastName ?? '';
      form.email.text = user.email ?? '';
      form.alternetPhone.text = user.alternatePhone ?? '';
      form.massAssociation.text = user.maaAssociation ?? '';
      form.companyName.text = user.companyName ?? '';
      form.companyAddress.text = user.companyAddress ?? '';
      form.compPhone.text = user.companyPhone ?? '';
      form.city.text = user.city ?? '';
      form.website.text = user.website ?? '';
      form.facebook.text = user.facebook ?? '';
      form.instragram.text = user.instagram ?? '';
      form.linkedIn.text = user.linkedIn ?? '';

      // ✔ FIXED: correct assignment
      gender = user.gender ?? "Male";
      department = user.department ?? "Others";
      indiaState = user.indiaState ?? "Delhi";
    }
  }

  @override
  void dispose() {
    form.dispose();
    super.dispose();
  }

  Future pickImage() async {
    final ImagePicker picker = ImagePicker();

    // setState(() {
    //   galleryImages.add("sample.jpg");
    // });
    final XFile? file = await picker.pickImage(source: ImageSource.gallery);

    if (file != null) {
      setState(() {
        galleryImages.add(File(file.path)); // store actual path
      });
    }
  }

  bool _validate() {
    if (form.firstName.text.isEmpty) return _error("First Name is required");
    if (form.lastName.text.isEmpty) return _error("Last Name is required");

    final email = form.email.text.trim();
    if (!RegExp(r'^[\w.%+-]+@[\w.-]+\.[a-zA-Z]{2,}$').hasMatch(email)) {
      return _error("Enter valid email");
    }

    if (form.companyName.text.isEmpty)
      return _error("Company Name is required");
    if (form.companyAddress.text.isEmpty)
      return _error("Company Address is required");
    if (form.city.text.isEmpty) return _error("City/Town is required");

    return true;
  }

  bool _error(String msg) {
    AppNotifications.showError(context, msg);
    return false;
  }

  Future<void> _submitProfile() async {
    if (!_validate()) return;
    setState(() {
      _isSubmitting = true;
    });
    try {
      final state = context.read<ProfileCubit>().state;

      final response = await ApiService.completeSignup(
        phone: widget.phoneNumber,
        otp: widget.existingUser != null ? null : widget.otp,
        firstName: form.firstName.text.trim(),
        lastName: form.lastName.text.trim(),
        email: form.email.text.trim(),
        alternativePhone: form.alternetPhone.text.trim().isEmpty
            ? null
            : form.alternetPhone.text.trim(),
        maaAssociativeNumber: form.massAssociation.text.trim().isEmpty
            ? null
            : form.massAssociation.text.trim(),
        gender: state.gender ?? "Male",
        department: state.department ?? "Others",
        indiaState: state.indiaState ?? "Delhi",
        city: form.city.text.trim(),
        companyName: form.companyName.text.trim(),
        companyPhone: form.compPhone.text.trim().isEmpty
            ? null
            : form.compPhone.text.trim(),
        companyAddress: form.companyAddress.text.trim(),
        website: form.website.text.trim().isEmpty
            ? null
            : form.website.text.trim(),
        facebook: form.facebook.text.trim().isEmpty
            ? null
            : form.facebook.text.trim(),
        instagram: form.instragram.text.trim().isEmpty
            ? null
            : form.instragram.text.trim(),
        linkedIn: form.linkedIn.text.trim().isEmpty
            ? null
            : form.linkedIn.text.trim(),
        companyLogo: companyLogo,
        galleryImages: galleryImages.isEmpty ? null : galleryImages,

        // 🔥 REQUIRED FIELDS BELOW
        role: "user",
        // aadharNumber: "1234567812345678",
      );

      print(" api object,$response");
      if (response["success"] == true) {
        AppNotifications.showSuccess(
          context,
          widget.existingUser != null
              ? "Profile Updated Successly "
              : "Profile Complete successfully!",
        );
        if (mounted) Navigator.pop(context);
      } else {
        AppNotifications.showError(
          context,
          response["message"] ?? "SignUp failed",
        );
      }
    } catch (error) {
      print("Error:$error");
      AppNotifications.showError(context, "Please Try Again");
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditMode = widget.existingUser != null;
    return BlocProvider(
      create: (_) => ProfileCubit(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(isEditMode ? "Edit Profile" : "Complete Profile"),
          centerTitle: true,
        ),

        body: BlocBuilder<ProfileCubit, ProfileState>(
          builder: (context, state) {
            final cubit = context.read<ProfileCubit>();

            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Personal Information",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),

                  AppInput(
                    label: "First Name *",
                    hint: "Enter your first name",
                    controller: form.firstName,
                  ),
                  const SizedBox(height: 20),
                  AppInput(
                    label: "Last Name *",
                    hint: "Enter your last name",
                    controller: form.lastName,
                  ),
                  const SizedBox(height: 20),

                  AppInput(
                    label: "Email ID *",
                    hint: "your@email.com",
                    controller: form.email,
                  ),
                  const SizedBox(height: 20),

                  AppInput(
                    label: "Phone Number *(verified)",
                    hint: "+1 (123) 456-7890",
                    controller: TextEditingController(
                      text: "+91 ${widget.phoneNumber}",
                    ),
                    enabled: false,
                    readOnly: true,
                    keyboardType: TextInputType.none,
                  ),
                  const SizedBox(height: 20),

                  AppInput(
                    label: "Alternate Phone",
                    hint: "+1 (123) 456-7890",
                    controller: form.alternetPhone,
                  ),
                  const SizedBox(height: 20),

                  AppInput(
                    label: "MAA Association",
                    hint: "Enter association name",
                    controller: form.massAssociation,
                  ),
                  const SizedBox(height: 20),

                  // 🎉 Reusable Gender Component
                  GenderSelector(
                    selected: state.gender,
                    onChanged: (v) {
                      context.read<ProfileCubit>().setGender(v!);
                    },
                  ),
                  const SizedBox(height: 20),

                  AppDropdown(
                    label: "Department *",
                    hint: "Select Department",
                    value: state.department,
                    items: ["IT", "HR", "Finance", "Admin", "Marketing"],
                    onChanged: (v) {
                      context.read<ProfileCubit>().setDepartment(v!);
                    },
                  ),

                  const SizedBox(height: 30),
                  const Text(
                    "Company Information",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 15),
                  AppInput(
                    label: "Company Name *",
                    hint: "Enter company name",
                    controller: form.companyName,
                  ),
                  const SizedBox(height: 20),
                  AppInput(
                    label: "Company Address *",
                    hint: "Enter company address",
                    controller: form.companyAddress,
                  ),
                  const SizedBox(height: 20),
                  AppInput(
                    label: "Company Phone",
                    hint: "+1 (123) 456-7890",
                    controller: form.compPhone,
                  ),
                  const SizedBox(height: 20),
                  ReusableLogoUploader(
                    title: "Company Logo",
                    hintText: "Tap to upload logo",
                    width: 380,
                    height: 150,
                    onPicked: (file) {
                      if (file != null) {
                        setState(() => companyLogo = File(file.path));
                      }
                    },
                  ),
                  const SizedBox(height: 20),
                  AppDropdown(
                    label: "State *",
                    hint: "Select State",
                    value: state.indiaState,
                    items: ["Kolkata", "Delhi", "Goa"],
                    onChanged: (v) {
                      context.read<ProfileCubit>().setIndiaState(v!);
                    },
                  ),
                  const SizedBox(height: 20),
                  AppInput(
                    label: "City/Town *",
                    hint: "Enter city or town",
                    controller: form.city,
                  ),
                  const SizedBox(height: 30),
                  const Text(
                    "Media & Links",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "Gallery Images",
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: [
                      // show uploaded images
                      ...galleryImages.asMap().entries.map((entry) {
                        final index = entry.key;
                        // final path = entry.value;

                        return Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.file(
                                entry.value,
                                width: 100,
                                height: 100,
                                fit: BoxFit.cover,
                              ),
                            ),

                            // ❌ DELETE BUTTON ON TOP-RIGHT
                            Positioned(
                              right: 4,
                              top: 4,
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    galleryImages.removeAt(index);
                                  });
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(3),
                                  decoration: const BoxDecoration(
                                    color: Colors.red,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.close,
                                    color: Colors.white,
                                    size: 16,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      }),

                      // ➕ ADD NEW IMAGE BOX
                      GestureDetector(
                        onTap: pickImage,
                        child: Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.grey),
                          ),
                          child: const Icon(Icons.add, size: 28),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 40),
                  AppInput(
                    label: "Website",
                    hint: "https://yourwebsite.com",
                    controller: form.website,
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Social Media Information",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 15),

                  SocialInput(
                    icon: Icons.facebook,
                    label: "Facebook URL",
                    controller: form.facebook,
                  ),
                  const SizedBox(height: 12),

                  SocialInput(
                    icon: Icons.camera_alt,
                    label: "Instagram URL",
                    controller: form.instragram,
                  ),
                  const SizedBox(height: 12),

                  SocialInput(
                    icon: Icons.link,
                    label: "LinkedIn URL",
                    controller: form.linkedIn,
                  ),
                  const SizedBox(height: 30),

                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            AppNotifications.showSuccess(
                              context,
                              "Profile saved draft!",
                            );
                            // ScaffoldMessenger.of(context).showSnackBar(

                            //   const SnackBar(
                            //     content: Text("Profile saved as draft!"),
                            //     backgroundColor: Colors.green,
                            //     duration: Duration(seconds: 2),
                            //   ),
                            // );
                            Navigator.pop(context);
                          },
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            side: BorderSide(color: Colors.grey.shade600),
                          ),
                          child: const Text("Save Draft"),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed:
                              //if (_validate()) {
                              // debugPrint("Form Data,${form.values}");
                              // Navigator.push(
                              //   context,
                              //   MaterialPageRoute(
                              //     builder: (_) => AadhaarVerificationScreen(
                              //       phoneNumber: widget.phoneNumber,
                              //     ),
                              //   ),
                              // );
                              //}
                              _isSubmitting ? null : _submitProfile,

                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            backgroundColor: Colors.purple,
                          ),
                          child: _isSubmitting
                              ? const SizedBox(
                                  height: 24,
                                  width: 24,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2.5,
                                  ),
                                )
                              : Text(
                                  isEditMode ? "Update Profile" : "Continue",
                                  style: TextStyle(
                                    color: Colors.white, // ✅ FIXED
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  Center(
                    child: SizedBox(
                      width: 180,
                      child: OutlinedButton(
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => WelcomeBackScreen(),
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          backgroundColor: Colors.red, // 🔴 Red background
                          side: BorderSide.none, // Remove border
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              40,
                            ), // 🔥 OVAL / PILL SHAPE
                          ),
                        ),
                        child: const Text(
                          "Logout",
                          style: TextStyle(
                            color: Colors.white, // ⚪ White text
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
