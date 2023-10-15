import 'package:flutter/foundation.dart';

class UserModel with ChangeNotifier {
   String? name, address, email;

  UserModel(
      { this.name,
         this.address,
         this.email,

      });
}
