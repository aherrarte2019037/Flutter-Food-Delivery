extension StringExtension on String {

  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }

  String titleCase() => replaceAll(RegExp(' +'), ' ').split(" ").map((str) => str.capitalize()).join(" ");

  String roleFormat() {
    switch (this) {
      case 'CLIENT'    : return 'Cliente';
      case 'DELIVERY'  : return 'Repartidor';
      case 'RESTAURANT': return 'Restaurante';
      default: return this;    
    }
  }

}