import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Map data = {};

  @override
  Widget build(BuildContext context) {
    /*
      - data will be initially empty if the state is rebuilt.
      - Calling setState(after updating data) in line 54 triggers a state rebuild,
        and overriden data is overriden by arguments from the previous route.
        hence the ternary operator.
    */
    data = data
            .isNotEmpty // data will not be empty if coming from choose_location screen
        ? data
        // Recieve data from the previous route(ie: everytime when building the state).
        : ModalRoute.of(context)?.settings.arguments as Map;
    if (kDebugMode) {
      print(data);
    }

    String bgImage = data['isDayTime'] ? 'day.png' : 'night.png';

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/$bgImage'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 120, 0, 0),
            child: Column(
              children: [
                // Edit location button
                TextButton.icon(
                  onPressed: () async {
                    // Get data from choose_location screen(when it pops off)
                    dynamic result =
                        await Navigator.pushNamed(context, '/location');

                    // Update home screen data
                    setState(() {
                      data = {
                        'time': result['time'],
                        'location': result['location'],
                        'flag': result['flag'],
                        'isDayTime': result['isDayTime'],
                      };
                    });
                  },
                  icon: Icon(
                    Icons.edit_location,
                    color: Colors.grey[300],
                  ),
                  label: Text(
                    'Edit location',
                    style: TextStyle(
                      color: Colors.grey[300],
                    ),
                  ),
                ),

                // Spacing
                const SizedBox(height: 20.0),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Location
                    Text(
                      data['location'],
                      style: const TextStyle(
                        fontSize: 28.0,
                        letterSpacing: 2.0,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),

                // Spacing
                const SizedBox(height: 20.0),

                // Time
                Text(
                  data['time'],
                  style: const TextStyle(
                    fontSize: 66.0,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
