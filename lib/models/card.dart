class BusinessCard {
  final String name;
  final String company;
  final String email;
  final String phone;
  final String address;
  final String website;

  BusinessCard({
    this.name = '',
    this.company = '',
    this.email = '',
    this.phone = '',
    this.address = '',
    this.website = '',
  });

  factory BusinessCard.fromText(String text) {
    final nameRegEx = RegExp(r'(?:Name:|^)[\s]*([A-Za-z\s\.]+)', caseSensitive: false);
    final phoneRegEx = RegExp(r'(?:Phone|Tel|Mobile)[\s:]*([+\d\s\-()]+)', caseSensitive: false);
    final emailRegEx = RegExp(r'\b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Z|a-z]{2,7}\b');
    final companyRegEx = RegExp(r'(?:Company|Organization)[\s:]*([A-Za-z0-9\s\.]+)', caseSensitive: false);
    final websiteRegEx = RegExp(r'(?:www\.|http://|https://)?[a-zA-Z0-9]+\.[a-zA-Z]+(?:\.[a-zA-Z]+)*', caseSensitive: false);
    final addressRegEx = RegExp(r'(?:Address|Location)[\s:]*([A-Za-z0-9\s\.,#-]+)', caseSensitive: false);

    return BusinessCard(
      name: nameRegEx.firstMatch(text)?.group(1)?.trim() ?? '',
      phone: phoneRegEx.firstMatch(text)?.group(1)?.trim() ?? '',
      email: emailRegEx.firstMatch(text)?.group(0)?.trim() ?? '',
      company: companyRegEx.firstMatch(text)?.group(1)?.trim() ?? '',
      website: websiteRegEx.firstMatch(text)?.group(0)?.trim() ?? '',
      address: addressRegEx.firstMatch(text)?.group(1)?.trim() ?? '',
    );
  }
}
