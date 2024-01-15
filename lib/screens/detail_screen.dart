import 'package:flutter/material.dart';

class DetailScreen extends StatefulWidget {
  final Map<String, dynamic> itemData;

  DetailScreen({required this.itemData});

  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  int selectedFloorIndex = 0;
  final List<List<Map<String, dynamic>>> classInfoListPerFloor = List.generate(
    8,
    (floorIndex) => List.generate(
      10,
      (classIndex) => {
        'facilities': 'Proyektor, 10 Stopkontak, Speaker',
        'isOccupied': false,
      },
    ),
  );

  void _toggleClassStatus(int floorIndex, int classIndex) {
    setState(() {
      classInfoListPerFloor[floorIndex][classIndex]['isOccupied'] =
          !classInfoListPerFloor[floorIndex][classIndex]['isOccupied'];
    });
  }

  void _saveClassInfo(int floorIndex, int classIndex) {
    Navigator.of(context).pop();
  }

  void _showClassInfoDialog(int floorIndex, int classIndex) {
    bool originalStatus =
        classInfoListPerFloor[floorIndex][classIndex]['isOccupied'];
    bool newStatus = originalStatus;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text(
                'Class Information',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w700,
                ),
              ),
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Facilities: ${classInfoListPerFloor[floorIndex][classIndex]['facilities']}',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 8.0),
                  Text(
                    'Status: ${newStatus ? 'Terisi' : 'Kosong'}',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 16.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Status Kelas:',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Switch(
                        value: newStatus,
                        onChanged: (value) {
                          setState(() {
                            newStatus = value;
                          });
                        },
                      ),
                    ],
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    _saveClassInfo(floorIndex, classIndex);
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        Color.fromARGB(255, 98, 107, 236)),
                  ),
                  child: Text(
                    'Save',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
                    side: MaterialStateProperty.all<BorderSide>(
                      BorderSide(color: Colors.grey),
                    ),
                    elevation: MaterialStateProperty.all<double>(5.0),
                  ),
                  child: Text(
                    'Cancel',
                    style: TextStyle(
                      color: Colors.grey[100],
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    ).then((value) {
      if (originalStatus != newStatus) {
        setState(() {
          classInfoListPerFloor[floorIndex][classIndex]['isOccupied'] =
              newStatus;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[200],
        leading: IconButton(
          icon: ShaderMask(
            shaderCallback: (Rect bounds) {
              return LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color.fromARGB(255, 113, 162, 253),
                  const Color.fromARGB(255, 102, 19, 244)
                ],
              ).createShader(bounds);
            },
            child: Icon(Icons.arrow_back),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          widget.itemData['name'],
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w700,
            color: Color.fromARGB(255, 98, 107, 236),
          ),
        ),
      ),
      body: Container(
        color: Colors.grey[200],
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 16.0),
                Text(
                  'Details for ${widget.itemData['name']}',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w700,
                    fontSize: 24.0,
                  ),
                ),
                SizedBox(height: 8.0),

                // Dropdown with GridView
                DropdownButtonFormField<int>(
                  decoration: InputDecoration(
                    labelText: 'Pilih Lantai',
                    labelStyle: TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  items: List.generate(
                    classInfoListPerFloor.length, (index) => index)
                    .map((int value) {
                      return DropdownMenuItem<int>(
                        value: value,
                        child: Text('Lantai ${value + 1}',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                        ),),
                      );
                    }).toList(),
                  onChanged: (int? newValue) {
                    setState(() {
                      selectedFloorIndex = newValue!;
                    });
                  },
                  value: selectedFloorIndex,
                ),
                SizedBox(height: 16.0),
                GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    crossAxisSpacing: 8.0,
                    mainAxisSpacing: 8.0,
                  ),
                  itemCount: classInfoListPerFloor[selectedFloorIndex].length,
                  shrinkWrap: true,
                  itemBuilder: (BuildContext context, int classIndex) {
                    return InkWell(
                      onTap: () {
                        _showClassInfoDialog(selectedFloorIndex, classIndex);
                      },
                      child: Card(
                        color: classInfoListPerFloor[selectedFloorIndex]
                                [classIndex]['isOccupied']
                            ? Color.fromARGB(255, 98, 107, 236)
                            : Colors.grey,
                        child: Center(
                          child: Text(
                            'Class ${classIndex + 1}',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
