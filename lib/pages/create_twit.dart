import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter/providers/tweet_provider.dart';
import 'package:twitter/providers/user_provider.dart';

class CreateTwit extends ConsumerWidget {
  const CreateTwit({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    TextEditingController tweetContrller = TextEditingController();
    return Scaffold(
        appBar: AppBar(
          title: Text("Post a Tweet"),
        ),
        body: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Colors.blue), // Blue border on focus
                  ),
                ),
                controller: tweetContrller,
                maxLength: 280,
                maxLines: 4,
              ),
            ),
            TextButton(
                onPressed: () {
                  ref.read(tweetProvider).postTweet(tweetContrller.text);
                  Navigator.pop(context);
                },
                style: TextButton.styleFrom(
                  backgroundColor: Colors.blue,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Post",
                    style: TextStyle(color: Colors.white),
                  ),
                ))
          ],
        )));
  }
}
