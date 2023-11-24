import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RatingWidget extends StatefulWidget {
  final String foodName;

  RatingWidget({required this.foodName});

  @override
  _RatingWidgetState createState() => _RatingWidgetState();
}

class _RatingWidgetState extends State<RatingWidget> {
  double averageRating = 0.0;

  @override
  void initState() {
    super.initState();
    _fetchAverageRating();
  }

  Future<void> _fetchAverageRating() async {
    try {
      double rating = await getAverageRating(widget.foodName);
      setState(() {
        averageRating = rating;
      });
    } catch (e) {
      print('Error fetching average rating: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Average Rating: ',
              style: TextStyle(fontSize: 16),
            ),
            Text(
              '$averageRating/5',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  Future<double> getAverageRating(String foodName) async {
    double totalRating = 0;
    int numberOfRatings = 0;

    try {
      final DocumentSnapshot<Map<String, dynamic>> snapshot =
          await FirebaseFirestore.instance
              .collection('feedback')
              .doc(foodName)
              .get();

      Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
      //print('Data Map: $data');

      print("DEBUG RATING WIDGET 1");

      data.forEach((String userId, dynamic userFeedback) {
        print("DEBUG RATING WIDGET 2");
        if (userFeedback.containsKey("rating")) {
          print("DEBUG RATING WIDGET 3");
          int userRating = userFeedback["rating"];
          totalRating += userRating;
          numberOfRatings++;
        }
      });

      if (numberOfRatings > 0) {
        return totalRating / numberOfRatings;
      } else {
        return 0.0;
      }
    } catch (e) {
      print('Error getting average rating: $e');
      return 0.0;
    }
  }
}
