import 'package:flutter/material.dart';
import 'package:flutter_seeclass/screens/login.dart';
import 'kelas_screen.dart';
import 'event_screen.dart';

class HomePage extends StatefulWidget {
  final String userUsername;

  const HomePage(this.userUsername, {Key? key, required String username})
      : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  List<String> _appBarTitles = ['Class', 'Event']; // List judul AppBar

  final List<Widget> _children = [
    KelasScreen(),
    EventScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[200],
        title: Text(_appBarTitles[_currentIndex],
        style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w700,
            color: Color.fromARGB(255, 98, 107, 236),
          ),), // Judul AppBar sesuai dengan indeks terpilih
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
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => LoginPage()),
            );
          },
        ),
        actions: [
          IconButton(
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
              child: Icon(Icons.settings),
            ),
            onPressed: () {
              // Handle settings button press
            },
          ),
          IconButton(
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
              child: Icon(Icons.notifications),
            ),
            onPressed: () {
              // Handle notifications button press
            },
          ),
          Padding(
            padding: EdgeInsets.only(right: 20.0),
            child: IconButton(
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
                child: Icon(Icons.search),
              ),
              onPressed: () {
                // Handle search button press
              },
            ),
          ),
        ],
      ),
      body: Container(
        color: Colors.grey[200],
        child: _children[_currentIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: onTabTapped,
        items: [
          BottomNavigationBarItem(
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
              child: Icon(Icons.class_),
            ),
            label: 'Class',
          ),
          BottomNavigationBarItem(
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
              child: Icon(Icons.event),
            ),
            label: 'Event',
          ),
        ],
      ),
    );
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
}
