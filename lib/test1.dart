import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'dart:developer';

class MyHomePage extends StatefulWidget {
  const MyHomePage({required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  void _incrementCounter() async {
    final data = {
      "merchantId": "MERCHANTUAT",
      "merchantTransactionId": "MT7850590068188104",
      "merchantUserId": "MU933037302229373",
      "amount": 100,
      "callbackUrl": "https://webhook.site/callback-url",
      "mobileNumber": "9999999999",
      "deviceContext": {"deviceOS": "ANDROID"},
      "paymentInstrument": {
        "type": "UPI_INTENT",
        "targetApp": "com.phonepe.app",
        "accountConstraints": [
          {
            //Optional. Required only for TPV Flow.
            "accountNumber": "420200001892",
            "ifsc": "ICIC0000041"
          }
        ]
      }
    };

    final b64 = base64.encode(utf8.encode(jsonEncode(data)));

    print(b64);

    const saltKey = "099eb0cd-02cf-4e2a-8aca-3e6c6aff0399";

    final sha = generateSha256Hash('$b64/pg/v1/pay$saltKey');
    print(sha);
    try {
      final res = await http.post(
        Uri.parse('https://api-preprod.phonepe.com/apis/pg-sandbox/pg/v1/pay'),
        headers: {
          'Content-Type': 'application/json',
          'X-VERIFY': '$sha###1',
        },
      );

      print(res.body.toString());
    } catch (e) {
      log(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '',
              style: Theme.of(context).textTheme.headline6,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }

  void test() async {
    const saltKey = "099eb0cd-02cf-4e2a-8aca-3e6c6aff0399";
    const saltIndex = 1;
    const apiEndpoint = "/pg/v1/pay";

    final jsonData = {
      "merchantId": "MERCHANTUAT",
      "merchantTransactionId": "MT7850590068188104",
      "merchantUserId": "MUID123",
      "amount": '100',
      "redirectUrl": "https://webhook.site/redirect-url",
      "redirectMode": "POST",
      "callbackUrl": "https://webhook.site/callback-url",
      "mobileNumber": "9999999999",
      "paymentInstrument": {"type": "PAY_PAGE"}
    };

    String jsonString = jsonEncode(jsonData);
    String base64Data = base64.encode(utf8.encode(jsonString));
    String dataToHash = base64Data + apiEndpoint + saltKey;
    String sHA256 = generateSha256Hash(dataToHash);

    print(base64Data);
    print('#' * 10);
    print("$sHA256###$saltIndex");

    final response = await http.post(
      Uri.parse('https://api-preprod.phonepe.com/apis/pg-sandbox/pg/v1/pay'),
      headers: {
        "accept": "application/json",
        'X-VERIFY': '$sHA256###$saltIndex',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'request': base64Data}),
    );

    log(response.body.toString());
  }

  String generateSha256Hash(String input) {
    var bytes = utf8.encode(input);
    var digest = sha256.convert(bytes);
    return digest.toString();
  }
}
