import 'package:app_web/view/side_bar_screens/produts_screen.dart';
import 'package:app_web/view/side_bar_screens/subcategory_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_admin_scaffold/admin_scaffold.dart';
import 'package:app_web/view/side_bar_screens/buyers_screen.dart';
import 'package:app_web/view/side_bar_screens/orders_screen.dart';
import 'package:app_web/view/side_bar_screens/catagory_screen.dart';
import 'package:app_web/view/side_bar_screens/upload_banneer_screen.dart';
import 'package:app_web/view/side_bar_screens/vendors_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  Widget _selectedScreen = VendorsScreen();

  screenSelector(item) {
    switch (item.route) {
      case VendorsScreen.id:
        setState(() {
          _selectedScreen = VendorsScreen();
        });
        break;
      case BuyersScreen.id:
        setState(() {
          _selectedScreen = BuyersScreen();
        });
        break;
      case OrdersScreen.id:
        setState(() {
          _selectedScreen = OrdersScreen();
        });
        break;
      case CatagoryScreen.id:
        setState(() {
          _selectedScreen = CatagoryScreen();
        });
        break;
      case SubCategoryScreen.id:
        setState(() {
          _selectedScreen = SubCategoryScreen();
        });
        break;
      case UploadBannerScreen.id:
        setState(() {
          _selectedScreen = UploadBannerScreen();
        });
        break;
      case ProdutsScreen.id:
        setState(() {
          _selectedScreen = ProdutsScreen();
        });
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AdminScaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text("Management"),
      ),
      body: _selectedScreen,
      sideBar: SideBar(
        header: Container(
          height: 50,
          width: double.infinity,
          decoration: BoxDecoration(color: Colors.black),
          child: const Center(
            child: Text(
              "Multi vandor Admin",
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                letterSpacing: 1.7,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        items: const [
          AdminMenuItem(
            title: "Vandors",
            route: VendorsScreen.id,
            icon: CupertinoIcons.person_3,
          ),
          AdminMenuItem(
            title: "Buyers",
            route: BuyersScreen.id,
            icon: CupertinoIcons.person,
          ),
          AdminMenuItem(
            title: "Orders",
            route: OrdersScreen.id,
            icon: CupertinoIcons.shopping_cart,
          ),
          AdminMenuItem(
            title: "Categories",
            route: CatagoryScreen.id,
            icon: Icons.category,
          ),
          AdminMenuItem(
            title: "SubCategories",
            route: SubCategoryScreen.id,
            icon: Icons.category_outlined,
          ),
          AdminMenuItem(
            title: "Upload Banner",
            route: UploadBannerScreen.id,
            icon: Icons.upload,
          ),
          AdminMenuItem(
            title: "Products",
            route: ProdutsScreen.id,
            icon: Icons.store,
          ),
        ],
        selectedRoute: VendorsScreen.id,
        onSelected: (item) {
          screenSelector(item);
        },
      ),
    );
  }
}
