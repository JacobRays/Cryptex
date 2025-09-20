class Kyc {
  String id;
  String status;
  String? idDocRef;
  String? selfieDocRef;
  DateTime? submittedAt;

  Kyc({required this.id, this.status = 'Pending', this.idDocRef, this.selfieDocRef, this.submittedAt});
}
