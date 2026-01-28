{
  description = "A simple flake template which only depends on nixpkgs";
  welcomeText = ''
    You just used the `nixpkgs` flake template.

    This is a simple flake which only depends on `nixpkgs`, however
    it also includes:

    - A devshell

    - A formatter

    - Checks

    - An `eachSystem` function

    - `.envrc`, `.gitignore`, etc
  '';
}
