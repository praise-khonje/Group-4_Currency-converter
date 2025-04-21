import 'package:flutter/material.dart';
import 'news_feed.dart';
import 'settings.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

Future<Map<String, dynamic>> fetchConversionRates() async {
  const String apiUrl =
      'https://v6.exchangerate-api.com/v6/c8d2092077c56bcb81d07b7f/latest/USD';
  try {
    final response = await http.get(Uri.parse(apiUrl));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['conversion_rates'] != null) {
        return data['conversion_rates'];
      } else {
        throw Exception('Rates not found in response.');
      }
    } else {
      throw Exception(
          'Failed to fetch rates. Status code: ${response.statusCode}');
    }
  } catch (e) {
    SnackBar(
      content: SnackBar(content: Text('Error fetching rates: $e')),
    );
    throw Exception('Error fetching rates: $e');
  }
}

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  String fromCurrency = 'USD';
  String toCurrency = 'MWK';
  String result = '';

  final Map<String, String> currencies = {
    'USD': '🇺🇸',
    'EUR': '🇪🇺',
    'MWK': '🇲🇼',
    'ZAR': '🇿🇦',
    'GBP': '🇬🇧',
    'JPY': '🇯🇵',
    'CNY': '🇨🇳',
    'AUD': '🇦🇺',
    'CAD': '🇨🇦',
    'INR': '🇮🇳',
    'NGN': '🇳🇬',
    'KES': '🇰🇪',
    'BRL': '🇧🇷',
    'CHF': '🇨🇭',
  };

  final TextEditingController _amountController = TextEditingController();

  List<DropdownMenuItem<String>> _buildCurrencyDropdownItems() {
    return currencies.entries
        .map((entry) => DropdownMenuItem(
              value: entry.key,
              child: Row(
                children: [
                  Text(entry.value, style: const TextStyle(fontSize: 20)),
                  const SizedBox(width: 8),
                  Text(entry.key),
                ],
              ),
            ))
        .toList();
  }

  void _calculateConversion() async {
    if (_amountController.text.isNotEmpty) {
      double amount = double.tryParse(_amountController.text) ?? 0.0;

      if (amount <= 0) {
        setState(() {
          result = 'Invalid amount entered.';
        });
        return;
      }

      try {
        Map<String, dynamic> rates = await fetchConversionRates();

        if (rates.containsKey(toCurrency) && rates.containsKey(fromCurrency)) {
          double conversionRate = rates[toCurrency]! / rates[fromCurrency]!;
          setState(() {
            result = (amount * conversionRate).toStringAsFixed(2);
          });
        } else {
          setState(() {
            result = 'Conversion rate not available.';
          });
        }
      } catch (e) {
        setState(() {
          result = 'Error fetching rates: $e';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          // Input Card
          Card(
            elevation: 4,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          value: fromCurrency,
                          onChanged: (value) {
                            setState(() {
                              fromCurrency = value!;
                            });
                          },
                          items: _buildCurrencyDropdownItems(),
                          decoration: const InputDecoration(
                            labelText: 'From',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.swap_horiz,
                            size: 32, color: Colors.black),
                        onPressed: () {
                          setState(() {
                            String temp = fromCurrency;
                            fromCurrency = toCurrency;
                            toCurrency = temp;
                          });
                        },
                      ),
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          value: toCurrency,
                          onChanged: (value) {
                            setState(() {
                              toCurrency = value!;
                            });
                          },
                          items: _buildCurrencyDropdownItems(),
                          decoration: const InputDecoration(
                            labelText: 'To',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _amountController,
                    decoration: const InputDecoration(
                      labelText: 'Enter Amount',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _calculateConversion,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 20),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                      backgroundColor: Colors.blue.shade700,
                      foregroundColor: Colors.black,
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.calculate),
                        SizedBox(width: 8),
                        Text('Convert'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Result Card
          Card(
            elevation: 4,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Text(
                    'Converted Amount',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    result.isEmpty
                        ? 'No Conversion Yet'
                        : '$result $toCurrency',
                    style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          // Styled Container for Stock and Exchange Info
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(100),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.account_balance_wallet,
                        color: Colors.black, size: 30),
                    SizedBox(width: 10),
                    Text(
                      'Malawian Exchange \n Bureau & Stock Data',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Text(
                  'The Malawian Kwacha (MWK) is primarily traded against major currencies such as USD, ZAR, and EUR. Current rates are as follows (assumed):\n\n'
                  '1 USD = 1160 MWK\n'
                  '1 EUR = 1250 MWK\n'
                  '1 ZAR = 75 MWK\n\n'
                  'Stock Market (Assumed Data):\n'
                  '- Illovo Sugar Plc: MWK 450/share\n'
                  '- National Bank of Malawi: MWK 1050/share\n'
                  '- Airtel Malawi: MWK 85/share\n\n'
                  'These rates and stock data are sourced from reliable financial institutions.',
                  style: TextStyle(fontSize: 16, color: Colors.black),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedTabIndex = 0;

  final List<Widget> _tabs = [
    const HomeTab(),
    const NewsFeed(),
    SettingsPage(
  currentLanguage: 'English',
  onLanguageChanged: (newLang) {
  },
),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('Currency App'), backgroundColor: Colors.white),
      body: _tabs[_selectedTabIndex],
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedTabIndex,
          onTap: (index) {
            setState(() {
              _selectedTabIndex = index;
            });
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.article),
              label: 'News Feed',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: 'Settings',
            ),
          ],
          selectedItemColor: Colors.black,
          unselectedItemColor: Colors.deepPurple,
          backgroundColor: Colors.white),
    );
  }
}
