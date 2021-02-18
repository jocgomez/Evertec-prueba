import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:prueba_placeto_pay/model/user.dart';
import 'package:prueba_placeto_pay/view/utils/globals.dart';

class DBControll {
  static Map<String, dynamic> values = new Map<String, dynamic>();

  // --- CRUD USERS
  // Create user
  static Future<bool> createUserDB(String username, String password) async {
    // Inicialización de los valores para crear un usuario nuevo
    values["username"] = username;
    values["password"] = password;
    bool isUserCreated = false;

    // Se inicializa un documento en la colección de usuarios
    DocumentReference userDocument =
        Firestore.instance.collection("users").document();

    // Si el usuario ya existe en la BD no se crea, de lo contrario si se hace.
    await readUserDB(username, password).then((value) async {
      if (value["username"] == false && value["password"] == false) {
        await userDocument.setData(values).then((value) {
          User user = new User(userDocument.documentID, username, password);
          Globals.userInstance = user;
          isUserCreated = true;
        });
      }
    });

    return isUserCreated;
  }

  // Read user
  static Future<Map<String, bool>> readUserDB(
      String username, String password) async {
    //Inicialización del mapa para validar usuario y contraseña
    Map<String, bool> isUserInBD = new Map();
    isUserInBD["username"] = false;
    isUserInBD["password"] = false;

    // Consulta a la BD para validar si existe el usuario en la BD junto a su contraseña
    await Firestore.instance.collection("users").getDocuments().then((value) {
      if (value.documents.length != 0) {
        value.documents.forEach((element) {
          if (element.data["username"] == username &&
              element.data["password"] == password) {
            User user = new User(element.documentID, username, password);
            Globals.userInstance = user;
            isUserInBD["username"] = true;
            isUserInBD["password"] = true;
          } else {
            if (element.data["username"] == username) {
              isUserInBD["username"] = true;
              isUserInBD["password"] = false;
            }
          }
        });
      }
    });
    return isUserInBD;
  }

  // Delete user
  static void deleteUserDB(String uid) {
    Firestore.instance.collection("users").document(uid).delete();
  }
}
