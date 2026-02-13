import 'package:flutter/material.dart';

/// Responsive Navigation Screen
/// Demonstrates adaptive UI using MediaQuery and LayoutBuilder
/// - Shows NavigationBar (bottom) for screens < 600px
/// - Shows NavigationRail (side) for screens >= 600px
class ResponsiveNavigationScreen extends StatefulWidget {
  const ResponsiveNavigationScreen({super.key});

  @override
  State<ResponsiveNavigationScreen> createState() =>
      _ResponsiveNavigationScreenState();
}

class _ResponsiveNavigationScreenState
    extends State<ResponsiveNavigationScreen> {
  int _selectedIndex = 0;

  // Navigation destinations shared across both UI variants
  final List<NavigationDestination> _destinations = const [
    NavigationDestination(
      icon: Icon(Icons.home_outlined),
      selectedIcon: Icon(Icons.home),
      label: 'Home',
    ),
    NavigationDestination(
      icon: Icon(Icons.explore_outlined),
      selectedIcon: Icon(Icons.explore),
      label: 'Explore',
    ),
    NavigationDestination(
      icon: Icon(Icons.favorite_outline),
      selectedIcon: Icon(Icons.favorite),
      label: 'Favorites',
    ),
    NavigationDestination(
      icon: Icon(Icons.person_outline),
      selectedIcon: Icon(Icons.person),
      label: 'Profile',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    // Get screen width using MediaQuery.sizeOf (recommended approach)
    final screenWidth = MediaQuery.sizeOf(context).width;
    final isLargeScreen = screenWidth >= 600;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Responsive Navigation Demo'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          // Display current screen width
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: Text(
                'Width: ${screenWidth.toStringAsFixed(0)}px',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
      body: Row(
        children: [
          // NavigationRail for large screens (>= 600px)
          if (isLargeScreen)
            NavigationRail(
              selectedIndex: _selectedIndex,
              onDestinationSelected: (index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
              labelType: NavigationRailLabelType.all,
              destinations: _destinations
                  .map(
                    (dest) => NavigationRailDestination(
                      icon: dest.icon,
                      selectedIcon: dest.selectedIcon,
                      label: Text(dest.label),
                    ),
                  )
                  .toList(),
            ),

          // Vertical divider
          if (isLargeScreen) const VerticalDivider(thickness: 1, width: 1),

          // Main content area
          Expanded(child: _buildContent(screenWidth, isLargeScreen)),
        ],
      ),
      // NavigationBar for small screens (< 600px)
      bottomNavigationBar: !isLargeScreen
          ? NavigationBar(
              selectedIndex: _selectedIndex,
              onDestinationSelected: (index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
              destinations: _destinations,
            )
          : null,
    );
  }

  Widget _buildContent(double screenWidth, bool isLargeScreen) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Current page indicator
          _buildPageHeader(),
          const SizedBox(height: 32),

          // // MediaQuery example
          // _buildMediaQueryExample(screenWidth, isLargeScreen),
          // const SizedBox(height: 32),

          // // LayoutBuilder example
          // _buildLayoutBuilderExample(),
          // const SizedBox(height: 32),

          // Responsive grid demo
          _buildResponsiveGrid(),
        ],
      ),
    );
  }

  Widget _buildPageHeader() {
    final pages = ['Home', 'Explore', 'Favorites', 'Profile'];
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                _destinations[_selectedIndex].selectedIcon ??
                    _destinations[_selectedIndex].icon,
                const SizedBox(width: 12),
                Text(
                  pages[_selectedIndex],
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'This is the ${pages[_selectedIndex]} page content',
              style: Theme.of(
                context,
              ).textTheme.bodyLarge?.copyWith(color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMediaQueryExample(double screenWidth, bool isLargeScreen) {
    return Card(
      color: Colors.blue.shade50,
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.phone_android, color: Colors.blue.shade700),
                const SizedBox(width: 12),
                Text(
                  'MediaQuery.sizeOf Example',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.blue.shade900,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildInfoRow(
                    'Screen Width',
                    '${screenWidth.toStringAsFixed(2)}px',
                  ),
                  const Divider(),
                  _buildInfoRow(
                    'Screen Type',
                    isLargeScreen ? 'Large (≥ 600px)' : 'Small (< 600px)',
                  ),
                  const Divider(),
                  _buildInfoRow(
                    'Navigation Type',
                    isLargeScreen ? 'NavigationRail' : 'NavigationBar',
                  ),
                  const Divider(),
                  _buildInfoRow('Breakpoint', '600px (Material Guidelines)'),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Text(
              '💡 Resize the browser window to see the navigation switch!',
              style: TextStyle(
                fontStyle: FontStyle.italic,
                color: Colors.blue.shade700,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLayoutBuilderExample() {
    return Card(
      color: Colors.green.shade50,
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.view_compact, color: Colors.green.shade700),
                const SizedBox(width: 12),
                Text(
                  'LayoutBuilder Example',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.green.shade900,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            LayoutBuilder(
              builder: (context, constraints) {
                // Use LayoutBuilder to get parent widget constraints
                final maxWidth = constraints.maxWidth;
                final isWide = maxWidth >= 600;

                return Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildInfoRow(
                        'Available Width',
                        '${maxWidth.toStringAsFixed(2)}px',
                      ),
                      const Divider(),
                      _buildInfoRow(
                        'Min Width',
                        '${constraints.minWidth.toStringAsFixed(2)}px',
                      ),
                      const Divider(),
                      _buildInfoRow(
                        'Max Width',
                        '${constraints.maxWidth.toStringAsFixed(2)}px',
                      ),
                      const Divider(),
                      _buildInfoRow(
                        'Layout Type',
                        isWide ? 'Wide Layout' : 'Narrow Layout',
                      ),
                      const SizedBox(height: 16),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: isWide
                              ? Colors.green.shade100
                              : Colors.orange.shade100,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          isWide
                              ? '✓ This content area is wide enough for expanded view'
                              : '⚠ This content area uses compact view',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: isWide
                                ? Colors.green.shade900
                                : Colors.orange.shade900,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            const SizedBox(height: 12),
            Text(
              '💡 LayoutBuilder provides constraints from parent widget, not entire screen',
              style: TextStyle(
                fontStyle: FontStyle.italic,
                color: Colors.green.shade700,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResponsiveGrid() {
    return Card(
      color: Colors.purple.shade50,
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.grid_view, color: Colors.purple.shade700),
                const SizedBox(width: 12),
                Text(
                  'Responsive Grid',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.purple.shade900,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            LayoutBuilder(
              builder: (context, constraints) {
                // Calculate columns based on available width
                final width = constraints.maxWidth;
                final columns = width >= 1200
                    ? 4
                    : width >= 800
                    ? 3
                    : width >= 600
                    ? 2
                    : 1;

                return Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        children: [
                          _buildInfoRow(
                            'Available Width',
                            '${width.toStringAsFixed(0)}px',
                          ),
                          const Divider(),
                          _buildInfoRow('Grid Columns', '$columns'),
                          // const Divider(),
                          // _buildInfoRow(
                          //   'Breakpoints',
                          //   '1200px (4) | 800px (3) | 600px (2) | <600px (1)',
                          // ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: columns,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        childAspectRatio: 1.5,
                      ),
                      itemCount: 8,
                      itemBuilder: (context, index) {
                        return Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.purple.shade300,
                                Colors.purple.shade500,
                              ],
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.image,
                                  color: Colors.white,
                                  size: 32,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Item ${index + 1}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}
