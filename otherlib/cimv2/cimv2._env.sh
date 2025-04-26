# define var
lLIB="cimv2"

# define envar
export luc_EV_CIMV2_DUMMY_LOOP="tail -f /dev/null"

# image/container LABEL
export luc_EV_CIMV2_LABEL_KEY_SHELL="mx.os.shell"
export luc_EV_CIMV2_LABEL_KEY_OSNAME="mx.os.name"

# deny or allow library loading
return 0