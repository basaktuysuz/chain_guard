import 'package:chain_guard/src/common_widgets/toast.dart';
import 'package:chain_guard/src/db_helper/constant.dart';
import 'package:chain_guard/src/db_helper/mongo_provider.dart';
import 'package:chain_guard/src/view/model/user_model.dart';
import 'package:flutter/material.dart';
import 'package:mongo_dart/mongo_dart.dart';

class MongoDbCrud extends MongoProvider {
  Db? db;
  List searchTextResult = [];


  //* Methods

  @override
  Future<Db> open(
    String collectionName,
  ) async {
    try {
      db = await Db.create(MONGO_CONNECTION_URL);
      await db!.open();
      db!.collection(collectionName);
      debugPrint('MongoDB Connected');
      return db!;
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  @override
  Future<void> close() {
    try {
      db!.close();
      debugPrint('MongoDB Closed');
    } catch (e) {
      debugPrint(e.toString());
    }
    return Future.value();
  }

  @override
  Future<void> insertItem(
      String collectionName, Map<String, dynamic> document) async {
    try {
      await open(collectionName);
      await db!.collection(collectionName).insert(document);
      debugPrint('Document Inserted');
      showToast(message: "User is successfully created \n Use login page to log in");

    } catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  Future<void> removeItem(ObjectId id, String collectionName) async {
    try {
      await open(collectionName);
      await db!.collection(collectionName).remove(where.id(id));
      debugPrint('Document Removed');
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> updateItem(ObjectId id, String collectionName, document) async {
    try {
      await open(collectionName);
      await db!.collection(collectionName).update(where.id(id), document);
      debugPrint('Document Updated');
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  Future<List> getList(String collectionName) async {
    try {
      await open(collectionName);
      var userList = await db!.collection(collectionName).find().toList();
      debugPrint('Document Fetched');
      return userList;
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  @override
  void onSearchTextChanged(String searchText, List<dynamic> collectionList) {
    searchTextResult.clear();
    if (searchText.isEmpty) {
      searchTextResult = [];
    }

    searchTextResult = collectionList
        .where((element) => element['name']
            .toString()
            .toLowerCase()
            .contains(searchText.toLowerCase()))
        .toList();
  }

  @override
  Future<UserModel?> getUserByEmail(String collectionName, String email, String password)  async{
    final collection = db?.collection(collectionName);

    // Query the database to find a user with the provided email
    final userDoc = await collection?.findOne(where.eq('email', email));

    // If a user with the provided email exists, check if the password matches
    if (userDoc != null) {
      final userModel = UserModel.fromJson(userDoc);
      if (userModel.password == password) {
        return userModel;
      }
    }

    // If user not found or password does not match, return null
    return null;
  }


}
