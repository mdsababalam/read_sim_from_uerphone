import 'package:flutter/material.dart';
import 'package:mobile_number/mobile_number.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:technical_task_app/app_utils/app_assets.dart';
import 'package:technical_task_app/ui/success_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _requestPermissionsAndFetchSim();
  }

  Future<void> _requestPermissionsAndFetchSim() async {
    final status = await Permission.phone.request();

    if (status.isGranted) {
      try {
        // ✅ Initialize the plugin
        MobileNumber.listenPhonePermission((isPermissionGranted) async {
          if (isPermissionGranted) {
            final simCards = await MobileNumber.getSimCards;
            if (simCards!.isNotEmpty) {
              _showSimSelectionDialog(simCards);
            } else {
              debugPrint('No SIM cards found.');
            }
          }
        });
      } catch (e) {
        debugPrint('Error fetching SIM data: $e');
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Phone permission is required')),
      );
    }
  }

  void _showSimSelectionDialog(List<SimCard> cards) {
    Future.delayed(Duration.zero, () {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            title: const Text(
              'Select Your SIM Number',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: cards.map((sim) {
                final number =
                    sim.number ?? "Unknown Number"; // ✅ correct property
                final carrier = sim.carrierName ?? "Unknown Carrier";
                return ListTile(
                  leading: Icon(Icons.call),
                  title: Text(number),
                  subtitle: Text(carrier),
                  onTap: () {
                    phoneController.text = number;
                    Navigator.pop(context);
                  },
                );
              }).toList(),
            ),
          );
        },
      );
    });
  }

  void _onContinue() {
    final number = phoneController.text.trim();
    if (number.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select or enter your number')),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => SuccessScreen(number: number)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text(
          'Login',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Spacer(),
            Image.asset(
              Assets.mobile,
              color: const Color.fromARGB(255, 14, 163, 238),
            ),
            // const SizedBox(height: 10),
            const Text(
              'Enter your mobile number',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 30),
            TextField(
              controller: phoneController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                hintText: 'Mobile number',
                prefixIcon: const Icon(Icons.phone_rounded),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 14,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 25),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: _onContinue,
                child: const Text(
                  'Continue',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
