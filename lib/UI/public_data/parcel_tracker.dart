
import 'package:flutter/material.dart';
import 'package:weather/services/delivery_track.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DeliveryTrackerScreen extends StatefulWidget {
  @override
  _DeliveryTrackerScreenState createState() => _DeliveryTrackerScreenState();
}

class _DeliveryTrackerScreenState extends State<DeliveryTrackerScreen> {
  TextEditingController _mobileController = TextEditingController();
  bool _loading = false;
  String? _errorMessage;
  Map<String, dynamic>? _info;

  @override
  void initState() {
    super.initState();
    // No need to call getData() here, only call it when needed (e.g., on button press)
  }

  Future<void> getData() async {
    setState(() {
      _loading = true;
      _errorMessage = null;
    });

    final String mobileNumber = _mobileController.text;
    try {
      final data = await TrackParcel.trackCustomerDetails(mobileNumber);
      if (data != null) {
        setState(() {
          _info = data; // Assign the parsed data to _info
        });
      } else {
        setState(() {
          _errorMessage = 'No data received from the API';
        });
      }
    } catch (error) {
      setState(() {
        _errorMessage = 'Failed to load data. Please try again later.';
      });
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  String translateActivityResult(String? result) {
    switch (result) {
      case 'Good':
        return 'ভালো পার্সেল দেওয়া যাবে';
      case 'Average':
        return 'পার্সেল দেওয়া যেতে পারে';
      case 'Bad':
        return 'এডভান্স ছাড়া পার্সেল দেওয়া যাবে না';
      default:
        return 'Unknown';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)?.test??''),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _mobileController,
              decoration: InputDecoration(
                labelText: 'মোবাইল নম্বর লিখুন',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.phone,
              onSubmitted: (_) => getData(),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: getData,
              child: _loading
                  ? CircularProgressIndicator()
                  : Text('অনুসন্ধান করুন'),
            ),
            if (_loading) ...[
              Center(child: CircularProgressIndicator()),
            ] else if (_errorMessage != null) ...[
              SizedBox(height: 20),
              Text('ত্রুটি: $_errorMessage',
                  style: TextStyle(color: Colors.red)),
            ] else if (_info != null) ...[
              Text('Total Parcel Details'),
              SizedBox(height: 20),
              Text('মোবাইল নম্বর: ${_info!['mobile_number']}',
                  style: TextStyle(fontSize: 16)),
              SizedBox(height: 10),
              Text('মোট পার্সেল: ${_info!['total_parcels']}',
                  style: TextStyle(fontSize: 16)),
              Text('মোট ডেলিভারি: ${_info!['total_delivered']}',
                  style: TextStyle(fontSize: 16)),
              Text('মোট বাতিল: ${_info!['total_cancel']}',
                  style: TextStyle(fontSize: 16)),
              Text(
                'মতামত: ${translateActivityResult(_info!['activity_result'])}',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 20),
              Text(
                ' Individual Company কুরিয়ার বিস্তারিত:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              // Display couriers information in a GridView
              Expanded(
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, // Number of columns
                    crossAxisSpacing: 10.0, // Spacing between columns
                    mainAxisSpacing: 10.0, // Spacing between rows
                  ),
                  itemCount: (_info!['couriers'] as List<dynamic>).length,
                  itemBuilder: (context, index) {
                    final courier = _info!['couriers'][index];
                    return Card(
                      elevation: 3,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              courier['courier_name'],
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 10),
                            Text(
                              'Total Parcel: ${courier['total_parcels']}',
                              style: TextStyle(fontSize: 14),
                            ),
                            SizedBox(height: 10),
                            Text(
                              'Total Delivered Parcels: ${courier['total_delivered_parcels']}',
                              style: TextStyle(fontSize: 14),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
