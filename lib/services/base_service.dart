import 'dart:io';

abstract class BaseService {
  final HttpClient client;
  static Map<String, String> defaultHeaders = {
    'Accept': 'application/json',
    'Content-Type': 'application/json; charset=utf-8',
  };
  const BaseService(this.client);
}
