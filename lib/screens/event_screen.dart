import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_seeclass/screens/add_event.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EventScreen extends StatefulWidget {
  @override
  _EventScreenState createState() => _EventScreenState();
}

class _EventScreenState extends State<EventScreen> {
  List<EventData> events = [];

  @override
  void initState() {
    super.initState();
    _loadEventDataFromSharedPreferences();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: events.length,
          itemBuilder: (context, index) {
            return _buildEventCard(events[index], index);
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _navigateToAddEvent(context);
        },
        child: Icon(Icons.add),
        backgroundColor: Color.fromARGB(255, 98, 107, 236),
      ),
    );
  }

  Widget _buildEventCard(EventData event, int index) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 15.0),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Upcoming Events',
              style: TextStyle(
                color: Color.fromARGB(255, 98, 107, 236),
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20.0, width: 120.0),
            event.eventImagePath.isNotEmpty
                ? _buildImageWidget(event.eventImagePath)
                : SizedBox.shrink(),
            Text(
              '${event.eventName}',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w700,
                fontSize: 24,
              ),
            ),
            Text(
              '${event.eventDescription}',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w400,
                fontSize: 12,
              ),
            ),
            Text(
              'Registration Link: ${event.eventRegistrationLink}',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w400,
                color: Colors.blueAccent,
              ),
            ),
            SizedBox(height: 10.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    _deleteEvent(index);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageWidget(String imagePath) {
    if (kIsWeb) {
      return Image.network(
        imagePath,
        height: 260,
        width: 190,
        fit: BoxFit.cover,
      );
    } else {
      return Image.asset(
        imagePath,
        height: 260,
        width: 190,
        fit: BoxFit.cover,
      );
    }
  }

  Future<void> _loadEventDataFromSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<EventData> loadedEvents = [];

    int eventCount = prefs.getInt('eventCount') ?? 0;

    for (int i = 0; i < eventCount; i++) {
      loadedEvents.add(EventData(
        eventName: prefs.getString('eventName_$i') ?? '',
        eventDescription: prefs.getString('eventDescription_$i') ?? '',
        eventRegistrationLink:
            prefs.getString('eventRegistrationLink_$i') ?? '',
        eventImagePath: prefs.getString('eventImagePath_$i') ?? '',
      ));
    }

    setState(() {
      events = loadedEvents;
    });
  }

  Future<void> _deleteEvent(int index) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<EventData> updatedEvents = List.from(events);
    updatedEvents.removeAt(index);

    prefs.setInt('eventCount', updatedEvents.length);
    for (int i = 0; i < updatedEvents.length; i++) {
      prefs.setString('eventName_$i', updatedEvents[i].eventName);
      prefs.setString('eventDescription_$i', updatedEvents[i].eventDescription);
      prefs.setString(
          'eventRegistrationLink_$i', updatedEvents[i].eventRegistrationLink);
      prefs.setString('eventImagePath_$i', updatedEvents[i].eventImagePath);
    }

    setState(() {
      events = updatedEvents;
    });
  }

  void _navigateToAddEvent(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddEvent(
          onEventAdded: () {
            _loadEventDataFromSharedPreferences();
          },
        ),
      ),
    );
  }
}

class EventData {
  final String eventName;
  final String eventDescription;
  final String eventRegistrationLink;
  final String eventImagePath;

  EventData({
    required this.eventName,
    required this.eventDescription,
    required this.eventRegistrationLink,
    required this.eventImagePath,
  });
}

void main() {
  runApp(MaterialApp(
    home: EventScreen(),
  ));
}
