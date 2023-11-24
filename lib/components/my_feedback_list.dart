import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FeedbackList extends StatefulWidget {
  final String foodName;

  FeedbackList({required this.foodName});

  @override
  _FeedbackListState createState() => _FeedbackListState();
}

class _FeedbackListState extends State<FeedbackList> {
  List<Widget> feedbackWidgets = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    // Replace 'yourFeedbackCollection' with the actual name of your feedback collection
    DocumentSnapshot feedbackSnapshot = await FirebaseFirestore.instance
        .collection('feedback')
        .doc(widget.foodName) // Assuming 'feedback' is your document ID
        .get();

    Map<String, dynamic> feedbackData =
        feedbackSnapshot.data() as Map<String, dynamic>;

    List<Widget> userWidgets = [];

    feedbackData.forEach((userId, userFeedback) {
      userWidgets.add(
        ListTile(
          title: Text('Email: ${userFeedback['email']}'),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Comment: ${userFeedback['comment']}'),
              Text('Rating: ${userFeedback['rating']}'),
            ],
          ),
        ),
      );
    });

    setState(() {
      feedbackWidgets = userWidgets;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'User Feedbacks:',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        Column(
          children: feedbackWidgets,
        ),
      ],
    );
  }
}
