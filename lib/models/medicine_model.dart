class Medicine {
  final String name;
  final String company;
  final String registrationNumber;
  final String price;
  final String manufactureDate;
  final String expiryDate;
  final String description;
  final bool verified;

  Medicine({
    required this.name,
    required this.company,
    required this.registrationNumber,
    required this.price,
    required this.manufactureDate,
    required this.expiryDate,
    required this.description,
    required this.verified,
  });

  factory Medicine.fromMap(Map<String, dynamic> map) {
    return Medicine(
      name: map['name'] ?? 'Unknown Name',
      company: map['company'] ?? 'Unknown Company',
      registrationNumber: map['registration_number'] ?? 'N/A',
      price: map['price'] ?? 'N/A',
      manufactureDate: map['manufacture_date'] ?? '',
      expiryDate: map['expiry_date'] ?? '',
      description: map['description'] ?? 'No description available.',
      verified: map['verified'] ?? false,
    );
  }
}
