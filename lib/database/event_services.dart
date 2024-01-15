import 'dart:convert';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';

class EventService {
  getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> itemStrings = prefs.getStringList('event') ?? [];
    return itemStrings
        .map((item) => json.decode(item) as Map<String, dynamic>)
        .toList();
  }

  saveData(
    String nama_event,
    String description,
    String link,
    String imagePath,
  ) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> dataList = prefs.getStringList('event') ?? [];
    Map<String, dynamic> newData = {
      'id': DateTime.now().millisecondsSinceEpoch.toInt(),
      'nama_event': nama_event,
      'description': description,
      'link': link,
      'imagePath': imagePath,
    };
    dataList.add(jsonEncode(newData));
    prefs.setStringList(
      'event',
      dataList,
    );
  }

  updateData(
    String nama_event,
    String description,
    String link,
    String imagePath,
    int id,
  ) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> dataList = prefs.getStringList('event') ?? [];
    Map<String, dynamic> newData = {
      'nama_event': nama_event,
      'description': description,
      'link': link,
      'imagePath': imagePath,
    };

    int dataIndex = -1;
    for (int i = 0; i < dataList.length; i++) {
      Map<String, dynamic> data = jsonDecode(dataList[i]);
      if (data['id'] == id) {
        dataIndex = i;
        break;
      }
    }
    if (dataIndex != -1) {
      dataList[dataIndex] = jsonEncode(newData);
      // Jika data ditemukan, perbarui data tersebut dengan newData
    }
    prefs.setStringList(
      'event',
      dataList,
    ); // Menyimpan daftar data ke local storage
  }

  deleteData(int index) async {
    //adalah metode yang digunakan untuk mendapatkan instance (instansiasi) objek SharedPreferences dalam Flutter.
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //digunakan untuk mendapatkan nilai dari SharedPreferences dengan kunci 'data'
    List<String> dataList = prefs.getStringList('event') ?? [];

    //menghilangkan data dari dataList berdasarkan index
    dataList.removeAt(index);

    //set ulang local storage dengan data yang diperbarui
    prefs.setStringList('event', dataList);
  }

  Future<File?> getImageFile(String imagePath) async {
    if (imagePath.isNotEmpty) {
      return File(imagePath);
    }
    return null;
  }
}
  
//   static final DbHelper _instance = DbHelper._internal();
//   SharedPreferences? _prefs;

//   DbHelper._internal();

//   factory DbHelper() => _instance;

//   Future<SharedPreferences> get _preferences async {
//     if (_prefs != null) {
//       return _prefs!;
//     }
//     _prefs = await SharedPreferences.getInstance();
//     return _prefs!;
//   }

//   Future<List<Event>> getAllEvents() async {
//     List<String>? events = _prefs?.getStringList('events');
//     if (events != null) {
//       return events.map((event) => Event.fromJson(jsonDecode(event))).toList();
//     }
//     return [];
//   }

//   Future<void> saveEvent(Event newEvent) async {
//     List<Event> existingEvents = await getAllEvents();
//     existingEvents.add(newEvent);
//     await _saveEventToPrefs(existingEvents);
//   }

//   Future<void> updateEvent(Event updatedEvent) async {
//     List<Event> existingEvents = await getAllEvents();
//     int index =
//         existingEvents.indexWhere((event) => event.id == updatedEvent.id);
//     if (index != -1) {
//       existingEvents[index] = updatedEvent;
//       await _saveEventToPrefs(existingEvents);
//     }
//   }

//   Future<void> deleteEvent(int id) async {
//     List<Event> existingEvents = await getAllEvents();
//     existingEvents.removeWhere((event) => event.id == id);
//     await _saveEventToPrefs(existingEvents);
//   }

//   Future<void> _saveEventToPrefs(List<Event> events) async {
//     List<String> eventStrings =
//         events.map((event) => jsonEncode(event.toJson())).toList();
//     await _prefs?.setStringList('events', eventStrings);

//     print('Events saved to SharedPreferences: $eventStrings');
//   }

//   Future<File?> getImageFile(String imagePath) async {
//     return File(imagePath);
//   }
// }
