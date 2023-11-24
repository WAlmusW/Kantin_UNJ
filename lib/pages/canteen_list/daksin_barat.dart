import 'package:unj_canteen/services/auth/auth_service.dart';
import 'package:unj_canteen/components/my_rating_widget.dart';
import 'package:unj_canteen/components/my_feedback_list.dart';
import 'package:unj_canteen/components/my_rating_input.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DaksinBarat extends StatefulWidget {
  const DaksinBarat({super.key});

  @override
  State<DaksinBarat> createState() => _DaksinBaratState();
}

class _DaksinBaratState extends State<DaksinBarat> {
  final TextEditingController _searchController = TextEditingController();
  final List<List<String>> _dataList = [
    ["Mie Ayam", "Bakso", "Mie Ayam Bakso"],
    ["Kebab", "Kebab Hitam", "Burger"],
    ["Katsu", "Dimsum", "Ayam"],
    ["Nasi Goreng", "Mie Goreng", "Nagomi"]
  ];
  final List<String> _filteredDataList = [];
  // instance of auth
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    // Initialize the filtered list with the full list of data.
    _filteredDataList.addAll(_dataList.expand((list) => list).toList());
  }

  void _filterList(String searchQuery) {
    _filteredDataList.clear();

    if (searchQuery.isEmpty) {
      // If the search query is empty, show the full list.
      _filteredDataList.addAll(_dataList.expand((list) => list));
    } else {
      // Filter the list based on the search query.
      _filteredDataList.addAll(_dataList.expand((list) => list.where(
          (foodName) =>
              foodName.toLowerCase().contains(searchQuery.toLowerCase()))));
    }

    setState(() {});
  }

  // sign user out
  void signOut() {
    // get auth service
    final authService = Provider.of<AuthService>(context, listen: false);

    authService.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF5B5B5B),
        actions: [IconButton(onPressed: signOut, icon: Icon(Icons.logout))],
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: Color(0xFF333333),
        child: ListView(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              decoration: ShapeDecoration(
                  color: Color(0xFF5B5B5B),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(25),
                    bottomRight: Radius.circular(25),
                  ))),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        'Selamat Datang di Kantin UNJ\n${_auth.currentUser!.email}',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w800,
                          height: 0,
                        ),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      Image(
                        image: AssetImage("assets/images/logo_unj.png"),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      const SizedBox(
                        width: 20,
                      ),
                      Expanded(
                        child: SingleChildScrollView(
                          child: TextField(
                            controller: _searchController,
                            style: TextStyle(color: Colors.white),
                            onChanged: (value) {
                              _filterList(value);
                            },
                            decoration: InputDecoration(
                                fillColor: Color(0xFF333333),
                                filled: true,
                                suffixIcon: Icon(
                                  Icons.search,
                                  color: Color(0xFF15C8CF),
                                ),
                                hintText: "   Search",
                                hintStyle: TextStyle(color: Color(0xFF15C8CF)),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20))),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                buildElevatedButton("Daksin Barat", Color(0xFFD44747)),
                buildElevatedButton("Lapangan", Color(0xFFD69431)),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            buildTextTitle("Hello Kitty"),
            const SizedBox(
              height: 20,
            ),
            buildContainerCard(0),
            const SizedBox(
              height: 10,
            ),
            buildTextTitle("Kebab Daksin"),
            const SizedBox(
              height: 20,
            ),
            buildContainerCard(1),
            const SizedBox(
              height: 10,
            ),
            buildTextTitle("Katsu Gacor"),
            const SizedBox(
              height: 20,
            ),
            buildContainerCard(2),
            const SizedBox(
              height: 10,
            ),
            buildTextTitle("Nasi Goreng Smeng"),
            const SizedBox(
              height: 20,
            ),
            buildContainerCard(3),
            const SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }

  Container buildContainerCard(int index) {
    return Container(
      height: 168,
      child: ListView(
          scrollDirection: Axis.horizontal,
          children: _filteredDataList
              .where((foodName) =>
                  _dataList.isNotEmpty && _dataList[index].contains(foodName))
              .map((foodName) => buildCard("$foodName.png", foodName))
              .toList()),
    );
  }

  AlertDialog buildAlertDialog(String imagePath, String foodName) {
    return AlertDialog(
      backgroundColor: Color(0xFF333333),
      content: contentAlert(imagePath, foodName),
    );
  }

  Text buildTextTitle(String title) {
    return Text(
      '  $title',
      style: TextStyle(
        color: Colors.white,
        fontSize: 14,
        fontFamily: 'Inter',
        fontWeight: FontWeight.w800,
        height: 0,
      ),
    );
  }

  ElevatedButton buildElevatedButton(String title, Color backgroundColor) {
    return ElevatedButton(
        // TODO navigate
        onPressed: () {},
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color?>(backgroundColor),
        ),
        child: Text('$title',
            style: TextStyle(
              color: Color(0xFF1C1C1C),
              fontSize: 14,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w800,
            )));
  }

  Card buildCard(
    String imagePath,
    String foodName,
  ) {
    return Card(
      margin: EdgeInsets.fromLTRB(0, 0, 10, 0),
      color: Color(0xFF333333),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 206,
            height: 168,
            color: Color(0xFF5B5B5B),
            child: Column(
              children: [
                InkWell(
                  //TODO navigate
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return buildAlertDialog(imagePath, foodName);
                        });
                  },
                  child: Image(
                    image: AssetImage("assets/images/$imagePath"),
                    width: 206,
                    height: 116,
                    fit: BoxFit.fill,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '  $foodName\n',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w700,
                        height: 0,
                      ),
                    ),
                    TextButton(
                        // TODO navigate
                        onPressed: () {},
                        style: TextButton.styleFrom(
                            backgroundColor: Color(0xFF15C8CF),
                            foregroundColor: Colors.white,
                            side: BorderSide(
                                color: Color(0xFF5B5B5B), width: 2.0),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0))),
                        child: Text(
                          'Lihat',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w800,
                            height: 0,
                          ),
                        ))
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Container contentAlert(
    String imagePath,
    String foodName,
  ) {
    return Container(
      height: 800,
      color: Color(0xFF333333),
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    color: Color(0xFF5B5B5B),
                    padding: EdgeInsets.all(10.0),
                    child: Column(
                      children: [
                        Image(
                          image: AssetImage("assets/images/$imagePath"),
                          width: 206,
                          height: 116,
                          fit: BoxFit.fill,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          '$foodName\n',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w700,
                            height: 0,
                          ),
                        ),
                        RatingWidget(foodName: foodName),
                        const SizedBox(height: 10),
                        FeedbackList(foodName: foodName),
                        const SizedBox(height: 150),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: FeedbackForm(foodName: foodName),
          ),
        ],
      ),
    );
  }

  // // build a list of users except for the current logged in user
  // Widget _buildUserList() {
  //   return StreamBuilder<QuerySnapshot>(
  //     stream: FirebaseFirestore.instance.collection('users').snapshots(),
  //     builder: (context, snapshot) {
  //       if (snapshot.hasError) {
  //         return const Text("error");
  //       }

  //       if (snapshot.connectionState == ConnectionState.waiting) {
  //         return const Text("Loading..");
  //       }

  //       return ListView(
  //         children: snapshot.data!.docs
  //             .map<Widget>((doc) => _buildUserListItem(doc))
  //             .toList(),
  //       );
  //     },
  //   );
  // }

  // // build individual user list items
  // Widget _buildUserListItem(DocumentSnapshot document) {
  //   Map<String, dynamic> data = document.data()! as Map<String, dynamic>;

  //   // display all users except current user
  //   if (_auth.currentUser!.email != data['email']) {
  //     return ListTile(
  //       title: Text(data["email"]),
  //       onTap: () {
  //         // pass the clicked user's UID to the chat page
  //         Navigator.push(
  //             context, MaterialPageRoute(builder: (context) => ChatPage(
  //               receiverUserEmail: data["email"],
  //               receiveUserId: data["uid"],
  //             )));
  //       },
  //     );
  //   }else{
  //     return Container();
  //   }
  // }
}
