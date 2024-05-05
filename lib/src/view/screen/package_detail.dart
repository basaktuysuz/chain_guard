import 'package:flutter/material.dart';

class PackageDetailsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Package Details'),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            buildPackageCard('Package 1', 'Content 1', '5 kg', 'ID1', context),
            buildPackageCard('Package 2', 'Content 2', '10 kg', 'ID2', context),
            buildPackageCard('Package 3', 'Content 3', '8 kg', 'ID3', context),
            buildPackageCard('Package 3', 'Content 3', '8 kg', 'ID3', context),
            buildPackageCard('Package 3', 'Content 3', '8 kg', 'ID3', context),
            buildPackageCard('Package 3', 'Content 3', '8 kg', 'ID3', context),
            buildPackageCard('Package 3', 'Content 3', '8 kg', 'ID3', context),
            buildPackageCard('Package 3', 'Content 3', '8 kg', 'ID3', context),
            buildPackageCard('Package 3', 'Content 3', '8 kg', 'ID3', context),
            buildPackageCard('Package 3', 'Content 3', '8 kg', 'ID3', context),
            buildPackageCard('Package 3', 'Content 3', '8 kg', 'ID3', context),
            buildPackageCard('Package 3', 'Content 3', '8 kg', 'ID3', context),

          ],
        ),
      ),
    );
  }

  Widget buildPackageCard(String packageName, String packageContent, String packageWeight, String packageId, BuildContext context) {
    return Card(
      elevation: 4,
      margin: EdgeInsets.all(8),
      child: ListTile(
        title: Text(packageName),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Content: $packageContent'),
            Text('Weight: $packageWeight'),
            Text('ID: $packageId'),
            // Add more package details as needed
          ],
        ),
        onTap: () {
          showOptionsDialog(context, packageName);
        },
      ),
    );
  }

  void showOptionsDialog(BuildContext context, String packageName) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Options for $packageName'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildOptionButton('Delete', () {
                // Action for delete button
                Navigator.pop(context);
              }),
              buildOptionButton('Deliver', () {
                // Action for deliver button
                Navigator.pop(context);
              }),
              // Add more options as needed
            ],
          ),
        );
      },
    );
  }

  Widget buildOptionButton(String label, VoidCallback onPressed) {
    return TextButton(
      onPressed: onPressed,
      child: Text(label),
    );
  }
}

