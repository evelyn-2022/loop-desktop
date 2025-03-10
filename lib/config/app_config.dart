enum Environment { development, production }

class AppConfig {
  static Environment currentEnvironment =
      Environment.development;

  static String get baseUrl {
    switch (currentEnvironment) {
      case Environment.production:
        return 'https://api.production.com';
      case Environment.development:
        return 'http://127.0.0.1:8080/api/v1';
    }
  }
}
