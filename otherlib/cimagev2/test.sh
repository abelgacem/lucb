lLABEL_KEY_OSNAME="mx.os.01"
lLABEL_KEY_SHELL="mx.os.02"
lLABEL_KEY_IMAGE_00="mx.os.04"
lLABEL_KEY_IMAGE_CURRENT="mx.os.03"
lIMAGE_ROOT_SNAME="mx.os.val01"
lIMAGE_ROOT_SHELL="mx.os.val02"
lIMAGE_BASE_NAMEANDTAG="mx.os.val03"
lIMAGE_ROOT_FULLNAME="mx.os.val04"

lOPTION_LABEL="
     ${lLABEL_KEY_OSNAME}=${lIMAGE_ROOT_SNAME} \
     ${lLABEL_KEY_SHELL}=${lIMAGE_ROOT_SHELL} \
     ${lLABEL_KEY_IMAGE_CURRENT}=${lIMAGE_BASE_NAMEANDTAG} \
     ${lLABEL_KEY_IMAGE_00}=${lIMAGE_ROOT_FULLNAME}
  "

  lLIST_LABEL=$(echo "$lOPTION_LABEL" | xargs -n 1 -I {} echo "--change \"LABEL {}\"")

echo $lLIST_LABEL


# compgen -A variable | grep '^luc_EV' | sort 
# compgen -A variable | grep '^luc_EV' | sort | xargs -I{}
# compgen -A variable | grep '^luc_EV' | sort | xargs -0
# compgen -A variable | grep '^luc_EV' | sort | xargs -0 sh -c "yo {} : {}"
# compgen -A variable | grep '^luc_EV' | sort | xargs -0 sh -c "yo {} : \${}"
