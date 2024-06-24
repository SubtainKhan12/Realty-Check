import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class RealityCheck extends StatefulWidget {
  const RealityCheck({super.key});

  @override
  State<RealityCheck> createState() => _RealityCheckState();
}

class _RealityCheckState extends State<RealityCheck> {
  TextEditingController newsController = TextEditingController();
  TextEditingController resultController = TextEditingController();
  bool isLoading = false; // State variable for loading

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        title: const Text('Predict News'),
        centerTitle: true,
        backgroundColor: Colors.orange,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              TextField(
                controller: newsController,
                minLines: 3,
                maxLines: null,
                decoration: InputDecoration(
                  hintText: "Enter Your News",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Colors.black),
                  ),
                ),
              ),
              const SizedBox(height: 10,),
              Stack(
                alignment: Alignment.centerRight, // Align the indicator to the right
                children: [
                  TextField(
                    controller: resultController,
                    readOnly: true,
                    maxLines: 2,
                    decoration: InputDecoration(
                        hintText: "Result",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(color: Colors.black))),
                  ),
                  if (isLoading)
                    const Padding(
                      padding: EdgeInsets.only(right: 10), // Add some padding to avoid overlap with the text
                      child: CircularProgressIndicator(),
                    ),
                ],
              ),
              const SizedBox(height: 10,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 150,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                      ),
                      onPressed: () {
                        realityCheckApi();
                      },
                      child: const Text("Predict", style: TextStyle(fontSize: 20)),
                    ),
                  ),
                  const SizedBox(width: 10), // Add some space between the buttons
                  SizedBox(
                    width: 150,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                      ),
                      onPressed: () {
                        setState(() {
                          newsController.clear(); // Clear the news TextField
                        });
                      },
                      child: const Text("Clear", style: TextStyle(fontSize: 20)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future realityCheckApi() async {
    setState(() {
      isLoading = true; // Set loading to true when API call starts
      resultController.text = ''; // Clear previous result
    });

    // Replace with your actual news text
    String newsText = newsController.text.toString();

    // URL of the endpoint
    String url = "Your Model Api";

    // JSON payload
    Map<String, dynamic> payload = {
      "data": [newsText]
    };

    // Send POST request
    http.Response response = await http.post(
      Uri.parse(url),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(payload),
    );

    // Check if the request was successful
    if (response.statusCode == 200) {
      // Parse the JSON response
      Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      // Extract the result from the response
      String result = jsonResponse['data'][0].toString();

      // Update the resultController's text
      setState(() {
        resultController.text = result;
        isLoading = false; // Set loading to false when API call completes
      });
      print(jsonResponse);
    } else {
      setState(() {
        resultController.text = 'Request failed with status: ${response.statusCode}';
        isLoading = false; // Set loading to false when API call completes
      });
      print("Request failed with status: ${response.statusCode}");
    }
  }
}
