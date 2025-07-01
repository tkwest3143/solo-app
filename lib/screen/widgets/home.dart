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

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24.0),
        ),
        elevation: 12,
        shadowColor: Colors.black.withOpacity(0.1),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24.0),
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF667eea),
                Color(0xFF764ba2),
              ],
            ),
          ),
          padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                formatDate(currentTime.value, format: 'yyyy/M/d (EEE)'),
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 16),
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
                        style: const TextStyle(
                          fontSize: 52,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: -2,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  const Text(':',
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: Colors.white70,
                      )),
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
                        style: const TextStyle(
                          fontSize: 52,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: -2,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  const Text(':',
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: Colors.white70,
                      )),
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
                        style: const TextStyle(
                          fontSize: 52,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: -2,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    working.icon,
                    const SizedBox(width: 12),
                    Text(
                      working.toString(),
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: WorkActionButton(
                    disable: working != Working.notWorking,
                    label: '出勤',
                    image: 'assets/icons/attendance.png',
                    onTap: () => onTapAttendance(),
                    gradientColors: const [Color(0xFF11998e), Color(0xFF38ef7d)]),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: WorkActionButton(
                    disable: working != Working.working,
                    label: '退勤',
                    image: 'assets/icons/go-home.png',
                    onTap: () => onTapGoingHome(),
                    gradientColors: const [Color(0xFFff7b7b), Color(0xFFff9ff3)]),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: WorkActionButton(
                    disable: working != Working.working,
                    label: '休憩開始',
                    image: 'assets/icons/break-time.png',
                    onTap: () => onTapResting(),
                    gradientColors: const [Color(0xFF54a0ff), Color(0xFF667eea)]),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: WorkActionButton(
                    disable: working != Working.resting,
                    label: '休憩終了',
                    image: 'assets/icons/back-office.png',
                    onTap: () => onTapBackOffice(),
                    gradientColors: const [Color(0xFF5f27cd), Color(0xFF764ba2)]),
              ),
            ],
          )
        ],
      ),
    );
  }
}

class WorkActionButton extends StatelessWidget {
  final bool disable;
  final String label;
  final String image;
  final List<Color> gradientColors;
  final Function onTap;

  const WorkActionButton(
      {super.key,
      required this.disable,
      required this.label,
      required this.image,
      required this.gradientColors,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      child: Material(
        borderRadius: BorderRadius.circular(20),
        elevation: disable ? 0 : 8,
        shadowColor: Colors.black.withOpacity(0.2),
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () => !disable ? onTap() : null,
          child: Container(
            height: 120,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: !disable
                  ? LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: gradientColors,
                    )
                  : LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Colors.grey.shade400, Colors.grey.shade500],
                    ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  image,
                  width: 40,
                  height: 40,
                  color: disable ? Colors.grey.shade600 : Colors.white,
                ),
                const SizedBox(height: 8),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: disable ? Colors.grey.shade600 : Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
