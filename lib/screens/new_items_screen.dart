import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:http/http.dart' as http;

class NewItemsScreen extends StatefulWidget {
  @override
  _NewItemsScreenState createState() => _NewItemsScreenState();
}

class _NewItemsScreenState extends State<NewItemsScreen> {
  Future<dynamic> futureProducts;

  Future<List<Product>> fetchFeaturedProducts() async {
    final response = await http.get(
        'https://www.dariwholesales.com/wp-json/wc/v2/products?consumer_key=ck_588caa1e285df7a51b4d88cfb2ab09cd797bff7f&consumer_secret=cs_f297234983d57a0883743c8365c29f263bbb7d19&orderby=date&featured=true');

    List responseJson = json.decode(response.body);

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      return responseJson.map((m) => new Product.fromJson(m)).toList();
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load products');
    }
  }

  @override
  void initState() {
    super.initState();
    futureProducts = fetchFeaturedProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: FutureBuilder<List<Product>>(
        future: fetchFeaturedProducts(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<Product> products = snapshot.data;
            return new ListView(
              children: products
                  .map(
                    (product) => Center(
                      child: Card(
                        margin: EdgeInsets.all(8),
                        elevation: 10,
                        child: Padding(
                          padding: const EdgeInsets.all(14.0),
                          child: Column(
                            children: <Widget>[
                              ListTile(
                                title: Text(
                                  product.name,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 22,
                                  ),
                                ),
                                subtitle: Text(
                                  product.description,
                                  style: TextStyle(
                                      color: Colors.black.withOpacity(0.6)),
                                ),
                              ),
                              Text(
                                "\$ ${product.price}",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 26,
                                  color: Colors.green,
                                ),
                              ),
                              Image.network(product.imgsrc),
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
                  .toList(),
            );
            // return Text(snapshot.data.name);
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }

          // By default, show a loading spinner.
          return Center(
            child: SizedBox(
              width: 100,
              height: 100,
              child: CircularProgressIndicator(),
            ),
          );
        },
      ),
    );
  }
}

class Product {
  final String id;
  final String name;
  final String price;
  final String imgsrc;
  final String description;

  Product({
    this.id,
    this.name,
    this.price,
    this.imgsrc,
    this.description,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return new Product(
        name: json['name'].toString(),
        id: json['id'].toString(),
        price: json['price'].toString().substring(0, 4),
        imgsrc: json['images'].first['src'],
        description: json['description'].toString());
  }
}
