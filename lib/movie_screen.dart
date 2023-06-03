import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MovieScreen extends StatefulWidget {
  @override
  _MovieScreenState createState() => _MovieScreenState();
}

class _MovieScreenState extends State<MovieScreen> {
  Map<String, dynamic> movieData = {};

  @override
  void initState() {
    super.initState();
    fetchMovieData();
  }

  Future<void> fetchMovieData() async {
    final apiKey = 'ef1814ef';
    final apiUrl = 'https://www.omdbapi.com/?i=tt3896198&apikey=$apiKey&t=Captain America: The Winter Soldier';

    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      setState(() {
        movieData = json.decode(response.body);
      });
    } else {
      print('Failed to fetch data. Error: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Movie Details'),
      ),
      body: Center(
        child: movieData.isNotEmpty
            ? Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height:200,width:200,child: Image.network(movieData['Poster'])),
            SizedBox(height: 20),
            Text(
              'Title: ${movieData['Title']}',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'Year: ${movieData['Year']}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 10),
            Text(
              'Plot: ${movieData['imdbRating']}',
              style: TextStyle(fontSize: 16),
            ),
            // Add more Text widgets to display other movie details
          ],
        )
            : CircularProgressIndicator(),
      ),
    );
  }
}