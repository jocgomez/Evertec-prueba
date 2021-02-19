import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:prueba_placeto_pay/model/cardInformation.dart';
import 'package:prueba_placeto_pay/model/payment.dart';
import 'package:prueba_placeto_pay/model/personalInformation.dart';
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

  // Crud para los pagos realizados
  // Create pago realizado
  static Future<bool> createPaymentDB(PersonalInformation personalInformation,
      CreditCard creditCardInformation) async {
    // Inicialización de los valores para crear un nuevo pago
    values["name"] = personalInformation.name;
    values["email"] = personalInformation.email;
    values["phone"] = personalInformation.phone;
    values["cardNumber"] = creditCardInformation.cardNumber;
    values["cardExpMonth"] = creditCardInformation.cardExpMonth;
    values["cardExpYear"] = creditCardInformation.cardExpYear;
    values["cardCVV"] = creditCardInformation.cardCVV;
    values["state"] = "";
    bool isCreditCardCreated = false;

    // Se inicializa un documento en la colección de pagos, dentro de usuarios
    DocumentReference cardsDocument = Firestore.instance
        .collection("users")
        .document(Globals.userInstance.uid)
        .collection("payments")
        .document();

    // Se crea el documento con la información obtenida.
    await cardsDocument.setData(values).then((value) {
      isCreditCardCreated = true;
    });

    return isCreditCardCreated;
  }

  // Read pagos realizados
  static Future<Payment> readPaymentDB(String pid) async {
    Payment payment;

    await Firestore.instance
        .collection("users")
        .document(Globals.userInstance.uid)
        .collection("payments")
        .document(pid)
        .get()
        .then((value) {
      if (value.exists) {
        PersonalInformation personalInformation = new PersonalInformation(
            value.data["name"], value.data["email"], value.data["phone"]);
        CreditCard creditCard = new CreditCard(
            value.data["cardNumber"],
            value.data["cardExpMonth"],
            value.data["cardExpYear"],
            value.data["cardCVV"]);

        payment =
            new Payment(value.documentID, personalInformation, creditCard);
      }
    });

    return payment;
  }

  // Read todos los pagos realizados
  static Stream<QuerySnapshot> readAllPaymentDB() {
    return Firestore.instance
        .collection("users")
        .document(Globals.userInstance.uid)
        .collection("payments")
        .snapshots();
    /* .getDocuments()
        .then((value) {
      if (value.documents.length != 0) {
        value.documents.forEach((element) {
          if (element.exists) {
            PersonalInformation personalInformation = new PersonalInformation(
                element.data["name"],
                element.data["email"],
                element.data["phone"]);
            CreditCard creditCard = new CreditCard(
                element.data["cardNumber"],
                element.data["cardExpMonth"],
                element.data["cardExpYear"],
                element.data["cardCVV"]);

            payment = new Payment(
                element.documentID, personalInformation, creditCard);
          }
        });
      }
    }); */
  }
}
