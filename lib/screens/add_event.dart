import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:flutter_seeclass/database/event_services.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:shared_preferences/shared_preferences.dart';

typedef OnEventAddedCallback = void Function();

class AddEvent extends StatelessWidget {
  final OnEventAddedCallback? onEventAdded;

  const AddEvent({Key? key, this.onEventAdded}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _AddEventContent(onEventAdded: onEventAdded);
  }
}

class _AddEventContent extends StatefulWidget {
  final OnEventAddedCallback? onEventAdded;

  const _AddEventContent({Key? key, this.onEventAdded}) : super(key: key);

  @override
  State<_AddEventContent> createState() => _AddEventContentState();
}

class _AddEventContentState extends State<_AddEventContent> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController name = TextEditingController();
  TextEditingController description = TextEditingController();
  TextEditingController registrationLink = TextEditingController();
  File? _selectedImage;

  EventService eventService = EventService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: Colors.grey[200], // Off-white background color
        title: Text(
          'Add Event',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w700,
            color: Color.fromARGB(255, 98, 107, 236),
          ),
        ),
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
            Navigator.pop(
              context,
            );
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(55.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _selectedImage != null
                    ? _buildImageWidget()
                    : SizedBox.shrink(),
                SizedBox(height: 20.0),
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                      Color.fromARGB(255, 98, 107, 236),
                    ),
                    foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                  ),
                  onPressed: () {
                    _pickImage(context);
                  },
                  child: Text('Add Photo',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),),
                ),
                SizedBox(height: 20.0),
                _buildGradientTextFormField(
                  controller: name,
                  labelText: 'Event Name',
                ),
                SizedBox(height: 20.0),
                _buildGradientTextFormField(
                  controller: description,
                  labelText: 'Description',
                  maxLines: null, // Set maxLines to 10
                ),
                SizedBox(height: 20.0),
                _buildGradientTextFormField(
                  controller: registrationLink,
                  labelText: 'Registration Link',
                ),
                SizedBox(height: 20.0),
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                      Color.fromARGB(255, 98, 107, 236),
                    ),
                    foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                  ),
                  onPressed: () async {
                    await _upsertEvent(context);
                  },
                  child: Text('Save',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),)
                  
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGradientTextFormField({
    required TextEditingController controller,
    required String labelText,
    int? maxLines, // Optional parameter for maxLines
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: labelText,
        fillColor: Colors.white,
        filled: true,
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey, width: 2.0),
          borderRadius: BorderRadius.circular(20.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Color.fromARGB(255, 98, 107, 236),
            width: 2.0,
          ),
          borderRadius: BorderRadius.circular(20.0),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter the $labelText';
        }
        return null;
      },
    );
  }

  Widget _buildImageWidget() {
    if (kIsWeb) {
      // Use Image.network for web
      return Image.network(
        _selectedImage!.path,
        height: 160.0,
        width: 90.0,
        fit: BoxFit.cover,
      );
    } else {
      // Use Image.file for other platforms
      return Image.file(
        _selectedImage!,
        height: 160.0,
        width: 90.0,
        fit: BoxFit.cover,
      );
    }
  }

  void _pickImage(BuildContext context) async {
    final ImagePicker _picker = ImagePicker();
    XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _selectedImage = File(image.path);
      });
    }
  }

  Future<void> _upsertEvent(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      await eventService.saveData(
        name.text,
        description.text,
        registrationLink.text,
        _selectedImage?.path ?? '',
      );

      // Save event data to SharedPreferences
      await _saveEventDataToSharedPreferences();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Event successfully saved!'),
        ),
      );

      widget.onEventAdded?.call();

      // Set result to true to indicate success
      Navigator.pop(context, true);
    }
  }

  Future<void> _saveEventDataToSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int eventCount = prefs.getInt('eventCount') ?? 0;

    // Increment event count
    prefs.setInt('eventCount', eventCount + 1);

    // Use the incremented event count
    int currentIndex = eventCount;

    prefs.setString('eventName_$currentIndex', name.text);
    prefs.setString('eventDescription_$currentIndex', description.text);
    prefs.setString(
      'eventRegistrationLink_$currentIndex',
      registrationLink.text,
    );
    prefs.setString(
      'eventImagePath_$currentIndex',
      _selectedImage?.path ?? '',
    );
  }
}
