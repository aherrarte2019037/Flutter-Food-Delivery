extension StringExtension on String {

  String capitalize() {
    return '${this[0].toUpperCase()}${substring(1).toLowerCase()}';
  }

  String titleCase() {
    try {
      if (isEmpty) return this;
      return split(' ').map((word) => word[0].toUpperCase() + word.substring(1).toLowerCase()).join(' ');
      
    } catch (e) {
      return this;
    }
  }

  String roleFormat() {
    switch (this) {
      case 'CLIENT'    : return 'Cliente';
      case 'DELIVERY'  : return 'Repartidor';
      case 'RESTAURANT': return 'Restaurante';
      default: return this;    
    }
  }

}