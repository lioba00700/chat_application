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

  @override
  Widget build(BuildContext context) {
    User user = FirebaseAuth.instance.currentUser!;
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

            data = data.reversed.toList();

            return Expanded(
              child: ListView.builder(
                reverse: true,
                    itemBuilder: (context, index) {
                      return Column(
                        crossAxisAlignment: user.uid == data[index]['uid']
                          ? CrossAxisAlignment.end
                          : CrossAxisAlignment.start,
                        children: [
                          Text(data[index]['name']),
                          GestureDetector(
                            onLongPress: () {
                              if(user.uid != data[index]['uid'])return;

                              FirebaseDatabase.instance
                                  .ref()
                                  .child('chats')
                                  .update({
                                  '${(index - (data.length -1)).abs()}': {
                                    'uid':user.uid,
                                    'name':user.displayName,
                                    'message': null,
                                    },
                                });
                            },
                            child: Card(
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Text(
                                data[index]['message'] ??  '삭제된 메시지 입니다.',
                                style: Theme.of(context).textTheme.titleMedium,
                                ),
                              ),
                          ),
                          )
                        ],
                      );
                    },
                    itemCount: data.length,
                  ),
                );
            },
          ),
        Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
            ),
            ),
            TextButton(
              onPressed: () async {
                User user = FirebaseAuth.instance.currentUser!;
                DataSnapshot data = await FirebaseDatabase.instance
                  .ref()
                  .child('chats')
                  .get();

                print(user.displayName);

                FirebaseDatabase.instance.ref().child('chats').update({
                  '${data.children.length}': {
                    'uid':user.uid,
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