import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show SystemChannels;
import 'package:mobile_number/mobile_number.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:technical_task_app/ui/success_screen.dart';
import '../../app_utils/app_assets.dart';

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
        // Always check when screen opens
        final simCards = await MobileNumber.getSimCards;
        if (simCards != null && simCards.isNotEmpty) {
          _showSimSelectionSheet(simCards);
        } else {
          debugPrint('No SIM cards found.');
        }
      } catch (e) {
        debugPrint('Error fetching SIM data: $e');
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Phone permission is required')),
      );
    }
  }

  /// ✅ FIX: Bottom sheet instead of popup dialog
  void _showSimSelectionSheet(List<SimCard> cards) {
    Future.delayed(Duration.zero, () {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.white,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        builder: (context) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
            child: SafeArea(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 50,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Select Your SIM Number',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  const SizedBox(height: 10),
                  ...cards.map((sim) {
                    final number = sim.number ?? "Unknown Number";
                    final carrier = sim.carrierName ?? "Unknown Carrier";
                    return Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      elevation: 1,
                      child: ListTile(
                        leading: const Icon(
                          Icons.sim_card_rounded,
                          color: Colors.blueAccent,
                        ),
                        title: Text(
                          number,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                          ),
                        ),
                        subtitle: Text(
                          carrier,
                          style: const TextStyle(color: Colors.black54),
                        ),
                        onTap: () {
                          phoneController.text = number;
                          Navigator.pop(context);
                        },
                      ),
                    );
                  }).toList(),
                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text(
                      'Cancel',
                      style: TextStyle(color: Colors.redAccent),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    });
  }

  void _onContinue() {
    final number = phoneController.text.trim();
    if (number.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please enter your number')));
      return;
    }

    FocusScope.of(context).unfocus();

    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => SuccessScreen(number: number)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      resizeToAvoidBottomInset: true, // ✅ Keeps UI visible on keyboard open
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

      // ✅ Dismiss keyboard when tapping outside
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight:
                  MediaQuery.of(context).size.height -
                  MediaQuery.of(context).padding.top -
                  kToolbarHeight,
            ),
            child: IntrinsicHeight(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Spacer(),
                  Image.asset(
                    Assets.mobile,
                    color: const Color.fromARGB(255, 14, 163, 238),
                  ),
                  const SizedBox(height: 10),
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
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const Spacer(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// class LoginScreen extends StatefulWidget {
//   const LoginScreen({super.key});

//   @override
//   State<LoginScreen> createState() => _LoginScreenState();
// }

// class _LoginScreenState extends State<LoginScreen> {
//   final TextEditingController phoneController = TextEditingController();

//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       FocusScope.of(context).unfocus();
//       SystemChannels.textInput.invokeMethod('TextInput.hide');
//     });
//     _requestPermissionsAndFetchSim();
//   }

//   Future<void> _requestPermissionsAndFetchSim() async {
//     final status = await Permission.phone.request();

//     if (status.isGranted) {
//       try {
//         final simCards = await MobileNumber.getSimCards;
//         if (simCards != null && simCards.isNotEmpty) {
//           _showSimSelectionSheet(simCards);
//         } else {
//           debugPrint('No SIM cards found.');
//         }
//       } catch (e) {
//         debugPrint('Error fetching SIM data: $e');
//       }
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Phone permission is required')),
//       );
//     }
//   }

//   void _showSimSelectionSheet(List<SimCard> cards) {
//     Future.delayed(Duration.zero, () {
//       showModalBottomSheet(
//         context: context,
//         isScrollControlled: true,
//         backgroundColor: Colors.white,
//         shape: const RoundedRectangleBorder(
//           borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//         ),
//         builder: (context) {
//           return Padding(
//             padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
//             child: SafeArea(
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   Container(
//                     width: 50,
//                     height: 4,
//                     decoration: BoxDecoration(
//                       color: Colors.grey.shade300,
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                   ),
//                   const SizedBox(height: 10),
//                   const Text(
//                     'Select Your Phone Number',
//                     style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
//                   ),
//                   const SizedBox(height: 10),
//                   ...cards.map((sim) {
//                     final number = sim.number ?? "Unknown Number";
//                     final carrier = sim.carrierName ?? "Unknown Carrier";
//                     return Card(
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                       margin: const EdgeInsets.symmetric(vertical: 6),
//                       elevation: 1,
//                       child: ListTile(
//                         leading: const Icon(
//                           Icons.sim_card_rounded,
//                           color: Colors.blueAccent,
//                         ),
//                         title: Text(
//                           number,
//                           style: const TextStyle(
//                             fontWeight: FontWeight.w600,
//                             fontSize: 15,
//                           ),
//                         ),
//                         subtitle: Text(
//                           carrier,
//                           style: const TextStyle(color: Colors.black54),
//                         ),
//                         onTap: () {
//                           phoneController.text = number;
//                           Navigator.pop(context);
//                         },
//                       ),
//                     );
//                   }).toList(),
//                   const SizedBox(height: 8),
//                   TextButton(
//                     onPressed: () => Navigator.pop(context),
//                     child: const Text(
//                       'Cancel',
//                       style: TextStyle(color: Colors.redAccent),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           );
//         },
//       );
//     });
//   }

//   void _onContinue() async {
//     final number = phoneController.text.trim();
//     if (number.isEmpty) {
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(const SnackBar(content: Text('Please enter your number')));
//       return;
//     }

//     FocusScope.of(context).unfocus();
//     await Future.delayed(const Duration(milliseconds: 100));
//     await Navigator.push(
//       context,
//       MaterialPageRoute(builder: (_) => SuccessScreen(number: number)),
//     );
//     if (mounted) {
//       FocusScope.of(context).unfocus();
//       SystemChannels.textInput.invokeMethod('TextInput.hide');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//     return Scaffold(
//       resizeToAvoidBottomInset: true,
//       backgroundColor: Colors.grey.shade100,
//       appBar: AppBar(
//         title: const Text(
//           'Login',
//           style: TextStyle(fontWeight: FontWeight.w600),
//         ),
//         centerTitle: true,
//         backgroundColor: theme.colorScheme.primary,
//         foregroundColor: Colors.white,
//       ),

//       body: GestureDetector(
//         onTap: () => FocusScope.of(context).unfocus(),
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.all(24.0),
//           child: ConstrainedBox(
//             constraints: BoxConstraints(
//               minHeight:
//                   MediaQuery.of(context).size.height -
//                   MediaQuery.of(context).padding.top -
//                   kToolbarHeight,
//             ),
//             child: IntrinsicHeight(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   const Spacer(),
//                   Image.asset(
//                     Assets.mobile,
//                     color: const Color.fromARGB(255, 14, 163, 238),
//                   ),
//                   const SizedBox(height: 10),
//                   const Text(
//                     'Enter your mobile number',
//                     style: TextStyle(
//                       fontSize: 18,
//                       fontWeight: FontWeight.w600,
//                       color: Colors.black87,
//                     ),
//                   ),
//                   const SizedBox(height: 30),
//                   TextField(
//                     controller: phoneController,
//                     keyboardType: TextInputType.phone,
//                     decoration: InputDecoration(
//                       hintText: 'Mobile number',
//                       prefixIcon: const Icon(Icons.phone_rounded),
//                       filled: true,
//                       fillColor: Colors.white,
//                       contentPadding: const EdgeInsets.symmetric(
//                         horizontal: 20,
//                         vertical: 14,
//                       ),
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 25),
//                   SizedBox(
//                     width: double.infinity,
//                     child: ElevatedButton(
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.blueAccent,
//                         foregroundColor: Colors.white,
//                         padding: const EdgeInsets.symmetric(vertical: 14),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                       ),
//                       onPressed: _onContinue,
//                       child: const Text(
//                         'Continue',
//                         style: TextStyle(
//                           fontSize: 16,
//                           fontWeight: FontWeight.w600,
//                         ),
//                       ),
//                     ),
//                   ),
//                   const Spacer(),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
