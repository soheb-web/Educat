import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:educationapp/coreFolder/utils/globalroute.key.dart';
import 'package:flutter/material.dart';

class NoInternetScreen extends StatefulWidget {
  @override
  State<NoInternetScreen> createState() => _NoInternetScreenState();
}

class _NoInternetScreenState extends State<NoInternetScreen> {
  Future<void> _checkAgain(BuildContext context) async {
    // Show a loading indicator temporarily (optional but good practice)
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Checking connection..."),
        duration: Duration(milliseconds: 1000),
      ),
    );

    final results = await Connectivity().checkConnectivity();

    // Check if the results list *does not* contain ConnectivityResult.none
    final hasInternet = !results.contains(ConnectivityResult.none);

    if (hasInternet) {
      // if (navigatorKey.currentState?.canPop() ?? false) {
      //   navigatorKey.currentState?.pop();
      // }
      Future.delayed(
        const Duration(
            seconds:
                1), // Delay to ensure the pop happens after the route is fully built
        () {
          if (navigatorKey.currentState?.canPop() == true) {
            navigatorKey.currentState?.pop();
          }
        },
      );
      // You can also add a success message here
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Connection restored!"),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      // Still no internet
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Still offline. Please check network settings."),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1B1B1B), // DARK BG
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon with Glow
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.05),
                boxShadow: [
                  BoxShadow(
                    color: Color(0xff008080).withOpacity(0.3),
                    blurRadius: 20,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Icon(
                Icons.wifi_off,
                size: 100,
                color: Colors.blueAccent,
              ),
            ),

            const SizedBox(height: 30),

            // Title
            const Text(
              'No Internet Connection',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),

            const SizedBox(height: 12),

            // Subtitle
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 40),
              child: Text(
                'It seems you are offline.\nPlease check your connection and try again.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  height: 1.5,
                  color: Colors.white70,
                ),
              ),
            ),

            const SizedBox(height: 40),

            // Retry Button
            ElevatedButton(
              onPressed: () => _checkAgain(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xff008080),
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 8,
              ),
              child: const Text(
                'Retry',
                style: TextStyle(
                  fontSize: 18,
                  letterSpacing: 0.5,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
