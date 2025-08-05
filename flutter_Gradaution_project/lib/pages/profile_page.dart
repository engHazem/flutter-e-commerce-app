// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test_project/constants/app_colors.dart';
import 'package:flutter_test_project/services/authentication_%20services.dart';
import 'package:flutter_test_project/utilits/helper.dart';
import 'package:flutter_test_project/widgets/custom_gap.dart';
import 'package:flutter_test_project/widgets/custom_inputtext.dart';
import 'package:flutter_test_project/widgets/custom_loading.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final TextEditingController _nameController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isEditing = false;
  bool isSaving = false;
  File? _image;
  User? user;
  bool _isUploadingImage = false;
  String api = "30b3dbd0a1d5ebbb00bb0be489129544";
  String? _uploadedImageUrl = "";
  @override
  void initState() {
    super.initState();
    user = Authentication().getCurrentUserInfo();
    _nameController.text = user?.displayName ?? '';
  }

  Future<void> _updateName() async {
    String newName = _nameController.text.trim();
    if (newName.isEmpty) return;

    setState(() {
      isSaving = true;
    });

    try {
      if (_formKey.currentState!.validate()) {
        await user!.updateDisplayName(newName);
        await user!.reload();
        showStatusSnackBar(
          context: context,
          isSuccess: true,
          message: 'تم تحديث الاسم بنجاح',
        );
        setState(() {
          user = FirebaseAuth.instance.currentUser;
          isEditing = false;
        });
      } else {
        showStatusSnackBar(
          context: context,
          isSuccess: false,
          message: 'من فضلك أدخل اسم المستخدم بشكل صحيح',
        );
      }
    } catch (e) {
      showStatusSnackBar(
        context: context,
        isSuccess: false,
        message: 'حدث خطأ أثناء التحديث: $e',
      );
    } finally {
      setState(() {
        isSaving = false;
      });
    }
  }

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _isUploadingImage = true;
        _image = File(pickedFile.path);
      });

      try {
        _uploadedImageUrl = await uploadImageToImgbb(_image!, api);

        if (_uploadedImageUrl != null && _uploadedImageUrl!.isNotEmpty) {
          await user?.updatePhotoURL(_uploadedImageUrl);
          await user?.reload();
          setState(() {
            isEditing = false;
            user = Authentication().getCurrentUserInfo();
          });

          showStatusSnackBar(
            context: context,
            isSuccess: true,
            message: "تم رفع الصورة بنجاح",
          );
        } else {
          showStatusSnackBar(
            context: context,
            isSuccess: false,
            message: "فشل رفع الصورة",
          );
        }
      } catch (e) {
        showStatusSnackBar(
          context: context,
          isSuccess: false,
          message: "خطأ في رفع الصورة: $e",
        );
      } finally {
        setState(() {
          _isUploadingImage = false;
        });
      }
    } else {
      showStatusSnackBar(
        context: context,
        isSuccess: false,
        message: "لم يتم اختيار صورة",
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Gap(height: 20),
            Stack(
              clipBehavior: Clip.none,
              children: [
                _isUploadingImage
                    ? CircleAvatar(
                        radius: 60,
                        backgroundColor: AppColors.primaryColor,
                        child: CustomLoading(width: 30, height: 30),
                      )
                    : CircleAvatar(
                        radius: 60,
                        backgroundColor: Colors.transparent,
                        backgroundImage:
                            (user?.photoURL == null || user!.photoURL!.isEmpty)
                            ? const AssetImage('assets/images/default.webp')
                            : null,
                        child:
                            (user?.photoURL != null &&
                                user!.photoURL!.isNotEmpty)
                            ? ClipOval(
                                child: FadeInImage.assetNetwork(
                                  placeholder: 'assets/images/loading.png',
                                  image: user!.photoURL!,
                                  fit: BoxFit.cover,
                                  width: 140,
                                  height: 140,
                                  imageErrorBuilder:
                                      (context, error, stackTrace) {
                                        return Image.asset(
                                          'assets/images/default.webp',
                                          fit: BoxFit.cover,
                                          width: 140,
                                          height: 140,
                                        );
                                      },
                                ),
                              )
                            : null,
                      ),
                Positioned(
                  bottom: -5,
                  right: -10,
                  child: IconButton(
                    icon: Icon(
                      Icons.add_photo_alternate,
                      color: AppColors.textColor,
                    ),
                    onPressed: () {
                      pickImage();
                    },
                  ),
                ),
              ],
            ),
            Gap(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                isEditing
                    ? Form(
                        key: _formKey,
                        child: SizedBox(
                          width: 180,
                          child: CustomTextFormField(
                            horizontalPadding: 0.0,
                            verticalPadding: 0.0,
                            controller: _nameController,
                            labelText: 'Enter new name',
                            prefixIcon: Icon(
                              Icons.person,
                              color: AppColors.textColor,
                            ),
                            validator: (value) {
                              if (value!.trim().isEmpty) {
                                return 'من فضلك أدخل اسم المستخدم';
                              }
                              if (value.length < 3) {
                                return 'اسم المستخدم يجب أن يكون أكثر من 3 أحرف';
                              }
                              return null;
                            },
                          ),
                        ),
                      )
                    : Text(
                        user?.displayName ?? 'User Name',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textColor,
                        ),
                      ),
                Gap(width: 10),
                isSaving
                    ? SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: AppColors.textColor,
                        ),
                      )
                    : IconButton(
                        icon: Icon(
                          isEditing ? Icons.check : Icons.edit,
                          color: AppColors.textColor,
                        ),
                        onPressed: () {
                          if (isEditing) {
                            _updateName();
                          } else {
                            setState(() {
                              isEditing = true;
                            });
                          }
                        },
                      ),
              ],
            ),

            Gap(height: 10),
            Text(
              "Member since ${DateFormat('MMMM - yyyy').format(user!.metadata.creationTime!.toLocal())}",
              style: TextStyle(fontSize: 16, color: AppColors.textinputColor),
            ),
            Gap(height: 30),
            SizedBox(
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 15),
                    child: Text(
                      'Account',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textColor,
                      ),
                    ),
                  ),
                  Gap(height: 10),
                  ListTile(
                    title: Text(
                      'Edit Profile',
                      style: TextStyle(color: AppColors.textColor),
                    ),
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                      color: AppColors.textColor,
                    ),
                    onTap: () {},
                  ),
                  ListTile(
                    title: Text(
                      'Purchase History',
                      style: TextStyle(color: AppColors.textColor),
                    ),
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                      color: AppColors.textColor,
                    ),
                    onTap: () {},
                  ),
                  ListTile(
                    title: Text(
                      'Listed Items',
                      style: TextStyle(color: AppColors.textColor),
                    ),
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                      color: AppColors.textColor,
                    ),
                    onTap: () {},
                  ),
                ],
              ),
            ),
            Gap(height: 20),
            SizedBox(
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 15),
                    child: Text(
                      'Settings',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textColor,
                      ),
                    ),
                  ),
                  Gap(height: 10),
                  ListTile(
                    title: Text(
                      'Notifications',
                      style: TextStyle(color: AppColors.textColor),
                    ),
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                      color: AppColors.textColor,
                    ),
                    onTap: () {},
                  ),
                  ListTile(
                    title: Text(
                      'Payment Methods',
                      style: TextStyle(color: AppColors.textColor),
                    ),
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                      color: AppColors.textColor,
                    ),
                    onTap: () {},
                  ),
                  ListTile(
                    title: Text(
                      'Help & Support',
                      style: TextStyle(color: AppColors.textColor),
                    ),
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                      color: AppColors.textColor,
                    ),
                    onTap: () {},
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
