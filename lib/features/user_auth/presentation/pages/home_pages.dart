import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../../global/common/toast.dart';

class HomePage extends StatefulWidget {
  final String username;

  // ignore: use_key_in_widget_constructors
  const HomePage({Key? key, required this.username});

  @override
  // ignore: library_private_types_in_public_api
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late String _username; // Declare a variable to store the username

  @override
  void initState() {
    super.initState();
    print("InitState: ${widget.username}");
    _username = widget.username; // Assign the username in the initState
  }

  @override
  Widget build(BuildContext context) {
    print("Build: $_username");
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            // Logo de l'application (à remplacer par votre propre logo)
            Image.asset(
              'images/logo.jpg', // Assurez-vous que le chemin est correct
              height: 30,
              width: 30,
            ),
            SizedBox(width: 10),
            // Nom de l'utilisateur connecté
            Text(_username),
          ],
        ),
        actions: [
          // Bouton de déconnexion
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              // Code de déconnexion ici
              FirebaseAuth.instance.signOut();
              Navigator.pushNamed(context, "/login");
              showToast(message: "Successfully signed out");
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Stack(children: [
          // Image de fond
          Positioned.fill(
            child: Image.asset(
              'images/im.jpg', // Remplacez par le chemin de votre image
              fit: BoxFit.cover,
            ),
          ),
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Barre de navigation principale
                // Barre de navigation principale
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildNavBarButton("Accueil", Icons.home),
                      _buildNavBarButton("Recherche", Icons.search),
                      _buildNavBarButton("Visite Virtuelle", Icons.map),
                      _buildNavBarButton("Recommandations", Icons.thumb_up),
                      _buildNavBarButton("Ajouter un PFE", Icons.add),
                      _buildNavBarButton("Profil", Icons.person),
                    ],
                  ),
                ),
                // Section de recherche rapide
                Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Barre de recherche avec champ de texte
                      TextField(
                        decoration: InputDecoration(
                          hintText: 'Rechercher...',
                          prefixIcon: Icon(Icons.search),
                        ),
                      ),
                      SizedBox(height: 10),
                      // Bouton de recherche par code QR
                      ElevatedButton(
                        onPressed: () {
                          // Code pour la recherche par code QR
                        },
                        child: Text('Recherche par code QR'),
                      ),
                      SizedBox(height: 10),
                      // Options de recherche avancée (par titre, auteur, année, etc.)
                      // Ajoutez vos options de recherche ici
                    ],
                  ),
                ),

                // Vos autres widgets ici
              ],
            ),
          ),
        ]),
      ),
    );
  }

  Widget _buildNavBarItem(String title, IconData icon) {
    return Column(
      children: [
        Icon(icon),
        SizedBox(height: 5),
        Text(title),
      ],
    );
  }

  Widget _buildNavBarButton(String title, IconData icon) {
    return ElevatedButton.icon(
      onPressed: () {
        // Ajoutez votre logique ici pour chaque bouton
      },
      icon: Icon(icon, color: Colors.white),
      label: Text(
        title,
        style: TextStyle(color: Colors.white),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.transparent, // Fond transparent
        elevation: 0, // Pas d'ombre
      ),
    );
  }

  Stream<List<UserModel>> _readData() {
    final userCollection = FirebaseFirestore.instance.collection("users");

    return userCollection.snapshots().map((querySnapshot) => querySnapshot.docs
        .map(
          (e) => UserModel.fromSnapshot(e),
        )
        .toList());
  }

  void _updateData(UserModel userModel) {
    final userCollection = FirebaseFirestore.instance.collection("users");

    final newData = UserModel(
      username: userModel.username,
      id: userModel.id,
      adress: userModel.adress,
      age: userModel.age,
    ).toJson();

    userCollection.doc(userModel.id).update(newData);
  }

  void _deleteData(String id) {
    final userCollection = FirebaseFirestore.instance.collection("users");

    userCollection.doc(id).delete();
  }

  void showToast({required String message}) {
    // Implement your showToast logic here
  }
}

class UserModel {
  final String? username;
  final String? adress;
  final int? age;
  final String? id;

  UserModel({this.id, this.username, this.adress, this.age});

  static UserModel fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    return UserModel(
      username: snapshot['username'],
      adress: snapshot['adress'],
      age: snapshot['age'],
      id: snapshot['id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "username": username,
      "age": age,
      "id": id,
      "adress": adress,
    };
  }
}
