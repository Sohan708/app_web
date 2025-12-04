import 'package:app_web/controllers/category_controller.dart';
import 'package:app_web/view/side_bar_screens/widget/category_widget.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class CatagoryScreen extends StatefulWidget {
  static const String id = 'catagoryScreen';
  const CatagoryScreen({super.key});

  @override
  State<CatagoryScreen> createState() => _CatagoryScreenState();
}

class _CatagoryScreenState extends State<CatagoryScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final CategoryController _categoryController = CategoryController();
  late String name;
  dynamic _bannerImage;
  dynamic _image;
  pickImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false,
    );
    if (result != null) {
      setState(() {
        _image = result.files.first.bytes;
      });
    }
  }

  pickBannerImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false,
    );
    if (result != null) {
      setState(() {
        _bannerImage = result.files.first.bytes;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                alignment: Alignment.topLeft,
                child: Text(
                  "Catagories",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 36),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Divider(color: Colors.grey),
            ),
            Row(
              children: [
                Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: _image != null
                        ? Image.memory(_image)
                        : Text("Catagory Image"),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: 200,
                    child: TextFormField(
                      onChanged: (value) {
                        name = value;
                      },
                      validator: (value) {
                        if (value!.isNotEmpty) {
                          return null;
                        } else {
                          return "Please enter catagory name";
                        }
                      },
                      decoration: InputDecoration(
                        labelText: "Enter Catagory Name",
                      ),
                    ),
                  ),
                ),
                TextButton(onPressed: () {}, child: Text("cancel")),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _categoryController.uploadCategory(
                        pickedImage: _image,
                        pickedBanner: _bannerImage,
                        name: name,
                        context: context,
                      );
                    }
                  },
                  child: Text("save", style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () {
                  pickImage();
                },
                child: Text("Pick Image"),
              ),
            ),
            const Divider(color: Colors.grey),
            Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: _bannerImage != null
                    ? Image.memory(_bannerImage)
                    : const Text(
                        "Catagory Banner",
                        style: TextStyle(color: Colors.white),
                      ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () {
                  pickBannerImage();
                },
                child: Text("Pick Image"),
              ),
            ),
            const Divider(color: Colors.grey),
            CategoryWidget(),
          ],
        ),
      ),
    );
  }
}
