import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class NewsFeed extends StatefulWidget {
  const NewsFeed({super.key});

  @override
  _NewsFeedState createState() => _NewsFeedState();
}

class _NewsFeedState extends State<NewsFeed> {
  Map<String, dynamic>? forexRates;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchExchangeRates();
  }

  Future<void> fetchExchangeRates() async {

    const apiUrl =
        'https://v6.exchangerate-api.com/v6/c8d2092077c56bcb81d07b7f/latest/MWK'; // Example API URL

    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          forexRates = data['conversion_rates'];
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load exchange rates');
      }
    } catch (e) {
      print('Error fetching data: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Section
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Icon(Icons.currency_exchange, size: 30, color: Colors.blueAccent),
                  SizedBox(width: 10),
                  Text(
                    'Latest Forex Rates',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            isLoading
                ? const Center(child: CircularProgressIndicator())
                : forexRates == null
                ? const Center(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Text('Failed to load forex rates. Please try again later.'),
              ),
            )
                : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 5,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Left Column (3 rates)
                      Expanded(
                        child: Column(
                          children: [
                            ListTile(
                              leading: Icon(Icons.attach_money, color: Colors.green),
                              title: const Text('USD/MWK'),
                              subtitle: Text(
                                  'Exchange Rate: ${((1/forexRates?['USD']).ceil()).toString() ?? 'N/A'} MWK'),
                            ),
                            const Divider(),
                            ListTile(
                              leading: Icon(Icons.euro, color: Colors.blue),
                              title: const Text('EUR/MWK'),
                              subtitle: Text(
                                  'Exchange Rate: ${((1/forexRates?['EUR']).ceil()).toString() ?? 'N/A'} MWK'),
                            ),
                            const Divider(),
                            ListTile(
                              leading: Text(
                                '£',
                                style: TextStyle(
                                  fontSize: 24,
                                  color: Colors.purple,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              title: const Text('GBP/MWK'),
                              subtitle: Text(
                                  'Exchange Rate: ${((1/forexRates?['GBP']).ceil()).toString() ?? 'N/A'} MWK'),
                            ),
                          ],
                        ),
                      ),
                      const VerticalDivider(width: 20, thickness: 1),
                      // Right Column (3 rates)
                      Expanded(
                        child: Column(
                          children: [
                            ListTile(
                              leading: Text(
                                'R',
                                style: TextStyle(
                                  fontSize: 24,
                                  color: Colors.orange,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              title: const Text('ZAR/MWK'),
                              subtitle: Text(
                                  'Exchange Rate: ${((1 / forexRates?['ZAR']).ceil()).toString() ?? 'N/A'} MWK'),
                            ),

                            const Divider(),
                            ListTile(
                              leading: Text(
                                'Z\$',
                                style: TextStyle(
                                  fontSize: 24,
                                  color: Colors.brown,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              title: const Text('ZWL/MWK'),
                              subtitle: Text(
                                  'Exchange Rate: ${((1 / forexRates?['ZWL']).ceil()).toString() ?? 'N/A'} MWK'),
                            ),

                            const Divider(),
                            ListTile(
                              leading: Icon(Icons.currency_yuan, color: Colors.pink),
                              title: const Text('CNY/MWK'),
                              subtitle: Text(
                                  'Exchange Rate: ${((1/forexRates?['CNY']).ceil()).toString() ?? 'N/A'} MWK'),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            // News Section
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Icon(Icons.article, size: 30, color: Colors.blueAccent),
                  SizedBox(width: 10),
                  Text(
                    'Forex News & Updates',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            // News Items
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  ListTile(
                    leading: Icon(Icons.trending_up, color: Colors.red),
                    title: Text('MWK strengthens against USD'),
                    subtitle: Text('The Malawi Kwacha saw a 3% improvement this week.'),
                  ),
                  Divider(),
                  ListTile(
                    leading: Icon(Icons.trending_down, color: Colors.orange),
                    title: Text('EUR rates decline slightly'),
                    subtitle: Text('EUR to MWK rates dropped by 2% due to economic factors.'),
                  ),
                  Divider(),
                  ListTile(
                    leading: Icon(Icons.info, color: Colors.blue),
                    title: Text('Forex Bureau Opening Hours'),
                    subtitle: Text('Most Forex bureaus operate from 8 AM to 5 PM on weekdays.'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
