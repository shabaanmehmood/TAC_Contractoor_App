class SignUpModelForCompany {
  String? registeringAs;
  String? email;
  String? name;
  String? phone;
  String? postalAddress;
  String? masterSecurityLicense;
  String? australianBusinessNumber;
  String? australianCompanyNumber;
  String? password;
  String? confirmPassword;
  String? passport;
  String? securityLicense;
  String? visaWorkingRights;
  String? abn;
  String? nationalCrimeCheck;
  String? whiteCard;

  SignUpModelForCompany({
    this.registeringAs,
    this.email,
    this.name,
    this.phone,
    this.postalAddress,
    this.masterSecurityLicense,
    this.australianBusinessNumber,
    this.australianCompanyNumber,
    this.password,
    this.confirmPassword,
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
      if (masterSecurityLicense != null) 'masterSecurityLicense': masterSecurityLicense,
      if (australianBusinessNumber != null) 'austraLianBusinessNumber': australianBusinessNumber,
      if (australianCompanyNumber != null) 'australianCompanyNumber': australianCompanyNumber,
      if (password != null) 'password': password,
      if (confirmPassword != null) 'confirmPassword': confirmPassword,
      if (passport != null) 'passport': passport,
      if (securityLicense != null) 'securityLicense': securityLicense,
      if (visaWorkingRights != null) 'visaWorkingRights': visaWorkingRights,
      if (abn != null) 'abn': abn,
      if (nationalCrimeCheck != null) 'nationalCrimeCheck': nationalCrimeCheck,
      if (whiteCard != null) 'whiteCard': whiteCard,
    };
  }
}
