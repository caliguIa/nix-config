{lib}: {
  isDarwin = system: lib.hasSuffix "-darwin" system;

  mkHomeDirectory = username: system:
    if lib.hasSuffix "-darwin" system
    then "/Users/${username}"
    else "/home/${username}";
}
