import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  final PageController _pageController = PageController(viewportFraction: 0.85);

  final List<Map<String, String>> _categories = [
    {'title': 'Mountains', 'image': 'assets/images/m.png'},
    {'title': 'Nature', 'image': 'assets/images/c.png'},
    {'title': 'Temples', 'image': 'assets/images/t.png'},
    {'title': 'Explore', 'image': 'assets/images/r.png'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Icon(Icons.menu, color: Colors.black),
        title: TextField(
          decoration: InputDecoration(
            hintText: 'Search your destination',
            prefixIcon: Icon(Icons.search, color: Colors.black),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide.none,
            ),
            fillColor: Colors.grey[200],
            filled: true,
          ),
        ),
      ),
      body: Column(
        children: [
          SizedBox(height: 20),
          // Tabs for Hotels, Tickets, Packages
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildTabItem('Hotels', isActive: _currentIndex == 0),
              _buildTabItem('Tickets', isActive: _currentIndex == 1),
              _buildTabItem('Packages', isActive: _currentIndex == 2),
            ],
          ),
          SizedBox(height: 26),
          Expanded(
            child: Stack(
              children: [
                // Image Carousel
                PageView.builder(
                  controller: _pageController,
                  itemCount: _categories.length,
                  onPageChanged: (index) {
                    setState(() {
                      _currentIndex = index;
                    });
                  },
                  itemBuilder: (context, index) {
                    return AnimatedBuilder(
                      animation: _pageController,
                      builder: (context, child) {
                        double value = 1.0;
                        if (_pageController.position.haveDimensions) {
                          value = _pageController.page! - index;
                          value = (1 - (value.abs() * 0.2)).clamp(0.9, 1.0);
                        }
                        return Transform.scale(
                          scale: value,
                          child: child,
                        );
                      },
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 26, vertical: 45),
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(20),
                          image: DecorationImage(
                            image: AssetImage(_categories[index]['image']!),
                            fit: BoxFit.cover,
                          ),
                        ),
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: Padding(
                            padding: EdgeInsets.only(bottom: 10),
                            child: Text(
                              _categories[index]['title']!,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                shadows: [
                                  Shadow(
                                    color: Colors.black54,
                                    offset: Offset(1, 1),
                                    blurRadius: 4,
                                  )
                                ],
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
                // Left Arrow
                if (_currentIndex > 0)
                  Positioned(
                    left: 15,
                    top: MediaQuery.of(context).size.height * 0.35,
                    child: IconButton(
                      icon: Icon(Icons.arrow_back_ios, color: Colors.blueAccent, size: 28),
                      onPressed: () {
                        _pageController.previousPage(
                          duration: Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      },
                    ),
                  ),
                // Right Arrow
                if (_currentIndex < _categories.length - 1)
                  Positioned(
                    right: 15,
                    top: MediaQuery.of(context).size.height * 0.35,
                    child: IconButton(
                      icon: Icon(Icons.arrow_forward_ios, color: Colors.blueAccent, size: 28),
                      onPressed: () {
                        _pageController.nextPage(
                          duration: Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      },
                    ),
                  ),
              ],
            ),
          ),
          // Bottom Tabs (Navigation Bar)
          Container(
            height: 80,
            color: Colors.white,
            child: Column(
              children: [
                Divider(color: Colors.grey[300], thickness: 1),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildBottomNavigationBarItem(
                      icon: Icons.explore,
                      label: 'Explore',
                      isSelected: true,
                    ),
                    _buildBottomNavigationBarItem(
                      icon: Icons.bookmark,
                      label: 'Saved',
                      isSelected: false,
                    ),
                    _buildBottomNavigationBarItem(
                      icon: Icons.notifications,
                      label: 'Updates',
                      isSelected: false,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabItem(String label, {required bool isActive}) {
    return GestureDetector(
      onTap: () {
        setState(() {
          // Update _currentIndex based on the tapped tab
          if (label == 'Hotels') {
            _currentIndex = 0;
          } else if (label == 'Tickets') {
            _currentIndex = 1;
          } else if (label == 'Packages') {
            _currentIndex = 2;
          }
        });
      },
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(vertical: 6, horizontal: 12),
            decoration: isActive
                ? BoxDecoration(
                    color: Colors.blue[50],
                    borderRadius: BorderRadius.circular(20),
                  )
                : null,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: isActive ? Colors.black : Colors.grey,
              ),
            ),
          ),
          if (isActive)
            Container(
              width: 40,
              height: 3,
              margin: EdgeInsets.only(top: 5),
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildBottomNavigationBarItem({
    required IconData icon,
    required String label,
    required bool isSelected,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: isSelected ? Colors.purple : Colors.grey),
        Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.purple : Colors.grey,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}
