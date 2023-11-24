import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FeedbackForm extends StatefulWidget {
  final String foodName;

  FeedbackForm({required this.foodName});

  @override
  _FeedbackFormState createState() => _FeedbackFormState();
}

class _FeedbackFormState extends State<FeedbackForm> {
  late User? user;
  int _rating = 0;
  TextEditingController _commentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser;
  }

  @override
  Widget build(BuildContext context) {
    String userEmail = user?.email ?? "No Email";
    String uid = user?.uid ?? "No UID";
    String foodName = widget.foodName;

    return Container(
      color: Color(0xFF5B5B5B),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Rate the $foodName:'),
            Row(
              children: List.generate(5, (index) {
                return IconButton(
                  icon: Icon(
                    index < _rating ? Icons.star : Icons.star_border,
                    color: Colors.orange,
                  ),
                  onPressed: () {
                    setState(() {
                      _rating = index + 1;
                    });
                  },
                );
              }),
            ),
            SizedBox(height: 10.0),
            Text('Leave a Comment:'),
            TextField(
              controller: _commentController,
              decoration: InputDecoration(
                hintText: 'Enter your comment...',
              ),
            ),
            SizedBox(height: 10.0),
            ElevatedButton(
              onPressed: () async {
                await updateFeedback(
                  widget.foodName,
                  userEmail,
                  uid,
                  _commentController.text,
                  _rating,
                );
                Navigator.pop(context);
              },
              child: Text('Submit Feedback'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> updateFeedback(String foodName, String email, String userId,
      String comment, int rating) async {
    try {
      final DocumentReference feedbackRef =
          FirebaseFirestore.instance.collection('feedback').doc(foodName);

      DocumentSnapshot snapshot = await feedbackRef.get();
      Map<String, dynamic> feedbackData =
          snapshot.exists ? snapshot.data() as Map<String, dynamic> : {};

      if (feedbackData.containsKey(userId)) {
        feedbackData[userId]['comment'] = comment;
        feedbackData[userId]['rating'] = rating;
      } else {
        feedbackData[userId] = {
          'email': email,
          'comment': comment,
          'rating': rating,
        };
      }

      await feedbackRef.set(feedbackData);
    } catch (error) {
      print('Error updating feedback: $error');
    }
  }
}
