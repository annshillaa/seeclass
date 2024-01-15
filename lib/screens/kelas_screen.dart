// kelas_screen.dart

import 'package:flutter/material.dart';
import 'detail_screen.dart'; // Import the detail screen file

class KelasScreen extends StatelessWidget {
  final List<Map<String, dynamic>> data = [
    {'name': 'GKT', 'image': 'assets/images/gkt.jpg'},
    {'name': 'SA', 'image': 'assets/images/sa.png'},
    {'name': 'SB', 'image': 'assets/images/well.png'},
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: data.length,
      itemBuilder: (context, index) {
        return Card(
          margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          child: InkWell(
            onTap: () {
              // Navigate to the detail screen with the selected item data
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetailScreen(itemData: data[index]),
                ),
              );
            },
            child: ListTile(
              contentPadding: EdgeInsets.all(16.0),
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    height: 200.0,
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(8.0),
                      image: DecorationImage(
                        image: AssetImage(data[index]['image']),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 8.0,
                  ),
                  Text(
                    data[index]['name'],
                    style: TextStyle(
                      fontFamily: 'Poppins',
              
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              // Add more details or actions as needed
            ),
          ),
        );
      },
    );
  }
}
