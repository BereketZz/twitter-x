// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter/models/users.dart';

final userProvider = StateNotifierProvider<UserNotifier,LocalUser>((ref) {
  return UserNotifier();
});
class LocalUser {
  LocalUser({
    required this.id,
    required this.user,
  });
  final String id;
  final FirebaseUser user;
 

  LocalUser copyWith({
    String? id,
    FirebaseUser? user,
  }) {
    return LocalUser(
      id: id ?? this.id,
      user: user ?? this.user,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'user': user.toMap(),
    };
  }

  factory LocalUser.fromMap(Map<String, dynamic> map) {
    return LocalUser(
      id: map['id'] as String,
      user: FirebaseUser.fromMap(map['user'] as Map<String,dynamic>),
    );
  }

  String toJson() => json.encode(toMap());

  factory LocalUser.fromJson(String source) => LocalUser.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'LocalUser(id: $id, user: $user)';

  @override
  bool operator ==(covariant LocalUser other) {
    if (identical(this, other)) return true;
  
    return 
      other.id == id &&
      other.user == user;
  }

  @override
  int get hashCode => id.hashCode ^ user.hashCode;
}



class UserNotifier extends StateNotifier<LocalUser> {
  UserNotifier(): super(LocalUser(id: "error", user: FirebaseUser(email: "error", name: "error", profilePic: "error")));
final FirebaseFirestore _firestore = FirebaseFirestore.instance;
final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<void> logIn(String email) async {
 QuerySnapshot response=await _firestore.collection("users").where("email" ,isEqualTo: email).get();
 if(response.docs.isEmpty){
  print("No user found!!");
  return;
 }
 state=LocalUser(id: response.docs[0].id, user: FirebaseUser.fromMap(response.docs[0].data() as Map<String, dynamic>));
  }
  Future<void> signUp(String email) async {
 DocumentReference response=await _firestore.collection("users").add(FirebaseUser(email: email, name:"No name", profilePic: "https://www.gravatar.com/avatar/?d=mp").toMap());
 DocumentSnapshot snapshot= await response.get();
 state=LocalUser(id: response.id, user: FirebaseUser.fromMap(snapshot.data() as Map<String, dynamic>));
  }
  Future<void> updateUser(String name) async{
  await _firestore.collection('users').doc(state.id).update({'name':name});
  state= state.copyWith(user:state.user.copyWith(name:name));
  }
    Future<void> updateImage(File pic) async{
  Reference ref=_storage.ref().child("users").child(state.id);
   TaskSnapshot snapshot= await ref.putFile(pic);
   String img=await snapshot.ref.getDownloadURL();

  await _firestore.collection('users').doc(state.id).update({'profilePic':img});
  state= state.copyWith(user:state.user.copyWith(profilePic:img));
  }
  void logOut(){
    state= LocalUser(id: "error", user: FirebaseUser(email: "error", name: "error", profilePic: "error"));
  }
  
}