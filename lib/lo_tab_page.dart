import 'package:flutter/material.dart';

class MyPage extends StatelessWidget {
  final String title;

  const MyPage({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Scaffold(
          appBar: AppBar(
            leading: const IconButton(
              icon: Icon(Icons.menu),
              onPressed: null,
            ),
            title: Text(title),
            actions: const <Widget>[
              IconButton(
                icon: Icon(Icons.search),
                onPressed: null,
              ),
            ],
          ),
          backgroundColor: Colors.white,
          body: Center(
            child: Text(
              title,
              style: const TextStyle(
                  fontSize: 18.0,
                  color: Color(0xFF404856),
                  fontWeight: FontWeight.w500),
            ),
          ),
        ),
      ),
    );
  }
}
