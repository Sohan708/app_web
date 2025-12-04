import 'package:app_web/view/side_bar_screens/widget/subcategory_widget.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:app_web/models/category.dart';
import 'package:app_web/controllers/category_controller.dart';
import 'package:app_web/controllers/subcategory_controller.dart';

class SubCategoryScreen extends StatefulWidget {
  static const String id = 'subCategoryScreen';
  const SubCategoryScreen({super.key});

  @override
  State<SubCategoryScreen> createState() => _SubCategoryScreenState();
}

class _SubCategoryScreenState extends State<SubCategoryScreen> {
  final SubCategoryController subCategoryController = SubCategoryController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late Future<List<Category>> futureCategories;
  late String name;
  Category? selectedCategory;
  @override
  void initState() {
    super.initState();
    futureCategories = CategoryController().loadCategories();
  }

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
                  "SubCategories",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 36),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Divider(color: Colors.grey),
            ),

            FutureBuilder(
              future: futureCategories,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text("Error: ${snapshot.error}"));
                } else if (snapshot.data!.isEmpty) {
                  return const Center(child: Text("No Categories"));
                } else {
                  return DropdownButton<Category>(
                    value: selectedCategory,
                    hint: const Text("Select Category"),
                    onChanged: (value) {
                      setState(() {
                        selectedCategory = value;
                      });
                      print(selectedCategory!.name);
                    },
                    items: snapshot.data!.map((Category category) {
                      return DropdownMenuItem(
                        value: category,
                        child: Text(category.name),
                      );
                    }).toList(),
                  );
                }
              },
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
                        : Text("Subcategory Image"),
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
                          return "Please enter sub catagory name";
                        }
                      },
                      decoration: InputDecoration(
                        labelText: "Enter SubCatagory Name",
                      ),
                    ),
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      await subCategoryController.uploadSubCategory(
                        categoryId: selectedCategory!.id,
                        categoryName: selectedCategory!.name,
                        pickedImage: _image,
                        subCategoryName: name,
                        context: context,
                      );
                      setState(() {
                        _formKey.currentState!.reset();
                        _image = null;
                        selectedCategory = null;
                      });
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
            Divider(color: Colors.grey),
            SubCategoryWidget(),
          ],
        ),
      ),
    );
  }
}
