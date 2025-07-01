import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:solo/utilities/const/working.dart';
import 'dart:async';

import 'package:solo/utilities/date.dart';

class CurrentTime extends HookWidget {
  final Working working;
  final void Function()? onWorkDateChanged;
  const CurrentTime({super.key, required this.working, this.onWorkDateChanged});

  @override
  Widget build(BuildContext context) {
    final currentTime = useState(DateTime.now());

    useEffect(() {
      final timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (currentTime.value.day != DateTime.now().day) {
          if (onWorkDateChanged != null) {
            onWorkDateChanged!();
          }
        }
        currentTime.value = DateTime.now();
      });
      return timer.cancel;
    }, []);

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(90.0),
      ),
      color: Theme.of(context).primaryColor,
      elevation: 8,
      shadowColor: Colors.black54,
      margin: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            formatDate(currentTime.value, format: 'yyyy/M/d (EEE)'),
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 80,
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 500),
                  transitionBuilder:
                      (Widget child, Animation<double> animation) {
                    return SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(0, -0.3),
                        end: const Offset(0, 0),
                      ).animate(animation),
                      child: child,
                    );
                  },
                  child: Text(
                    formatDate(currentTime.value, format: 'HH'),
                    key: ValueKey<String>(
                        formatDate(currentTime.value, format: 'HH')),
                    style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              const Text(':',
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
              SizedBox(
                width: 80,
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 500),
                  transitionBuilder:
                      (Widget child, Animation<double> animation) {
                    return SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(0, -0.3),
                        end: const Offset(0, 0),
                      ).animate(animation),
                      child: child,
                    );
                  },
                  child: Text(
                    formatDate(currentTime.value, format: 'mm'),
                    key: ValueKey<String>(
                        formatDate(currentTime.value, format: 'mm')),
                    style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              const Text(':',
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
              SizedBox(
                width: 80,
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 500),
                  transitionBuilder:
                      (Widget child, Animation<double> animation) {
                    return SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(0, -0.3),
                        end: const Offset(0, 0),
                      ).animate(animation),
                      child: child,
                    );
                  },
                  child: Text(
                    formatDate(currentTime.value, format: 'ss'),
                    key: ValueKey<String>(
                        formatDate(currentTime.value, format: 'ss')),
                    style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              working.icon,
              const SizedBox(width: 10),
              Text(
                working.toString(),
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}

class WorkingButtonList extends StatelessWidget {
  final Working working;
  final void Function() onTapAttendance;
  final void Function() onTapGoingHome;
  final void Function() onTapResting;
  final void Function() onTapBackOffice;
  const WorkingButtonList(
      {super.key,
      required this.working,
      required this.onTapAttendance,
      required this.onTapGoingHome,
      required this.onTapResting,
      required this.onTapBackOffice});

  @override
  Widget build(BuildContext context) {
    return Center(
        child: SizedBox(
      height: MediaQuery.of(context).size.height * 0.5,
      child: Column(
        children: [
          Row(
            children: [
              WorkActionButton(
                  disable: working != Working.notWorking,
                  label: '出勤',
                  image: 'assets/icons/attendance.png',
                  onTap: () => onTapAttendance(),
                  color: Colors.cyanAccent),
              WorkActionButton(
                  disable: working != Working.working,
                  label: '退勤',
                  image: 'assets/icons/go-home.png',
                  onTap: () => onTapGoingHome(),
                  color: const Color(0xffFFA500)),
            ],
          ),
          Row(
            children: [
              WorkActionButton(
                  disable: working != Working.working,
                  label: '休憩開始',
                  image: 'assets/icons/break-time.png',
                  onTap: () => onTapResting(),
                  color: Colors.greenAccent),
              WorkActionButton(
                  disable: working != Working.resting,
                  label: '休憩終了',
                  image: 'assets/icons/back-office.png',
                  onTap: () => onTapBackOffice(),
                  color: Colors.amberAccent),
            ],
          )
        ],
      ),
    ));
  }
}

class WorkActionButton extends StatelessWidget {
  final bool disable;
  final String label;
  final String image;
  final Color color;
  final Function onTap;

  const WorkActionButton(
      {super.key,
      required this.disable,
      required this.label,
      required this.image,
      required this.color,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => !disable ? onTap() : null,
        child: Container(
            width: MediaQuery.of(context).size.width * 0.5 - 20,
            height: MediaQuery.of(context).size.height * 0.12,
            margin: const EdgeInsets.all(10),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: !disable ? color : Colors.grey,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: const Color.fromARGB(137, 98, 97, 97),
                  blurRadius: 8,
                  offset: const Offset(2, 2),
                )
              ],
            ),
            child: Row(children: [
              Padding(
                padding: const EdgeInsets.only(right: 10),
                child: Image.asset(image, width: 50, height: 50),
              ),
              Text(label, style: const TextStyle(fontSize: 20)),
            ])));
  }
}
