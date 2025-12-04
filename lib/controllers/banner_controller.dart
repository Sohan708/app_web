import 'dart:convert';
import 'dart:typed_data';
import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:app_web/models/banner.dart';
import 'package:app_web/services/manage_http_response.dart';
import 'package:http/http.dart' as http;
import 'package:app_web/global_variables.dart';

class BannerController {
  uploadBanner({required dynamic pickedImage, required context}) async {
    try {
      final cloudinary = CloudinaryPublic('dwnh4damu', 'ilvkxzjw');

      // Convert Uint8List to ByteData
      ByteData imageByteData = ByteData.sublistView(pickedImage);
      CloudinaryResponse imageResponse = await cloudinary.uploadFile(
        CloudinaryFile.fromByteData(
          imageByteData,
          identifier: 'pickedImage',
          folder: 'banners',
        ),
      );
      String image = imageResponse.secureUrl;
      BannerModel bannerModel = BannerModel(id: '', image: image);
      http.Response response = await http.post(
        Uri.parse("$uri/api/banner"),
        body: bannerModel.toJson(),
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8",
        },
      );
      manageHttpResponse(
        response: response,
        context: context,
        onSuccess: () {
          showSnackbar(context: context, title: "Banner uploaded");
        },
      );
    } catch (e) {
      print("Error uplading to cloudinary: $e");
    }
  }

  //fetch banner
  Future<List<BannerModel>> loadBanners() async {
    try {
      //fetch banners from api
      http.Response response = await http.get(
        Uri.parse("$uri/api/banner"),
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8",
        },
      );
      print(response.body);
      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        List<BannerModel> banners = data
            .map((banner) => BannerModel.fromJson(banner))
            .toList();
        return banners;
      } else {
        //throw an exception if the sever response is not 200
        throw Exception("Failed to fetch banners");
      }
    } catch (e) {
      throw Exception("Error loading banners: $e");
    }
  }
}
