import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:prueba_placeto_pay/model/WebService/processTransaction.dart';
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
  static Future<Payment> createPaymentDB(
      PersonalInformation personalInformation,
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

    Payment paymentInformation;
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

    if (isCreditCardCreated) {
      paymentInformation = new Payment(cardsDocument.documentID,
          personalInformation, creditCardInformation, "");
    }

    return paymentInformation;
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

        payment = new Payment(value.documentID, personalInformation, creditCard,
            value.data["state"]);
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
  }

  // Se elimina el pago realizado
  static void deletePaymentInformation(String pid) {
    Firestore.instance
        .collection("users")
        .document(Globals.userInstance.uid)
        .collection("payments")
        .document(pid)
        .delete();
  }

  // Se actualiza el estado del pago realizado
  static void updateStatePaymentInformation(String pid, String state) {
    values["state"] = state;
    Firestore.instance
        .collection("users")
        .document(Globals.userInstance.uid)
        .collection("payments")
        .document(pid)
        .setData(values, merge: true);
  }

  // Se actualiza la información personal y financiera del pago
  static void updatePaymentInformation(Payment paymentInformation) {
    // Inicialización de los valores para actualizar el pago
    PersonalInformation personalInformation =
        paymentInformation.personalInformation;
    CreditCard creditCardInformation = paymentInformation.creditCard;

    values["name"] = personalInformation.name;
    values["email"] = personalInformation.email;
    values["phone"] = personalInformation.phone;
    values["cardNumber"] = creditCardInformation.cardNumber;
    values["cardExpMonth"] = creditCardInformation.cardExpMonth;
    values["cardExpYear"] = creditCardInformation.cardExpYear;
    values["cardCVV"] = creditCardInformation.cardCVV;
    values["state"] = "";

    Firestore.instance
        .collection("users")
        .document(Globals.userInstance.uid)
        .collection("payments")
        .document(paymentInformation.pid)
        .setData(values, merge: true);
  }

  // Se actualiza el pago para agregar el resultado del proceso de transacción
  static Future<bool> updatePaymentWithTransactionResponse(
      String pid, ProcessTransactionResponse processTransactionResponse) async {
    // Inicialización de los valores actualizar la info del pago con la respuesta del servicio
    values["transactionDate"] = processTransactionResponse.transactionDate;
    values["reference"] = processTransactionResponse.reference;
    values["paymentMethod"] = processTransactionResponse.paymentMethod;
    values["franchiseName"] = processTransactionResponse.franchiseName;
    values["issuerName"] = processTransactionResponse.issuerName;
    values["total"] = processTransactionResponse.total;
    values["currency"] = processTransactionResponse.currency;
    values["receipt"] = processTransactionResponse.receipt;
    values["refunded"] = processTransactionResponse.refunded;
    values["provider"] = processTransactionResponse.provider;
    values["authorization"] = processTransactionResponse.authorization;
    values["message"] = processTransactionResponse.message;
    bool isTransactionResponseInserted = false;

    Firestore.instance
        .collection("users")
        .document(Globals.userInstance.uid)
        .collection("payments")
        .document(processTransactionResponse.paymentInformation.pid)
        .setData(values, merge: true)
        .then((value) => isTransactionResponseInserted = true);

    return isTransactionResponseInserted;
  }

  // Se actualiza el pago para agregar el resultado del proceso de transacción
  static Future<ProcessTransactionResponse> readPaymentWithTransactionResponse(
      String pid) async {
    ProcessTransactionResponse processTransactionResponse;

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
        Payment payment = new Payment(value.documentID, personalInformation,
            creditCard, value.data["state"]);

        processTransactionResponse = new ProcessTransactionResponse(
            value.data["transactionDate"],
            value.data["reference"],
            value.data["paymentMethod"],
            value.data["franchiseName"],
            value.data["issuerName"],
            value.data["total"],
            value.data["currency"],
            value.data["receipt"],
            value.data["refunded"],
            value.data["provider"],
            value.data["authorization"],
            payment,
            value.data["message"]);
      }
    });

    return processTransactionResponse;
  }
}
