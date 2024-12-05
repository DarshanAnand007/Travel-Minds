import 'dart:async';
import 'package:flutter/material.dart';
import 'login.dart';

void main() {
  runApp(TravelMindsApp());
}

class TravelMindsApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Travel Minds',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: OnboardingScreen(),
    );
  }
}

class OnboardingScreen extends StatefulWidget {
  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  Timer? _timer;

  final List<Map<String, String>> pages = [
    {
      'image': 'assets/images/11.jpeg', // Local asset
      'title': 'Explore Places, meet your own and start your journey',
    },
    {
      'image': 'assets/images/1.jpg', // Local asset
      'title': 'Enjoy Historic, Holy Places',
    },
    {
      'image': 'assets/images/2.jpg',  // Placeholder URL
      'title': 'Feel like you are in Heaven',
    },
    {
      'image': 'https://via.placeholder.com/400x800', // Placeholder URL
      'title': 'Meet new people, Understand new Perspective',
    },
  ];

  @override
  void initState() {
    super.initState();

    // Set a timer to auto-swipe every 3 seconds
    _timer = Timer.periodic(Duration(seconds: 3), (timer) {
      if (_currentPage < pages.length - 1) {
        _currentPage++;
      } else {
        _currentPage = 0; // Reset to the first page
      }
      _pageController.animateToPage(
        _currentPage,
        duration: Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _timer?.cancel(); // Cancel the timer when the widget is disposed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            itemCount: pages.length,
            itemBuilder: (context, index) {
              return Stack(
                fit: StackFit.expand,
                children: [
                  pages[index]['image']!.startsWith('assets/')
                      ? Image.asset(
                          pages[index]['image']!,
                          fit: BoxFit.cover,
                        )
                      : Image.network(
                          pages[index]['image']!,
                          fit: BoxFit.cover,
                        ),
                  Container(
                    color: Colors.black.withOpacity(0.4),
                  ),
                  Positioned(
                    top: MediaQuery.of(context).size.height * 0.4,
                    left: 20,
                    right: 20,
                    child: Text(
                      pages[index]['title']!,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              );
            },
          ),
          Positioned(
  bottom: 60,
  left: 0,
  right: 0,
  child: Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: List.generate(
      pages.length,
      (index) => AnimatedContainer(
        duration: Duration(milliseconds: 300),
        margin: EdgeInsets.symmetric(horizontal: 4),
        width: _currentPage == index ? 14 : 10, // Increased width for active dot
        height: _currentPage == index ? 14 : 10, // Increased height for all dots
        decoration: BoxDecoration(
          color: _currentPage == index ? Colors.white : Colors.white54,
          borderRadius: BorderRadius.circular(8), // Adjust for circular shape
        ),
      ),
    ),
  ),
)
,
          Positioned(
            bottom: 16,
            left: 16,
            right: 16,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                );
              },
              child: Text(
                'Login',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
