import 'package:app_web/controllers/subcategory_controller.dart';
import 'package:app_web/models/subcategory.dart';
import 'package:flutter/material.dart';

class SubCategoryWidget extends StatefulWidget {
  const SubCategoryWidget({super.key});

  @override
  State<SubCategoryWidget> createState() => _SubCategoryWidgetState();
}

class _SubCategoryWidgetState extends State<SubCategoryWidget> {
  late Future<List<SubCategory>> futureSubCategories;
  @override
  void initState() {
    super.initState();
    futureSubCategories = SubCategoryController().loadSubCategories();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: futureSubCategories,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No subcategories available'));
        } else {
          final subcategories = snapshot.data!;
          return GridView.builder(
            shrinkWrap: true,
            itemCount: subcategories.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 6,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            itemBuilder: (context, index) {
              final subcategory = subcategories[index];
              return Column(
                children: [
                  Image.network(width: 100, height: 100, subcategory.image),
                  Text(subcategory.subCategoryName),
                ],
              );
            },
          );
        }
      },
    );
  }
}
