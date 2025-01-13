import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:weather_app/pages/weather_page.dart';
import 'package:weather_app/database/database.dart';
import 'package:weather_app/secrets.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DataBase database = DataBase();

  @override
  void initState() {
    super.initState();

    if (database.box.get('data') == null) {
      database.initializeDatabase();
    } else {
      database.loadData();
    }
  }

  Future<bool> checkPlace(String city) async {
    final url =
        'https://api.openweathermap.org/data/2.5/forecast?q=$city&appid=$API_KEY&units=metrics';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  SnackBar message(String text) {
    return SnackBar(
      elevation: 0,
      backgroundColor: Colors.transparent,
      content: Container(
        decoration: BoxDecoration(
            color: Colors.black87, borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(10),
        padding: const EdgeInsets.all(10),
        child: Center(
          child: Text(
            text,
          ),
        ),
      ),
    );
  }

  void addCity() {
    TextEditingController textEditingController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Add city"),
          content: TextField(
            controller: textEditingController,
          ),
          actions: [
            MaterialButton(
              elevation: 10,
              color: Colors.black12,
              onPressed: () {},
              child: const Text(
                "Cancel",
                style: TextStyle(color: Colors.red),
              ),
            ),
            MaterialButton(
              elevation: 10,
              color: Colors.black12,
              onPressed: () async {
                if (await checkPlace(textEditingController.text)) {
                  database.addData(textEditingController.text);
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                      message("${textEditingController.text} Added to List"));
                } else {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                      message("Could not find ${textEditingController.text}"));
                }
              },
              child: const Text(
                "Add city",
              ),
            ),
          ],
        );
      },
    );
  }

  void removeCity(place) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Remove Place"),
          content: Text("Are you sure you want to remove place?"),
          actions: [
            MaterialButton(
              elevation: 10,
              color: Colors.black12,
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                "Cancel",
                style: TextStyle(
                  color: Colors.red,
                ),
              ),
            ),
            MaterialButton(
              onPressed: () {
                Navigator.pop(context);
                if (database.removeData(place)) {
                  message('$place has been rmoved');
                } else {
                  message("$place couldn't be removed");
                }
              },
              elevation: 10,
              color: Colors.black12,
              child: const Text("Yes"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        fit: StackFit.expand,
        children: [
          Image.asset(
            'lib/assets/images/background.jpg',
            fit: BoxFit.fill,
          ),
          ListenableBuilder(
            listenable: database.listenable(),
            builder: (context, child) {
              if (database.db.isNotEmpty) {
                return PageView(
                  children: [
                    for (int i = 0; i < database.db.length; i++)
                      WeatherPage(
                        city: database.db[i],
                        addCity: addCity,
                        removeCity: () => removeCity(database.db[i]),
                      )
                  ],
                );
              }
              return Scaffold(
                appBar: AppBar(
                  title: const Text("WEATHER APP"),
                  centerTitle: true,
                  actions: [
                    IconButton(
                      onPressed: addCity,
                      icon: const Icon(Icons.add),
                    )
                  ],
                ),
                body: Stack(
                  fit: StackFit.expand,
                  alignment: Alignment.center,
                  children: [
                    Image.asset(
                      'lib/assets/images/background.jpg',
                      fit: BoxFit.fill,
                    ),
                    const Center(
                      child: Text(
                        "Add place to weather app",
                        style: TextStyle(
                          fontSize: 23,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                  ],
                ),
              );
            },
          )
        ],
      ),
    );
  }
}
