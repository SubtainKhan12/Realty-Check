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

  // Sample news items
  final List<String> sampleNews = [
    "Nate Terani is a veteran of the U.S. Navy and served in military intelligence with the Defense Intelligence Agency. He is currently a member of the leadership team at Common Defense PAC and regional campaign organizer with Veterans Challenge Islamophobia . He is a featured columnist with the Arizona Muslim Voice newspaper. (Reprinted from TomDispatch by permission of author or representative).",
    "On February 10, 2015, three young American students, Yusor Abu-Salha, Razan Abu-Salha, and Deah Shaddy Barakat, were executed at an apartment complex in Chapel Hill, North Carolina. The killer was a gun-crazy white man filled with hate and described by his own daughter as “a monster.” Those assassinations struck a special chord of sorrow and loss in me. My mom and I cried and prayed together for those students and their families.",
    "Kaydee King (@KaydeeKing) November 9, 2016 The lesson from tonight's Dem losses: Time for Democrats to start listening to the voters. Stop running the same establishment candidates.",
    "The United States established diplomatic relations with Pakistan following the country's independence in 1947. We work closely with Pakistan on a wide array of issues ranging from energy, trade and investment, health, clean energy and combating the climate crisis, to Afghanistan stabilization and counterterrorism.",
    "South Carolina political strategist Warren Tomkins warned against singling out any one candidate, or type of candidate, as the clear beneficiary of Romney's decision.'It still goes back to having a good message and a good messenger,' said Tompkins, Romney's South Carolina campaign chairman in 2012. 'If you've got that, then at some point you get momentum, and then the money will come.'",
    "When I was young, I heard many touching stories about Pakistan and the friendship between our two countries. To name just a few, I learned that the Pakistani people were working hard to build their beautiful country, and that Pakistan opened an air corridor for China to reach out to the world and supported China in restoring its lawful seat in the United Nations. The stories have left me with a deep impression. I look forward to my upcoming state visit to Pakistan.Xi Jinping, President of the People's Republic of China before his 2015 visit to Pakistan,"
  ];

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
              const SizedBox(height: 20,),
              const Text("Sample News",style: TextStyle(fontSize: 20,fontWeight: FontWeight.w500),),
              // Add sample news containers
              Column(
                children: sampleNews.map((news) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        newsController.text = news;
                      });
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 5),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.black),
                      ),
                      child: Text(
                        news,
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  );
                }).toList(),

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
    String url = "https://yousfi101-realitycheck.hf.space/run/predict";

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
