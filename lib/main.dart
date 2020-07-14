import 'package:flutter/material.dart';
import 'package:fluttercalender/custom_button.dart';
import 'package:quiver/time.dart';
import 'package:expandable/expandable.dart';
import 'package:intl/intl.dart';

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

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
    );
  }
}
DateTime currentDate = DateTime.now();

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {


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
            ExpandableWrapper(currentDate),
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
  final bool isCurrentDay = false;

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

class ExpandableWrapper extends StatefulWidget {

    final DateTime currentDate;
   const ExpandableWrapper( this.currentDate);

  @override
  _ExpandableWrapperState createState() => _ExpandableWrapperState();
}

class _ExpandableWrapperState extends State<ExpandableWrapper> {



  @override
  Widget build(BuildContext context) {
    return ExpandableNotifier(
      initialExpanded: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[

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
                          '${DateFormat('EEEE').format(DateTime(widget.currentDate.day-1)).substring(0,3).toUpperCase()}',
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
                            onPressed: () {
                              setState(() {
                                currentDate = DateTime(currentDate.year,
                                    currentDate.month - 1, currentDate.day);
                              });
                            },
                            fontSize: 11,
                            textColor: Color(0xff2D3B51),
                            padding: const EdgeInsets.symmetric(
                                vertical: 4,
                                horizontal: 16),
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
                            onPressed: () {
                              setState(() {
                                currentDate = DateTime(currentDate.year,
                                    currentDate.month + 1, currentDate.day);
                              });
                            },
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
          )
        ],
      ),
    );
  }
}
