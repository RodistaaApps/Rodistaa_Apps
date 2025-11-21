import 'package:flutter/material.dart';
import 'trucking_screen.dart';
import 'freshmarts_screen.dart';
import 'warehousing_screen.dart';

/// Service Tabs Screen - Main Hub for all Rodistaa services
/// Displays three tabs: Trucking, FreshMarts, and Warehousing
class ServiceTabsScreen extends StatelessWidget {
  const ServiceTabsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 2,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Color(0xFFC90D0D)),
            onPressed: () => Navigator.pop(context),
          ),
          title: const Text(
            'Rodistaa Services',
            style: TextStyle(
              fontFamily: 'Times New Roman',
              color: Color(0xFFC90D0D),
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
          ),
          bottom: const TabBar(
            labelColor: Color(0xFFC90D0D),
            unselectedLabelColor: Colors.grey,
            indicatorColor: Color(0xFFC90D0D),
            indicatorWeight: 3,
            labelStyle: TextStyle(
              fontFamily: 'Times New Roman',
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
            unselectedLabelStyle: TextStyle(
              fontFamily: 'Times New Roman',
              fontWeight: FontWeight.normal,
              fontSize: 14,
            ),
            tabs: [
              Tab(
                icon: Icon(Icons.local_shipping_outlined),
                text: 'Trucking',
              ),
              Tab(
                icon: Icon(Icons.shopping_basket_outlined),
                text: 'FreshMarts',
              ),
              Tab(
                icon: Icon(Icons.warehouse_outlined),
                text: 'Warehousing',
              ),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            TruckingScreen(),
            FreshMartsScreen(),
            WarehousingScreen(),
          ],
        ),
      ),
    );
  }
}

