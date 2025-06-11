import 'package:flutter/material.dart';

class ProductInfo {
  final String? svgSrc, title, totalStorage;
  final int? quantity, percentage;
  final Color? color;

  ProductInfo({
    this.svgSrc,
    this.title,
    this.totalStorage,
    this.quantity,
    this.percentage,
    this.color,
  });
}

List demoFarmProducts = [
  ProductInfo(
    title: "Tomatoes",
    quantity: 200,
    svgSrc: "assets/icons/tomato.svg",
    totalStorage: "500",
    color: const Color(0xFFe57373),
    percentage: 40,
  ),
  ProductInfo(
    title: "Potatoes",
    quantity: 150,
    svgSrc: "assets/icons/potato.svg",
    totalStorage: "800",
    color: const Color(0xFFFFA113),
    percentage: 55,
  ),
  ProductInfo(
    title: "Carrots",
    quantity: 100,
    svgSrc: "assets/icons/carrot.svg",
    totalStorage: "300",
    color: const Color(0xFFA4CDFF),
    percentage: 25,
  ),
  ProductInfo(
    title: "Lettuce",
    quantity: 50,
    svgSrc: "assets/icons/lettuce.svg",
    totalStorage: "200",
    color: const Color(0xFF81C784),
    percentage: 15,
  ),
];
