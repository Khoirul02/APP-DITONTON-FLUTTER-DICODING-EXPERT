import 'dart:io';

import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';
import 'package:intl/intl.dart';

class Helper {
  static final Helper _helper = Helper._internal();
  factory Helper() {
    return _helper;
  }

  Helper._internal();

  String getDateTimeByFormat(String format, String local, DateTime date) {
    return DateFormat(format, local).format(date);
  }

  String getDateTimeByFormatV2(String format, DateTime date) {
    return DateFormat(format).format(date);
  }

  Future<http.Client> createSSLClient() async {
    final sslCert =
        await rootBundle.load('certificates/themoviedb.pem');
    SecurityContext securityContext = SecurityContext(withTrustedRoots: false);
    securityContext.setTrustedCertificatesBytes(sslCert.buffer.asInt8List());
    final context = securityContext;
    final httpClient = HttpClient(context: context);
    httpClient.badCertificateCallback = (cert, host, port) => false;
    return IOClient(httpClient);
  }
}
