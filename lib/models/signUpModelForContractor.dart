class SignUpModelForIndividual {
  String? registeringAs;
  String? email;
  String? name;
  String? phone;
  String? postalAddress;
  String? australianBusinessNumber;
  String? password;
  String? confirmPassword;
  String? dob;
  String? gender;
  String? passport;
  String? securityLicense;
  String? visaWorkingRights;
  String? abn;
  String? nationalCrimeCheck;
  String? whiteCard;

  SignUpModelForIndividual({
    this.registeringAs,
    this.email,
    this.name,
    this.phone,
    this.postalAddress,
    this.australianBusinessNumber,
    this.password,
    this.confirmPassword,
    this.dob,
    this.gender,
    this.passport,
    this.securityLicense,
    this.visaWorkingRights,
    this.abn,
    this.nationalCrimeCheck,
    this.whiteCard,
  });

  Map<String, dynamic> toJson() {
    return {
      if (registeringAs != null) 'registeringAs': registeringAs,
      if (email != null) 'email': email,
      if (name != null) 'Name': name,
      if (phone != null) 'phone': phone,
      if (postalAddress != null) 'postalAddress': postalAddress,
      if (australianBusinessNumber != null) 'austraLianBusinessNumber': australianBusinessNumber,
      if (password != null) 'password': password,
      if (confirmPassword != null) 'confirmPassword': confirmPassword,
      if (dob != null) 'dob': dob,
      if (gender != null) 'gender': gender,
      if (passport != null) 'passport': passport,
      if (securityLicense != null) 'securityLicense': securityLicense,
      if (visaWorkingRights != null) 'visaWorkingRights': visaWorkingRights,
      if (abn != null) 'abn': abn,
      if (nationalCrimeCheck != null) 'nationalCrimeCheck': nationalCrimeCheck,
      if (whiteCard != null) 'whiteCard': whiteCard,
    };
  }
}
