import 'package:chain_guard/src/common_widgets/toast.dart';
import 'package:flutter/material.dart';

class Issue {
  final String name;
  final IconData icon;

  Issue({required this.name, required this.icon});
}

class ReportIssuePage extends StatefulWidget {
  @override
  _ReportIssuePageState createState() => _ReportIssuePageState();
}

class _ReportIssuePageState extends State<ReportIssuePage> {
  String selectedIssue = ''; // To store the selected issue name

  List<Issue> issues = [
    Issue(name: 'Select', icon: Icons.help),
    Issue(name: 'Tire blowout', icon: Icons.tire_repair),
    Issue(name: 'Received damaged goods', icon: Icons.warning),
    Issue(name: 'Package loss', icon: Icons.shopping_bag),
    Issue(name: 'Adverse weather conditions', icon: Icons.cloudy_snowing),
    Issue(name: 'Other', icon: Icons.info),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Report An Issue'),
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            icon: Icon(
              Icons.flag_outlined, // Replace with the icon you want to use
              color: Colors.red, // Set the color of the icon to red
            ),
            onPressed: null, // Set onPressed to null to make the icon non-clickable
          ),

        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 10),
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Choose the Issue you are experiencing",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    DropdownButtonFormField<Issue>(
                      value: issues[0], // Initial value
                      onChanged: (value) {
                        setState(() {
                          selectedIssue = value!.name; // Store the name of the selected issue
                        });
                      },
                      items: issues.map((issue) {
                        return DropdownMenuItem<Issue>(
                          value: issue,
                          child: Row(
                            children: [
                              Icon(issue.icon),
                              SizedBox(width: 10),
                              Text(issue.name),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                    SizedBox(height: 60),
                    ElevatedButton(
                      onPressed: () {
                        showToast(message: "Issue sent to help center");
                      },
                      child: Text(
                        'Send Issue',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 20),
            Card(
              color: Colors.black12,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Text(
                        'Aid Center',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Contact:',
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'support@example.com',
                      textAlign: TextAlign.start,
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Phone Number:',
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '0123 456 7890',
                      textAlign: TextAlign.start,
                    ),    SizedBox(height: 10),
                    Text(
                      'Address:',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.start,
                    ),
                    Text(
                      'abc cdf cer',
                      textAlign: TextAlign.start,
                    ),
                  ],
                ),
              ),
            ),


          ],
        ),
      ),
    );
  }
}


