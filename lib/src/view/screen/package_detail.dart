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
            buildPackageCard('Package 1', 'aeghe24-gajds', 'Kıyafet', 'Günlük Giyim', "Org1",'15*15*30', '12', 'Ankara-Trabzon', context),
            buildPackageCard('Package 2', 'wefwef34-43', 'Yiyecek', 'Konserve Gıda', "Org1",'15*15*30', '12', 'Kayseri-Adana', context),
            buildPackageCard('Package 3', 'dfsdf567-65sdsdv', 'Kıyafet', 'Kışlık Giyim',"Org1", '15*15*30', '12', 'Bolu-Hakkari', context),
            buildPackageCard('Package 4', 'dsd78hns-80v', 'Medikal Malzeme', 'İlaç',"Org1", '20*10*10', '5', 'İstanbul-İzmir', context),
            buildPackageCard('Package 5', 'abc43dstgs80v', 'Temizlik Ürünleri', 'Hijyen Ürünleri', "Org1",'25*25*25', '10', 'Antalya-Bursa', context),
            buildPackageCard('Package 6', 'c4dsdd-ts8ve', 'Barınma Malzemeleri', 'Çadır',"Org1", '50*50*50', '15', 'Gaziantep-Samsun', context),
            buildPackageCard('Package 7', 'rvvy6t-dfgu', 'Barınma Malzemeleri', 'Battaniye', "Org1",'40*40*20', '8', 'Diyarbakır-Malatya', context),

          ],
        ),
      ),
    );
  }

  Widget buildPackageCard(String packageName, String packageId, String packageContent, String packageComment,  String organizationName,String packageSize, String packageWeight, String packageRoute, BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      elevation: 4,
      margin: EdgeInsets.all(8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.local_shipping, color: Colors.blue),
                SizedBox(width: 8),
                Text(packageName, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              ],
            ),
            SizedBox(height: 8),
            buildDetailRow(Icons.qr_code, 'ID', packageId),
            buildDetailRow(Icons.inventory, 'Content', packageContent),
            buildDetailRow(Icons.style, 'Comment', packageComment),
            buildDetailRow(Icons.business, 'Organization', packageComment),
            buildDetailRow(Icons.straighten, 'Package Size', packageSize),
            buildDetailRow(Icons.line_weight, 'Weight', packageWeight),
            buildDetailRow(Icons.alt_route, 'Transfer Route', packageRoute),
          ],
        ),
      ),
    );
  }

  Widget buildDetailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.grey),
          SizedBox(width: 8),
          Text('$label: ', style: TextStyle(fontWeight: FontWeight.bold)),
          Expanded(child: Text(value)),
        ],
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

