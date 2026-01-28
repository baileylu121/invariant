{ self, lib, ... }:
{
  flake.templates =
    builtins.readDir "${self}/templates"
    |> (x: lib.removeAttrs x [ ".gitignore" ])
    |> lib.filterAttrs (_name: type: type == "directory")
    |> lib.mapAttrs (
      name: _type:
      let
        templatePath = "${self}/templates/${name}.nix";
      in

      assert lib.assertMsg (builtins.pathExists templatePath) ''
        The template `${name}` is missing a metadata file.

        This should be called `${name}.nix` and include:

        ```nix
        description = "";
        welcomeText = "";
        ```
      '';

      let
        templateMeta = import templatePath;

        assertHasStringAttr =
          attr:
          lib.assertMsg (templateMeta ? ${attr} && builtins.isString templateMeta.${attr}) ''
            Template metadata should include an `${attr}` attribute with type string.
          '';

        allowedAttrs = [
          "description"
          "welcomeText"
        ];
      in

      assert assertHasStringAttr "description";
      assert assertHasStringAttr "welcomeText";

      assert lib.assertMsg (builtins.attrNames templateMeta == allowedAttrs) ''
        Template metadata has an unexpected argument:

        ```
        ${builtins.toJSON <| removeAttrs templateMeta allowedAttrs}
        ```
      '';

      {
        path = "${self}/templates/${name}";
        inherit (templateMeta) description welcomeText;
      }
    );
}
