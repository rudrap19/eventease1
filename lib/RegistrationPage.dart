import 'package:flutter/material.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({Key? key}) : super(key: key);

  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  DateTime? selectedDate;
  String selectedTiming = 'Morning (8-3)';
  List<String> selectedServices = [];
  TextEditingController phoneController = TextEditingController();
  TextEditingController otpController = TextEditingController();

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

  void _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  void _toggleService(String service) {
    setState(() {
      if (selectedServices.contains(service)) {
        selectedServices.remove(service);
      } else {
        selectedServices.add(service);
      }
    });
  }

  void _sendOtp() {
    // Simulate OTP sending
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('OTP sent to phone number')),
    );
  }

  void _submitBooking() {
    // Booking logic here
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Booking submitted')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text('Registration for Booking'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/bg.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Select Date',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        selectedDate != null
                            ? '${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}'
                            : 'No date selected',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () => _selectDate(context),
                      child: const Text('Choose Date'),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                const Text(
                  'Select Timing',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                DropdownButton<String>(
                  value: selectedTiming,
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedTiming = newValue!;
                    });
                  },
                  items: timings.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Additional Services',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                ...services.map((service) {
                  return CheckboxListTile(
                    title: Text(service),
                    value: selectedServices.contains(service),
                    onChanged: (_) => _toggleService(service),
                  );
                }).toList(),
                const SizedBox(height: 20),
                const Text(
                  'Phone Number',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: phoneController,
                        keyboardType: TextInputType.phone,
                        decoration: const InputDecoration(
                          hintText: 'Enter phone number',
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: _sendOtp,
                      child: const Text('Get OTP'),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                const Text(
                  'Verify OTP',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                TextField(
                  controller: otpController,
                  decoration: const InputDecoration(
                    hintText: 'Enter OTP',
                  ),
                ),
                const SizedBox(height: 30),
                Center(
                  child: ElevatedButton(
                    onPressed: _submitBooking,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: const Text(
                      'Book',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
