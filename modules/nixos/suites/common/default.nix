{ options
, config
, lib
, pkgs
, ...
}:
# TODO: Habilitar todos os apps por aqui e depois mudar o mkbool para true para ver se funciona
# TODO: obs: funcionou hahahai
with lib;
with lib.custom; let
  cfg = config.suites.common;
in
{
  options.suites.common = with types; {
    enable = mkBoolOpt true "Enable the common suite";
  };

  config = mkIf cfg.enable {
    virtualization.kvm = {
      enable = true;
    };
  };
}
