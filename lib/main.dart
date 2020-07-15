import 'package:flutter/material.dart';
import 'package:fluttercalender/custom_button.dart';
import 'package:quiver/time.dart';
import 'package:expandable/expandable.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(MyApp());
}
DateTime currentDate = DateTime.now();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: ListView(
          children: <Widget>[
            Column(
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
                ExpandableWrapper(currentDate),
              ],
            ),
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
  String currentDayDate;


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
    totalDaysOfMonths =
        daysInMonth(widget.currentDate.year, widget.currentDate.month);
    currentDayDate = widget.currentDate.day.toString();

    numberOfDays();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          height: 50,
          child: GridView.count(
            crossAxisCount: 7,
            children: List.generate(7, (index) {
              return Container(
                color: Colors.white,
                child: Center(
                  child: Text(
                    '${WeekDays.values[index].toString().split('.').last}' + '',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              );
            }),
          ),
        ),
        Container(
          height: 300,
          child: GridView.builder(
              itemCount: days.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 7,
              ),
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  onTap: () {
                    setState(() {

                    });
                  },
                  child: Container(
                      decoration: BoxDecoration(
                        color: days[index] == currentDayDate
                            ? Color(0xfff8f8f9)
                            : Colors.white,
                        border: Border(
                          bottom: BorderSide(
                              width: 2.0,
                              color: days[index] == currentDayDate
                                  ? Color(0xFF4FE2C0)
                                  : Colors.transparent),
                        ),
                      ),
                      child: Center(child: Text(days[index],style: TextStyle(color: days[index] == currentDayDate ? Color(0xFF4FE2C0): Colors.black),))),
                );
              }),
        ),
      ],
    );
  }
}

class ExpandableWrapper extends StatefulWidget {
  final DateTime currentDate;

  const ExpandableWrapper(this.currentDate);

  @override
  _ExpandableWrapperState createState() => _ExpandableWrapperState();
}

class _ExpandableWrapperState extends State<ExpandableWrapper> {

  Iterable<TimeOfDay> getTimes(
      TimeOfDay startTime, TimeOfDay endTime, Duration step) sync* {
    var hour = startTime.hour;
    var minute = startTime.minute;

    do {
      yield TimeOfDay(hour: hour, minute: minute);
      minute += step.inMinutes;
      while (minute >= 60) {
        minute -= 60;
        hour++;
      }
    } while (hour < endTime.hour ||
        (hour == endTime.hour && minute <= endTime.minute));
  }

  final startTime = TimeOfDay(hour: 1, minute: 0);
  final endTime = TimeOfDay(hour: 23, minute: 0);
  final step = Duration(minutes: 60);
  List<String> times = [];
  final controller = ScrollController();


  @override
  Widget build(BuildContext context) {

    times = getTimes(startTime, endTime, step)
        .map((tod) => tod.format(context))
        .toList();
    var time = DateFormat.jm().format(DateTime.now());
    print(time);
    return ExpandableNotifier(
      initialExpanded: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expandable(
            expanded: CalenderView(UniqueKey(), currentDate),
          ),
          Padding(
            padding: const EdgeInsets.only(
              top: 8,
              right: 0,
              bottom: 8,
              left: 16,
            ),
            child: Builder(
              builder: (context) {
                var controller = ExpandableController.of(context);
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        Text(
                          '${DateFormat('EEEE').format(DateTime(widget.currentDate.day - 1)).substring(0, 3).toUpperCase()}',
                          style: TextStyle(
                              color: Color(0xFF40A8F4),
                              fontSize: 13,
                              fontWeight: FontWeight.w300),
                        ),
                        Text(
                          '${widget.currentDate.day}',
                          style: TextStyle(
                              fontSize: 20,
                              color: Color(0xFF40A8F4),
                              fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        SizedBox(
                          height: 28,
                          child: CustomButton(
                            color: Color(0xFF4FE2C0),
                            label: 'Prev',
                            onPressed: () {},
                            fontSize: 11,
                            textColor: Color(0xff2D3B51),
                            padding: const EdgeInsets.symmetric(
                                vertical: 4, horizontal: 16),
                          ),
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        SizedBox(
                          height: 28,
                          child: CustomButton(
                            color: Color(0xFF4FE2C0),
                            label: 'Next',
                            onPressed: () {},
                            fontSize: 11,
                            textColor: Color(0xff2D3B51),
                            padding: const EdgeInsets.symmetric(
                                vertical: 4, horizontal: 16),
                          ),
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        SizedBox(
                          height: 28,
                          child: CustomButton(
                            color: Color(0xFF4FE2C0),
                            label: 'Today',
                            onPressed: () {},
                            fontSize: 11,
                            textColor: Color(0xff2D3B51),
                            padding: const EdgeInsets.symmetric(
                                vertical: 4, horizontal: 16),
                          ),
                        ),
                        IconButton(
                          icon: controller.expanded
                              ? Icon(Icons.keyboard_arrow_up)
                              : Icon(Icons.keyboard_arrow_down),
                          onPressed: () {
                            controller.toggle();
                          },
                        )
                      ],
                    ),
                  ],
                );
              },
            ),
          ),
          Divider(
            height: 1,
            color: Colors.black26,
          ),
          Padding(
            padding: const EdgeInsets.only(
              top: 8,
              right: 0,
              bottom: 8,
              left: 16,
            ),
            child: SingleChildScrollView(
              physics: ScrollPhysics(),
              child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                itemCount: times.length,
                  itemBuilder: (BuildContext context, int index){
                return Container(
                  height: 80,
                  child: Row(
                    children: <Widget>[
                      Text('${times[index].substring(0,times[index].indexOf(':')) + times[index].substring(4,7)}'),
                      Container(

                        child: VerticalDivider(

                        ),
                       height: 100,

                      ),
                      Container(
                        color: Colors.black26,

                        height: 0.5,
                        width: 300,),
                    ],
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
