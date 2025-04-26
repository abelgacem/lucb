# define var sLIB if folder name differs
sLIB="ovh"
# define this var
lDESC="Manage OVH with LUC CLI"

export luc_EV_OVH_SSH_CONF_FILE_01="$HOME/.ssh/config"
export luc_EV_OVH_SSH_CONF_FILE_02="$HOME/.ssh/config.d/ovhvm"


# define envar
## rule: the format x|c|v is to define a uniform way of defining list
export luc_EV_OVH_NAME_VPS_MANAGED="$(echo o{1..4}{a,f,r,u,d} | tr ' ' '|')"

# deny or allow library loading
return 0
