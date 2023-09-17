import 'package:call_screen_demo/modal.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class ContactView extends StatefulWidget {
  const ContactView({Key? key});

  @override
  State<ContactView> createState() => _ContactViewState();
}

class _ContactViewState extends State<ContactView> {
  GetEmployees employees = GetEmployees(results: []);
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    callApi();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                buildHeader(),
                buildContactInfo(),
                buildSocialInfo(),
                buildRefreshButton(),
              ],
            ),
          ),
          if (isLoading)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }

  Widget buildHeader() {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        Container(
          height: 250,
          width: double.infinity,
          child: Image.network(
            'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSFBr35nsGltX_wIDUpo4TCQCXGHsnU1P9qUQ&usqp=CAU',
            fit: BoxFit.fill,
          ),
        ),
        CircleAvatar(
          backgroundImage: NetworkImage(
            employees.results.first.picture.large.isNotEmpty
                ? employees.results.first.picture.large
                : 'https://cdn-icons-gif.flaticon.com/8797/8797856.gif',
          ),
          maxRadius: 50,
        ),
      ],
    );
  }

  Widget buildContactInfo() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Card(
        child: Container(
          color: Colors.white,
          child: Column(
            children: [
              buildInfoRow(
                iconUrl:
                    "https://cdn-icons-gif.flaticon.com/10182/10182244.gif",
                text: employees.results.first.phone,
              ),
              buildDivider(),
              buildInfoRow(
                iconUrl:
                    "https://cdn-icons-gif.flaticon.com/8362/8362321.gif",
                text: employees.results.first.location.coordinates.latitude,
              ),
              buildDivider(),
              buildInfoRow(
                iconUrl:
                    "https://cdn-icons-gif.flaticon.com/9818/9818045.gif",
                text: employees.results.first.email,
              ),
              buildDivider(),
              buildInfoRow(
                iconUrl:
                    "https://cdn-icons-gif.flaticon.com/11201/11201827.gif",
                text:
                    '${employees.results.first.location.street.name},${employees.results.first.location.city}, ${employees.results.first.location.state}, ${employees.results.first.location.country}, ${employees.results.first.location.postcode}',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildInfoRow({required String iconUrl, required String text}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        children: [
          CircleAvatar(
            backgroundImage: NetworkImage(iconUrl),
            backgroundColor: Colors.white,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Text(
              text,
              style: TextStyle(
                color: Colors.grey,
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Container(
        color: Colors.black,
        height: 1,
      ),
    );
  }

  Widget buildSocialInfo() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Card(
        child: Container(
          color: Colors.white,
          child: Column(
            children: [
              buildInfoRow(
                iconUrl:
                    "https://cdn-icons-png.flaticon.com/128/3955/3955024.png",
                text: employees.results.first.login.username,
              ),
              buildDivider(),
              buildInfoRow(
                iconUrl:
                    "https://cdn-icons-gif.flaticon.com/10828/10828104.gif",
                text: employees.results.first.login.username,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildRefreshButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 50.0, vertical: 10.0),
      child: Container(
        width: double.infinity,
        height: 50,
        color: Color.fromARGB(255, 101, 183, 221),
        alignment: Alignment.center,
        child: TextButton(
          onPressed: () {
            callApi();
          },
          child: Text(
            "Refresh",
            style: TextStyle(fontSize: 20, color: Colors.white),
          ),
        ),
      ),
    );
  }

  void callApi() async {
    debugPrint("hit the api");
    try {
      setState(() {
        isLoading = true;
      });
      var url = Uri.parse("https://randomuser.me/api");
      var response = await http.get(url);
      if (response.statusCode == 200) {
        debugPrint(response.body);
        setState(() {
          employees =
              GetEmployees.fromJson(convert.jsonDecode(response.body));
          debugPrint("data");
          debugPrint(employees.results.first.email);
        });
      }
    } catch (e) {
      print(e.toString());
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }
}
