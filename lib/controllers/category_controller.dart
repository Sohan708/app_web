import 'dart:convert';
import 'dart:typed_data';
import 'package:app_web/global_variables.dart';
import 'package:app_web/models/category.dart';
import 'package:app_web/services/manage_http_response.dart';
import 'package:http/http.dart' as http;
import 'package:cloudinary_public/cloudinary_public.dart';

class CategoryController {
  uploadCategory({
    required dynamic pickedImage,
    required dynamic pickedBanner,
    required String name,
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

      // Convert Uint8List to ByteData
      ByteData bannerByteData = ByteData.sublistView(pickedBanner);
      CloudinaryResponse bannerResponse = await cloudinary.uploadFile(
        CloudinaryFile.fromByteData(
          bannerByteData,
          identifier: 'pickedBanner',
          folder: 'categoryBanners',
        ),
      );
      String banner = bannerResponse.secureUrl;

      Category category = Category(
        id: '',
        name: name,
        image: image,
        banner: banner,
      );
      http.Response response = await http.post(
        Uri.parse("$uri/api/categories"),
        body: category.toJson(),
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8",
        },
      );
      manageHttpResponse(
        response: response,
        context: context,
        onSuccess: () {
          showSnackbar(context: context, title: "uploaded Category");
        },
      );
    } catch (e) {
      print("Error uplading to cloudinary: $e");
    }
  }

  //load the uploaded categories
  Future<List<Category>> loadCategories() async {
    try {
      http.Response response = await http.get(
        Uri.parse("$uri/api/categories"),
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8",
        },
      );
      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        List<Category> categories = data
            .map((category) => Category.fromJson(category))
            .toList();
        return categories;
      } else {
        throw Exception("Failed to fetch categories");
      }
    } catch (e) {
      throw Exception("Error loading categories: $e");
    }
  }
}
