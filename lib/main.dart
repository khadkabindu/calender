import 'package:flutter/material.dart';
import 'package:date_util/date_util.dart';
import 'package:quiver/time.dart';

void main() {
  runApp(MyApp());
}

enum WeekDays { Sun, Mon, Tue, Wed, Thu, Fri, Sat }
enum Months {
  January,
  February,
  March,
  April,
  May,
  June,
  July,
  August,
  September,
  October,
  November,
  December
}

var now = DateTime.now();

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  DateTime currentDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Container(
                height: 60,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Expanded(
                      child: IconButton(
                        onPressed: () {
                          setState(() {
                            currentDate = DateTime(currentDate.year,
                                currentDate.month - 1, currentDate.day);
                          });
                        },
                        icon: Icon(
                          Icons.arrow_back_ios,
                          size: 16,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Expanded(
                      child: RichText(
                        text: TextSpan(
                          text:
                              '${Months.values[(currentDate.month - 1)].toString().split('.').last}' +
                                  '',
                          style: TextStyle(
                            fontSize: 24,
                            color: Colors.white,
                            fontWeight: FontWeight.w400,
                          ),
                          children: [
                            TextSpan(
                              text: '${currentDate.year}',
                              style:
                                  TextStyle(fontSize: 14, color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: IconButton(
                        onPressed: () {
                          setState(() {
                            currentDate = DateTime(currentDate.year,
                                currentDate.month + 1, currentDate.day);
                          });
                        },
                        icon: Icon(
                          Icons.arrow_forward_ios,
                          size: 16,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                decoration: BoxDecoration(
                  color: Color(0xFF4FE2C0),
                )),
            Container(
              height: 50,
              child: GridView.count(
                crossAxisCount: 7,
                children: List.generate(7, (index) {
                  return Container(
                    color: Colors.white,
                    child: Center(
                      child: Text(
                          '${WeekDays.values[index].toString().split('.').last}' +
                              ''),
                    ),
                  );
                }),
              ),
            ),
            CalenderView(UniqueKey(), currentDate),
          ],
        ),
      ),
    );
  }
}

class CalenderView extends StatefulWidget {
  final DateTime currentDate;

  const CalenderView(Key key, this.currentDate) : super(key: key);

  @override
  _CalenderViewState createState() => _CalenderViewState();
}

class _CalenderViewState extends State<CalenderView> {
  var totalDaysOfMonths;
  var dateTime;

  List<String> days = List(40);

  void numberOfDays() {
    for (int i = 0; i < days.length; i++) {
      days[i] = '';
    }

    for (int i = 1; i < totalDaysOfMonths + 1; i++) {
      days[i + dateTime.weekday - 1] = i.toString();
    }
  }

  @override
  void initState() {
    dateTime = DateTime(widget.currentDate.year, widget.currentDate.month, 1);
    totalDaysOfMonths = daysInMonth(widget.currentDate.year, widget.currentDate.month);
    numberOfDays();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      child: GridView.builder(
          itemCount: days.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 7,
          ),
          itemBuilder: (BuildContext context, int index) {
            return Container(child: Center(child: Text(days[index])));
          }),
    );
  }
}
