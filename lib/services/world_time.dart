import 'package:flutter/foundation.dart';
import 'package:http/http.dart';
import 'dart:convert';
import 'package:intl/intl.dart';

class WorldTime {
  String location; // Location displayed in UI
  late String time; // Time in that location
  String flag; // Url to an asset flag icon
  String url; // Location url for api endpoint
  late bool isDayTime;

  WorldTime({required this.location, required this.flag, required this.url});

  // Return void only after the async function is complete
  Future<void> getTime() async {
    try {
      // Make http request
      Response response =
          await get(Uri.parse('http://worldtimeapi.org/api/timezone/$url'));
      Map data = jsonDecode(response.body);

      // Get properties from data
      String datetime = data['datetime'];
      String offset = data['utc_offset'].substring(1, 3); // eg: +01:00 to 01

      // Create DateTime object
      DateTime now = DateTime.parse(datetime);
      // now.add is non-destructive(does not update object directly)
      now = now.add(Duration(hours: int.parse(offset)));

      // Check if it is day or night
      isDayTime = now.hour > 6 && now.hour < 20 ? true : false;

      // Format and set the time property
      time = DateFormat.jm().format(now);
    } catch (e) {
      if (kDebugMode) {
        print('error: $e');
      }
      time = 'could not get time data';
    }
  }
}
