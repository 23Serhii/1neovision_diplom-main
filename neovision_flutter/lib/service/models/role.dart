enum Role { commander, subordinate, unknown }

Role roleFromString(String role) {
  switch (role) {
    case "COMMANDER":
      return Role.commander;
    case "SUBORDINATE":
      return Role.subordinate;
    default:
      return Role.unknown;
  }
}
