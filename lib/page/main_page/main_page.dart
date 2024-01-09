import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final TextEditingController _messageController = TextEditingController();
  int _lastIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('채팅룸'),
        actions: [
          IconButton(
            onPressed: () => FirebaseAuth.instance.signOut(),
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body:  Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            StreamBuilder(
          stream: FirebaseDatabase.instance.ref().child('chats').onValue, 
          builder: (context, snapshot){
            List data = (snapshot.data?.snapshot.value ?? []) as List;
            _lastIndex = data.isNotEmpty ? data.length: 0;

            return ListView.builder(
              itemBuilder: (context, index) => ListTile(
                title: Text(data[index]['message']),
                subtitle: Text(data[index]['name']),
              ),
              itemCount: data.length,
            );
          },
        ),
        Row(
        children: [
          const Expanded(
            child: TextField(
              controller: _messageController,
            ),
            ),
            TextButton(
              onPressed: () {
                User user = FirebaseAuth.instance.currentUser!;

                FirebaseDatabase.instance.ref().child('chats').update({
                  '${user.uid}:${DateTime}': {
                    'udi':user.uid,
                    'name':user.displayName,
                    'message': _messageController.text,
                    },
                    });
                    FocusScope.of(context).unfocus();
                    _messageController.clear();
              }, 
              child: const Text('전송'),
              ),
            ],
          )
          ],
        )
      ),
    );
  }
}