import 'package:flutter/material.dart';
import 'dart:async'; // ضروري لتشغيل العداد

class CheckEmailScreen extends StatefulWidget {
  final String email;
  const CheckEmailScreen({super.key, required this.email});

  @override
  State<CheckEmailScreen> createState() => _CheckEmailScreenState();
}

class _CheckEmailScreenState extends State<CheckEmailScreen> {
  int _start = 59;
  Timer? _timer;

  // دالة لتشغيل العداد التنازلي
  void startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_start == 0) {
        setState(() => _timer?.cancel());
      } else {
        setState(() => _start--);
      }
    });
  }

  @override
  void initState() {
    startTimer();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF121212), // لون الخلفية الداكن كما في الصورة
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 1. الأيقونة (يمكنك استبدالها بـ Image.asset لو عندك صورة)
            Icon(
              Icons.mark_email_unread_outlined,
              size: 100,
              color: Colors.blueGrey[200],
            ),

            SizedBox(height: 32),

            // 2. العنوان
            Text(
              "Check your email",
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            SizedBox(height: 16),

            // 3. الوصف
            Text(
              "We've sent a special link to reset your password to ${widget.email}. Please check your inbox and spam folder.",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey[400],
                fontSize: 16,
                height: 1.5,
              ),
            ),

            SizedBox(height: 32),

            // 4. العداد
            Text(
              "Resend link in: 0:${_start.toString().padLeft(2, '0')}",
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),

            SizedBox(height: 40),

            // 5. الأزرار
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      /* أضف كود فتح تطبيق الإيميل */
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF1A3668),
                    ),
                    child: Text("Open Mail App"),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _start == 0
                        ? () {
                            /* كود إعادة الإرسال */
                          }
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _start == 0
                          ? Color(0xFF1A3668)
                          : Colors.grey[800],
                    ),
                    child: Text("Resend Link"),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
