class CompanyDetector {
  static final List<String> multinationalCompanies = [
    "GSK",
    "Pfizer",
    "Novartis",
    "Sanofi",
    "Roche",
    "Abbott",
    "Bayer",
    "AstraZeneca"
  ];

  static String detectCompanyType(String companyName) {
    for (var company in multinationalCompanies) {
      if (companyName.toLowerCase().contains(company.toLowerCase())) {
        return "Multinational";
      }
    }
    return "Local";
  }
}