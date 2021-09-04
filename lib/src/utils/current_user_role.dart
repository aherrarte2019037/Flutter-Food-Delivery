
class CurrentUserRole {
  static String role = '';

  static void setCurrentRole(String role) {
    CurrentUserRole.role = role;
  }

  static String getCurrentRole() {
    return CurrentUserRole.role;
  }

}