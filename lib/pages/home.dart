import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:twitter/models/tweet.dart';
import 'package:twitter/pages/create_twit.dart';
import 'package:twitter/pages/setting.dart';
import 'package:twitter/providers/tweet_provider.dart';
import 'package:twitter/providers/user_provider.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    LocalUser currentUser = ref.watch(userProvider);
    return Scaffold(
      appBar: AppBar(
        
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(4.0),
          child: Container(
            color: Colors.grey,
            height: 1,
          ),
        ),
        leading: Builder(builder: (context) {
          return GestureDetector(
            onTap: () => Scaffold.of(context).openDrawer(),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircleAvatar(
                backgroundImage: NetworkImage(currentUser.user.profilePic),
              ),
            ),
          );
        }),
        title: FaIcon(
          FontAwesomeIcons.twitter,
          color: Colors.blue,
          size: 50,
        ),
        
      ),
      
      body: ref.watch(feedProvider).when(
          data: (List<Tweet> tweets) {
            return ListView.separated(
                separatorBuilder: (context, index) => const Divider(),
                itemCount: tweets.length,
                itemBuilder: (context, count) {
                  return Padding(
                    padding: const EdgeInsets.only(top:10),
                    child: ListTile(
                     
                      leading: CircleAvatar(
                    
                        foregroundImage: NetworkImage(tweets[count].profilePic),
                      ),
                      title: Text(
                        tweets[count].name,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        tweets[count].tweet,
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                  );
                });
          },
          error: (error, stackTrace) => const Center(child: Text("Error")),
          loading: () {
            return CircularProgressIndicator();
          }),
      drawer: Drawer(
          child: Column(
        children: [
          Image.network(currentUser.user.profilePic),
          ListTile(
            title: Text(
              "Hello, ${currentUser.user.name}",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ),
          ListTile(
            leading: Row(
              mainAxisSize: MainAxisSize.min, // Adjust spacing if needed
              children: [
                Icon(
                  FontAwesomeIcons
                      .cog, // Use FontAwesomeIcons.cog for settings icon
                  size: 18.0, // Adjust icon size as needed
                ),
                const SizedBox(width: 10.0), // Add some horizontal spacing
                Text(
                  "Settings",
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            onTap: () {
              Navigator.pop(context);
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => SettingsPage()));
            },
          ),
          ListTile(
            leading: Row(
              mainAxisSize: MainAxisSize.min, // Adjust spacing if needed
              children: [
                Icon(
                  FontAwesomeIcons
                      .signOutAlt, // Use FontAwesomeIcons.signOutAlt for signout icon
                  size: 18.0, // Adjust icon size as needed
                ),
                const SizedBox(width: 10.0), // Add some horizontal spacing
                Text(
                  "Sign Out",
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            onTap: () async {
              await FirebaseAuth.instance.signOut();
              ref.read(userProvider.notifier).logOut();
            },
          )
        ],
      )),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => CreateTwit()));
          },
          backgroundColor: Colors.blue,
          child: Icon(Icons.add)),
    );
  }
}
