import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HttpView extends StatefulWidget {
  const HttpView({super.key});

  @override
  State<HttpView> createState() => _HttpViewState();
}

class _HttpViewState extends State<HttpView> {
  var products = [];
  var isLoading = true;
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
      body: FutureBuilder(
        future: getProduct(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if(snapshot.hasError){
            return Center(child: Text(snapshot.error.toString()),);
          }
          return ListView.builder(
            itemCount: snapshot.data == null ? 0 : snapshot.data!.length,
            itemBuilder: (context, index) {
              final product = snapshot.data![index];
              return Card(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.network(product['image'], height: 200),
                    Text(
                      product['title'],
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text("\$" + product['price'].toString()),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
