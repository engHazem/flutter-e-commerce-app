// ignore_for_file: use_build_context_synchronously, duplicate_ignore

import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test_project/constants/app_colors.dart';
import 'package:flutter_test_project/layout/main_layout.dart';
import 'package:flutter_test_project/services/firestore_%20services.dart';
import 'package:flutter_test_project/utilits/helper.dart';
import 'package:flutter_test_project/widgets/custom_button.dart';
import 'package:flutter_test_project/widgets/custom_category.dart';
import 'package:flutter_test_project/widgets/custom_gap.dart';
import 'package:flutter_test_project/widgets/custom_inputtext.dart';
import 'package:flutter_test_project/widgets/custom_loading.dart';
import 'package:image_picker/image_picker.dart';

class AddproductPage extends StatefulWidget {
  const AddproductPage({super.key});

  @override
  State<AddproductPage> createState() => _AddproductPageState();
}

class _AddproductPageState extends State<AddproductPage> {
  String _category = "";
  String api = "30b3dbd0a1d5ebbb00bb0be489129544";
  File? _image;
  String? _uploadedImageUrl = '';
  bool _isUploadingImage = false;
  bool _isloading = false;

  TextEditingController namecontroller = TextEditingController();
  TextEditingController pricecontroller = TextEditingController();
  TextEditingController descriptioncontroller = TextEditingController();
  late final List<TextEditingController> _controllers;

  @override
  void initState() {
    super.initState();
    _controllers = [namecontroller, pricecontroller, descriptioncontroller];
  }

  final GlobalObjectKey<FormState> _formKey = GlobalObjectKey<FormState>(
    "addProductForm",
  );

  Future<void> _pickImage() async {
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
          showStatusSnackBar(
            // ignore: use_build_context_synchronously
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

  Future<void> _addProduct() async {
    if (_isUploadingImage) {
      showStatusSnackBar(
        context: context,
        isSuccess: false,
        message: "يُرجى انتظار رفع الصورة أولاً",
      );
      return;
    }

    if (!_formKey.currentState!.validate()) {
      showStatusSnackBar(
        context: context,
        isSuccess: false,
        message: "من فضلك تأكد من صحة البيانات المدخلة",
      );
      return;
    }

    if (_category.isEmpty) {
      showStatusSnackBar(
        context: context,
        isSuccess: false,
        message: "من فضلك اختر فئة المنتج",
      );
      return;
    }

    if (_uploadedImageUrl == null || _uploadedImageUrl!.isEmpty) {
      showStatusSnackBar(
        context: context,
        isSuccess: false,
        message: "من فضلك قم برفع صورة للمنتج",
      );
      return;
    }

    setState(() {
      _isloading = true;
    });

    try {
      await Firestore().saveProductDataToFirestore(
        name: namecontroller.text.trim(),
        price: double.parse(pricecontroller.text.trim()).toString(),
        description: descriptioncontroller.text.trim(),
        category: _category,
        imageUrl: _uploadedImageUrl!,
      );
      clearAllControllers(controllers: _controllers);
      _formKey.currentState!.reset();
      showStatusSnackBar(
        context: context,
        isSuccess: true,
        message: "تم إضافة المنتج بنجاح",
      );
      Future.delayed(const Duration(seconds: 1), () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => MainLayout()),
        );
      });
    } catch (e) {
      showStatusSnackBar(
        context: context,
        isSuccess: false,
        message: "حدث خطأ أثناء إضافة المنتج",
      );
    } finally {
      setState(() {
        _isloading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              CustomTextFormField(
                controller: namecontroller,
                labelText: "Product Name",
                prefixIcon: Icon(
                  Icons.shopping_cart,
                  color: AppColors.textColor,
                ),
                validator: (value) {
                  if (value!.trim().isEmpty) return 'من فضلك أدخل اسم المنتج';
                  if (value.length < 3) {
                    return 'اسم المنتج يجب أن يكون أكثر من 3 أحرف';
                  }
                  return null;
                },
              ),
              Gap(height: 20),
              CustomTextFormField(
                controller: pricecontroller,
                labelText: "Product Price",
                prefixIcon: Icon(
                  Icons.attach_money,
                  color: AppColors.textColor,
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value!.trim().isEmpty) return 'من فضلك أدخل سعر المنتج';
                  if (double.tryParse(value) == null) return 'ادخل سعر صحيح';
                  return null;
                },
              ),
              Gap(height: 10),
              CustomTextFormField(
                controller: descriptioncontroller,
                labelText: "Product Description",
                prefixIcon: Icon(Icons.description, color: AppColors.textColor),
                maxLines: 5,
                validator: (value) {
                  if (value!.trim().isEmpty) return 'من فضلك أدخل وصف المنتج';
                  if (value.length < 10) {
                    return 'وصف المنتج يجب أن يكون أكثر من 10 أحرف';
                  }
                  return null;
                },
              ),
              Gap(height: 10),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  spacing: 5,
                  children: [
                    Text(
                      "Category :",
                      style: TextStyle(
                        color: AppColors.textColor,
                        fontSize: 16,
                      ),
                    ),
                    CategoryChipsRow(
                      spacing: 10,
                      categories: ["Electronics", "Books", "Fashion"],
                      selectedCategory: _category,
                      onCategorySelected: (category) {
                        setState(() {
                          _category = category;
                        });
                      },
                    ),
                  ],
                ),
              ),
              Gap(height: 10),
              DottedBorder(
                options: RectDottedBorderOptions(
                  color: AppColors.buttonColor,
                  strokeWidth: 1,
                  dashPattern: [5, 5],
                ),
                child: Container(
                  height: 175,
                  width: double.infinity,
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Upload Image",
                        style: TextStyle(
                          color: AppColors.textColor,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Gap(height: 10),
                      Text(
                        "Tap to upload product image",
                        style: TextStyle(
                          color: AppColors.textColor,
                          fontSize: 16,
                        ),
                      ),
                      Gap(height: 10),
                      _isUploadingImage
                          ? CustomLoading(height: 30.0, width: 30.0)
                          : CustomElevatedButton(
                              icon: _uploadedImageUrl == ''
                                  ? Icon(
                                      Icons.add_photo_alternate_outlined,
                                      color: AppColors.textColor,
                                    )
                                  : Icon(
                                      Icons.check_circle_outline,
                                      color: AppColors.textColor,
                                    ),
                              text: "Upload",
                              onPressed: _pickImage,
                              height: 35,
                              width: 130,
                              borderredius: 40,
                            ),
                    ],
                  ),
                ),
              ),
              Gap(height: 40),
              CustomElevatedButton(
                icon: (_isUploadingImage || _isloading)
                    ? null
                    : Icon(Icons.add, color: AppColors.textColor),
                text: (_isUploadingImage || _isloading) ? "" : "Add Product",
                onPressed: (_isUploadingImage || _isloading)
                    ? null
                    : _addProduct,
                width: 200,
                borderredius: 20,
                height: 40,
                isloading: _isloading,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
