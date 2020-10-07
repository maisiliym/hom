{
  description = "hom";

  outputs = { self }:
    {
      SobUyrld = {
        modz = [ "hyraizyn" "krimyn" "input" "uyrldSet" "hob" ];
        lamdy = import ./lamdy.nix;
      };
    };
}
       
