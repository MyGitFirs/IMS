class RecentTransaction {
  final String? icon;
  final String title;   // Name of the product
  final String date;    // Date of sale
  final String quantity; // Quantity sold

  RecentTransaction({
    this.icon,
    required this.title,
    required this.date,
    required this.quantity,
  });
}


List demoRecentTransactions = [
  RecentTransaction(
    icon: "assets/icons/tomato.svg",
    title: "Tomatoes Sold",
    date: "15-08-2024",
    quantity: "10",
  ),
  RecentTransaction(
    icon: "assets/icons/potato.svg",
    title: "Potatoes Harvested",
    date: "10-08-2024",
    quantity: "500",
  ),
  RecentTransaction(
    icon: "assets/icons/carrot.svg",
    title: "Carrots Shipped",
    date: "08-08-2024",
    quantity: "150",
  ),
  RecentTransaction(
    icon: "assets/icons/lettuce.svg",
    title: "Lettuce Sold",
    date: "05-08-2024",
    quantity: "10",
  ),
  RecentTransaction(
    icon: "assets/icons/cabbage.svg",
    title: "Cabbage Harvested",
    date: "02-08-2024",
    quantity: "30",
  ),
  RecentTransaction(
    icon: "assets/icons/apple.svg",
    title: "Apples Sold",
    date: "01-08-2024",
    quantity: "40",
  ),

];
