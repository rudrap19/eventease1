import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({Key? key}) : super(key: key);

  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  DateTime? selectedDate;
  String selectedTiming = 'Morning (8-3)';
  List<String> selectedServices = [];

  final TextEditingController phoneController = TextEditingController();
  final TextEditingController otpController = TextEditingController();

  bool isEmailVerified = false;
  bool otpSent = false;
  bool otpVerified = false;
  String? _verificationId;
  Timer? _emailCheckTimer;

  final List<String> timings = [
    'Morning (8-3)',
    'Evening (5-10)',
    'Full Day (8-10)',
  ];

  final List<String> services = [
    'Catering',
    'Decoration',
    'Fireguns',
  ];

  @override
  void initState() {
    super.initState();
    _checkEmailVerification();
    _startEmailVerificationTimer();
  }

  void _startEmailVerificationTimer() {
    _emailCheckTimer = Timer.periodic(const Duration(seconds: 5), (timer) async {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await user.reload();
        if (user.emailVerified) {
          setState(() => isEmailVerified = true);
          timer.cancel();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Email verified!')),
          );
        }
      }
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
        const SnackBar(content: Text('Verification email sent.')),
      );
    }
  }

  Future<void> _sendOtp() async {
    final phone = phoneController.text.trim();
    if (phone.isEmpty || phone.length < 10) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Enter a valid phone number')),
      );
      return;
    }

    final fullPhone = '+91$phone'; // Change country code if needed

    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: fullPhone,
      timeout: const Duration(seconds: 60),
      verificationCompleted: (credential) async {
        await FirebaseAuth.instance.signInWithCredential(credential);
        setState(() => otpVerified = true);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Phone auto-verified')),
        );
      },
      verificationFailed: (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('OTP Failed: ${e.message}')),
        );
      },
      codeSent: (verificationId, _) {
        setState(() {
          _verificationId = verificationId;
          otpSent = true;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('OTP sent')),
        );
      },
      codeAutoRetrievalTimeout: (verificationId) {
        _verificationId = verificationId;
      },
    );
  }

  Future<void> _verifyOtp() async {
    final code = otpController.text.trim();
    if (_verificationId == null || code.isEmpty) return;

    try {
      final credential = PhoneAuthProvider.credential(
        verificationId: _verificationId!,
        smsCode: code,
      );
      await FirebaseAuth.instance.signInWithCredential(credential);
      setState(() => otpVerified = true);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('OTP Verified')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Invalid OTP: $e')),
      );
    }
  }

  void _submitBooking() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Booking Submitted!')),
    );
  }

  void _selectDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null) setState(() => selectedDate = picked);
  }

  void _toggleService(String service) {
    setState(() {
      selectedServices.contains(service)
          ? selectedServices.remove(service)
          : selectedServices.add(service);
    });
  }

  @override
  void dispose() {
    _emailCheckTimer?.cancel();
    phoneController.dispose();
    otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Registration for Booking'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/bg.png"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(color: Colors.black.withOpacity(0.4)),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _sectionTitle("Select Date"),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          selectedDate != null
                              ? '${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}'
                              : 'No date selected',
                          style: const TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () => _selectDate(context),
                        child: const Text('Choose Date'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  _sectionTitle("Select Timing"),
                  DropdownButton<String>(
                    value: selectedTiming,
                    dropdownColor: Colors.white,
                    onChanged: (newValue) => setState(() => selectedTiming = newValue!),
                    items: timings.map((value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 20),

                  _sectionTitle("Additional Services"),
                  ...services.map((service) => CheckboxListTile(
                    title: Text(service, style: const TextStyle(color: Colors.white)),
                    value: selectedServices.contains(service),
                    onChanged: (_) => _toggleService(service),
                  )),

                  const SizedBox(height: 20),
                  _sectionTitle("Phone Number"),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: phoneController,
                          keyboardType: TextInputType.phone,
                          style: const TextStyle(color: Colors.white),
                          decoration: _underlineInput("Enter phone number"),
                        ),
                      ),
                      const SizedBox(width: 10),
                      ElevatedButton(onPressed: _sendOtp, child: const Text('Send OTP')),
                    ],
                  ),

                  if (otpSent) ...[
                    const SizedBox(height: 20),
                    _sectionTitle("Verify OTP"),
                    TextField(
                      controller: otpController,
                      style: const TextStyle(color: Colors.white),
                      decoration: _underlineInput("Enter OTP"),
                    ),
                    const SizedBox(height: 8),
                    ElevatedButton(onPressed: _verifyOtp, child: const Text('Verify OTP')),
                  ],

                  const SizedBox(height: 20),
                  _sectionTitle("Email Verification"),
                  Row(
                    children: [
                      Text(
                        'Verified: ${isEmailVerified ? "Yes" : "No"}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: isEmailVerified ? Colors.green : Colors.red,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(width: 10),
                      if (!isEmailVerified)
                        ElevatedButton(
                          onPressed: _resendEmailVerification,
                          child: const Text("Resend Email"),
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.orangeAccent),
                        ),
                    ],
                  ),

                  const SizedBox(height: 30),
                  Center(
                    child: ElevatedButton(
                      onPressed: isEmailVerified ? _submitBooking : null,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                        backgroundColor: Colors.green,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: const Text('Book', style: TextStyle(fontSize: 18)),
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

  Text _sectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
    );
  }

  InputDecoration _underlineInput(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Colors.white54),
      enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
      focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
    );
  }
}
