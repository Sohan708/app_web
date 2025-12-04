import 'dart:convert';
import 'dart:typed_data';

import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:app_web/models/subcategory.dart';
import 'package:http/http.dart' as http;
import 'package:app_web/global_variables.dart';
import 'package:app_web/services/manage_http_response.dart';

class SubCategoryController {
  uploadSubCategory({
    required String categoryId,
    required String categoryName,
    required dynamic pickedImage,
    required String subCategoryName,
    required context,
  }) async {
    try {
      final cloudinary = CloudinaryPublic('dwnh4damu', 'ilvkxzjw');

      // Convert Uint8List to ByteData
      ByteData imageByteData = ByteData.sublistView(pickedImage);
      CloudinaryResponse imageResponse = await cloudinary.uploadFile(
        CloudinaryFile.fromByteData(
          imageByteData,
          identifier: 'pickedImage',
          folder: 'categoryImages',
        ),
      );
      String image = imageResponse.secureUrl;
      SubCategory subCategory = SubCategory(
        id: '',
        categoryId: categoryId,
        categoryName: categoryName,
        image: image,
        subCategoryName: subCategoryName,
      );
      http.Response response = await http.post(
        Uri.parse("$uri/api/subcategories"),
        body: subCategory.toJson(),
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8",
        },
      );
      manageHttpResponse(
        response: response,
        context: context,
        onSuccess: () {
          showSnackbar(context: context, title: "uploaded SubCategory");
        },
      );
    } catch (e) {
      print("$e");
    }
  }

  //load the uploaded categories
  Future<List<SubCategory>> loadSubCategories() async {
    try {
      http.Response response = await http.get(
        Uri.parse("$uri/api/subcategories"),
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8",
        },
      );
      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        List<SubCategory> subcategories = data
            .map((subcategory) => SubCategory.fromJson(subcategory))
            .toList();
        return subcategories;
      } else {
        throw Exception("Failed to fetch subcategories");
      }
    } catch (e) {
      throw Exception("Error loading subcategories: $e");
    }
  }
}
