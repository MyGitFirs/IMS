import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_application_1/constants.dart';
import 'dart:convert';

import 'review_card.dart';

class ReviewsListScreen extends StatefulWidget {
  final String productId; // Accept the product ID

  const ReviewsListScreen({super.key, required this.productId});

  @override
  _ReviewsListScreenState createState() => _ReviewsListScreenState();
}

class _ReviewsListScreenState extends State<ReviewsListScreen> {
  List<dynamic> _reviews = [];
  bool _isLoading = true;
  String? _errorMessage;
  int totalReviews = 0;
  double averageRating = 0.0;
  int numOfFiveStar = 0;
  int numOfFourStar = 0;
  int numOfThreeStar = 0;
  int numOfTwoStar = 0;
  int numOfOneStar = 0;

  @override
  void initState() {
    super.initState();
    _fetchReviews();
    _fetchReviewSummary();
  }

  Future<void> _fetchReviewSummary() async {
    final String apiUrl = '$baseApiUrl/api/review/summary/${widget.productId}';

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          totalReviews = data['total_reviews'] ?? 0;
          averageRating = (data['average_rating'] ?? 0).toDouble();
          if (averageRating.isNaN) averageRating = 0.0;
          numOfFiveStar = data['numOfFiveStar'] ?? 0;
          numOfFourStar = data['numOfFourStar'] ?? 0;
          numOfThreeStar = data['numOfThreeStar'] ?? 0;
          numOfTwoStar = data['numOfTwoStar'] ?? 0;
          numOfOneStar = data['numOfOneStar'] ?? 0;
          _isLoading = false;
        });
      } else {
        setState(() {
          _errorMessage = 'Failed to load review summary';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'An error occurred: $e';
        _isLoading = false;
      });
    }
  }

  Future<void> _fetchReviews() async {
    final String apiUrl = '$baseApiUrl/api/review/list/${widget.productId}';

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        setState(() {
          _reviews = json.decode(response.body);
          _isLoading = false;
        });
      } else {
        setState(() {
          _errorMessage = 'Failed to load reviews. Please try again later.';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'An error occurred: $e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
          ? Center(child: Text(_errorMessage!))
          : CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(defaultPadding),
              child: ReviewCard(
                rating: averageRating,
                numOfReviews: totalReviews,
                numOfFiveStar: numOfFiveStar,
                numOfFourStar: numOfFourStar,
                numOfThreeStar: numOfThreeStar,
                numOfTwoStar: numOfTwoStar,
                numOfOneStar: numOfOneStar,
              ),
            ),
          ),
          _reviews.isEmpty
              ? const SliverFillRemaining(
            child: Center(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'No reviews yet.',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          )
              : SliverList(
            delegate: SliverChildBuilderDelegate(
                  (context, index) {
                final review = _reviews[index];
                return Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.star, color: Colors.orange),
                      title: Text(
                        review['review_title'] ?? 'No Title',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('By: ${review['reviewer_name'] ?? 'Anonymous'}'),
                          const SizedBox(height: 5),
                          Row(
                            children: List.generate(5, (starIndex) {
                              return Icon(
                                starIndex < (review['rating'] ?? 0)
                                    ? Icons.star
                                    : Icons.star_border,
                                color: Colors.orange,
                                size: 16,
                              );
                            }),
                          ),
                          const SizedBox(height: 5),
                          Text(review['review_text'] ?? 'No Description'),
                        ],
                      ),
                    ),
                    const Divider(),
                  ],
                );
              },
              childCount: _reviews.length,
            ),
          ),
        ],
      ),
    );
  }
}
