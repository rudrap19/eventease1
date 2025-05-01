// RegistrationPage.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RegistrationPage extends StatefulWidget {
  final String bookingName;

  const RegistrationPage({Key? key, required this.bookingName}) : super(key: key);

  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  DateTime? selectedDate;
  String selectedTiming = 'Morning (8-3)';
  List<String> services = ['Catering', 'Decoration', 'Fireguns'];
  List<String> selectedServices = [];
  String selectedServicesString = '';

  final TextEditingController phoneController = TextEditingController();
  final TextEditingController otpController = TextEditingController();

  bool isEmailVerified = false;
  bool otpSent = false;
  bool otpVerified = false;
  String? _verificationId;
  Timer? _emailCheckTimer;

  final List<String> timings = [
    'Morning (8-3)',
    'Afternoon (3-9)',
    'Full Day (8-9)',
  ];

  @override
  void initState() {
    super.initState();
    _checkEmailVerification();
    _startEmailVerificationTimer();
  }

  @override
  void dispose() {
    _emailCheckTimer?.cancel();
    super.dispose();
  }

  Future<void> _startEmailVerificationTimer() async {
    _emailCheckTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      _checkEmailVerification();
      if (isEmailVerified) timer.cancel();
    });
  }

  Future<void> _checkEmailVerification() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await user.reload();
      setState(() {
        isEmailVerified = user.emailVerified;
      });
    }
  }

  Future<void> _resendEmailVerification() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null && !user.emailVerified) {
      await user.sendEmailVerification();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Verification email sent.')),);
    }
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: now,
      lastDate: DateTime(now.year + 1),
    );
    if (picked != null) {
      setState(() => selectedDate = picked);
    }
  }

  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    );
  }

  InputDecoration _underlineInput(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Colors.white54),
      enabledBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.white),
      ),
      focusedBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.white),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text('Book: ${widget.bookingName}'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/bg.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(color: Colors.black.withOpacity(0.6)),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.bookingName,
                      style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white)),
                  const SizedBox(height: 20),
                  _sectionTitle('Select Date'),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          selectedDate != null
                              ? '${selectedDate!.day}-${selectedDate!.month}-${selectedDate!.year}'
                              : 'No date chosen',
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                      TextButton(
                        onPressed: _pickDate,
                        child: const Text('Choose Date',
                            style: TextStyle(color: Colors.white)),
                      )
                    ],
                  ),
                  const SizedBox(height: 20),
                  _sectionTitle('Select Timing'),
                  DropdownButton<String>(
                    value: selectedTiming,
                    dropdownColor: Colors.black87,
                    style: const TextStyle(color: Colors.white),
                    items: timings
                        .map((t) => DropdownMenuItem(value: t, child: Text(t)))
                        .toList(),
                    onChanged: (val) {
                      if (val != null) setState(() => selectedTiming = val);
                    },
                  ),
                  const SizedBox(height: 20),
                  _sectionTitle('Select Services'),
                  Column(
                    children: services.map((service) {
                      return CheckboxListTile(
                        title: Text(service,
                            style: const TextStyle(color: Colors.white)),
                        value: selectedServices.contains(service),
                        activeColor: Colors.green,
                        checkColor: Colors.white,
                        onChanged: (bool? value) {
                          setState(() {
                            if (value == true) {
                              selectedServices.add(service);
                            } else {
                              selectedServices.remove(service);
                            }
                            selectedServicesString =
                                selectedServices.join(', ');
                          });
                        },
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 20),
                  _sectionTitle('Email Verification'),
                  if (!isEmailVerified)
                    TextButton(
                      onPressed: _resendEmailVerification,
                      child: const Text('Resend verification email',
                          style: TextStyle(color: Colors.white)),
                    )
                  else
                    const Text('Email verified',
                        style: TextStyle(color: Colors.white)),
                  const SizedBox(height: 20),
                  _sectionTitle('Phone Verification'),
                  TextField(
                    controller: phoneController,
                    keyboardType: TextInputType.phone,
                    decoration: _underlineInput('Enter phone number'),
                    style: const TextStyle(color: Colors.white),
                  ),
                  const SizedBox(height: 10),
                  if (!otpSent)
                    ElevatedButton(
                      onPressed: () {}, // OTP logic omitted for brevity
                      child: const Text('Send OTP'),
                    )
                  else if (!otpVerified) ...[
                    TextField(
                      controller: otpController,
                      keyboardType: TextInputType.number,
                      decoration: _underlineInput('Enter OTP'),
                      style: const TextStyle(color: Colors.white),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () {},
                      child: const Text('Verify OTP'),
                    ),
                  ] else
                    const Text('Phone verified',
                        style: TextStyle(color: Colors.white)),
                  const SizedBox(height: 30),
                  Center(
                    child: ElevatedButton(
                      onPressed: isEmailVerified && otpVerified &&
                          selectedDate != null
                          ? () {
                        // Here you can use `selectedServicesString`
                        print('Services: $selectedServicesString');
                      }
                          : null,
                      child: const Text('Confirm Booking'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
