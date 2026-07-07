// ignore_for_file: avoid_print

import 'dart:io';


void main() {
  final src = File('assets/images/orynta_icon_.png');
  final dest = File('assets/images/orynta_icon.png');
  
  if (src.existsSync()) {
    dest.writeAsBytesSync(src.readAsBytesSync());
    src.deleteSync();
    print('Successfully copied icon to canonical path and deleted old one.');
  } else {
    print('Source icon does not exist or already moved.');
  }
}
