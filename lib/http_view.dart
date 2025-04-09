import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:jsonapp_test/detail_view.dart';

class HttpView extends StatefulWidget {
  const HttpView({super.key});

  @override
  State<HttpView> createState() => _HttpViewState();
}

class _HttpViewState extends State<HttpView> {
  Future<List> getProduct() async {
    var url = Uri.https('fakestoreapi.com', 'products');

    final response = await http.get(url);
    return jsonDecode(response.body);
  }

  @override
  void initState() {
    getProduct();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Product")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: FutureBuilder(
          future: getProduct(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(child: Text(snapshot.error.toString()));
            }
            return GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
              ),
              itemCount: snapshot.data == null ? 0 : snapshot.data!.length,
              itemBuilder: (context, index) {
                final product = snapshot.data![index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => DetailView(productId: product['id'],)),
                    );
                  },
                  child: Card(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(height: 20),
                        Expanded(child: Image.network(product['image'])),
                        Padding(
                          padding: const EdgeInsets.all(18.0),
                          child: Column(
                            children: [
                              Text(
                                product['title'],
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text("\$" + product['price'].toString()),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
