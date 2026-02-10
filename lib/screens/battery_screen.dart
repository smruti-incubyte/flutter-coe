import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class BatteryScreen extends StatefulWidget {
  const BatteryScreen({super.key});

  @override
  State<BatteryScreen> createState() => _BatteryScreenState();
}

class _BatteryScreenState extends State<BatteryScreen> {
  static const platform = MethodChannel('com.example.flutter_coe/battery');
  
  String _batteryLevel = 'Unknown';
  Map<String, dynamic>? _batteryInfo;

  Future<void> _getBatteryLevel() async {
    String batteryLevel;
    try {
      final int result = await platform.invokeMethod('getBatteryLevel');
      batteryLevel = 'Battery level: $result%';
    } on PlatformException catch (e) {
      batteryLevel = "Failed to get battery level: '${e.message}'.";
    }

    setState(() {
      _batteryLevel = batteryLevel;
    });
  }

  Future<void> _getBatteryInfo() async {
    try {
      final Map<dynamic, dynamic> result = await platform.invokeMethod('getBatteryInfo');
      setState(() {
        _batteryInfo = Map<String, dynamic>.from(result);
      });
    } on PlatformException catch (e) {
      setState(() {
        _batteryInfo = null;
        _batteryLevel = "Failed to get battery info: '${e.message}'.";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Battery Information'),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.battery_charging_full,
                size: 80,
                color: Colors.green,
              ),
              const SizedBox(height: 20),
              Text(
                _batteryLevel,
                style: Theme.of(context).textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              ElevatedButton.icon(
                onPressed: _getBatteryLevel,
                icon: const Icon(Icons.battery_std),
                label: const Text('Get Battery Level'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: _getBatteryInfo,
                icon: const Icon(Icons.info_outline),
                label: const Text('Get Detailed Battery Info'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                ),
              ),
              const SizedBox(height: 30),
              if (_batteryInfo != null) ...[
                Card(
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Battery Details',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const Divider(),
                        _buildInfoRow('Battery Level', '${_batteryInfo!['batteryLevel']}%'),
                        _buildInfoRow('Charging', _batteryInfo!['isCharging'] ? 'Yes' : 'No'),
                        _buildInfoRow('Charging Source', '${_batteryInfo!['chargingSource']}'),
                        _buildInfoRow('Battery Health', '${_batteryInfo!['batteryHealth']}'),
                        _buildInfoRow('Temperature', '${_batteryInfo!['temperature']}°C'),
                        _buildInfoRow('Voltage', '${_batteryInfo!['voltage']} mV'),
                      ],
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(value),
        ],
      ),
    );
  }
}
