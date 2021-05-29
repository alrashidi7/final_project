class UserModel {
  final String id;
  final String status;
  final String phone;
  final String name;
  final String email;
  final String password;
  final String playerID;
  final String nationalID;
  final String visaCard;
  final String statusAccount;

  UserModel(
      { required this.id,
      required this.status,
      required this.phone,
      required this.name,
      required this.email,
      required this.password,
      required this.playerID,
      required this.nationalID,
      required this.statusAccount,
      required this.visaCard});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
        id: json['id'],
        status: json['status'],
        name: json['name'],
        email: json['email'],
        password: json['password'],
        playerID: json['playerID'],
        nationalID: json['nationalID'],
        visaCard: json['visaCard'],
        statusAccount: json['statusAccount'],
        phone: json['phone']);
  }
}
