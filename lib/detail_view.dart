import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_rating_stars/flutter_rating_stars.dart';
import 'package:http/http.dart' as http;

class DetailView extends StatefulWidget {
  final int productId;
  const DetailView({super.key, required this.productId});

  @override
  State<DetailView> createState() => _DetailViewState();
}

class _DetailViewState extends State<DetailView> {
  Future<Map> getProductDetail() async {
    var url = Uri.https('fakestoreapi.com', 'products/${widget.productId}');

    final response = await http.get(url);
    return jsonDecode(response.body);
  }

  @override
  void initState() {
    getProductDetail();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Center(
          child: FutureBuilder(
            future: getProductDetail(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }
              final product = snapshot.data;
              return Column(
                children: [
                  Image.network("${product!['image']}", height: 220),
                  Padding(
                    padding: const EdgeInsets.all(0),
                    child: Column(
                      children: [
                        Text(
                          "${product['title']}",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        Text("${product['description']}"),
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "${product['category']}",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          Text(
                            "\$ ${product['price']}",
                            style: TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(width: 12),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.green,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "Add to card",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  // Row(
                  //   children: [
                  //     RatingStars(
                  //       value: product['rating']['count'],
                  //     )
                  //   ],
                  // )
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
