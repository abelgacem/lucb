# define var sLIB if folder name differs
lLIB="jekyll"
# define this var
lDESC="Manage Jekyll by wraping jekyll CLI"

# check cli exists
lCLI="jekyll"
lECHOVAL=$(luc_core_check_cli_is_installed "$lCLI"); lRETVAL=$?
[ 0 -ne "$lRETVAL" ] && luc_core_echo "caut" "library : $lLIB > $lCLI is not installed BUT can be installed via LUC."


# define envar
## os package to provision according to OS
export luc_EV_JEKYLL_PACKAGE_ALMA="ruby-devel gcc-c++ make"
export luc_EV_JEKYLL_PACKAGE_ALPINE="jekyll=4.3.4-r0 ruby-dev build-base"
# export luc_EV_JEKYLL_PACKAGE_ALPINE="ruby-dev build-base"
export luc_EV_JEKYLL_PACKAGE_UBUNTU="build-essential"
export luc_EV_JEKYLL_PACKAGE_ROCKY="ruby-devel gcc-c++ make"
## ruby package to provision according to OS
export luc_EV_JEKYLL_GEM_ALMA="jekyll -v 4.3.4"
# export luc_EV_JEKYLL_GEM_ALPINE='dummy_gem'
# export luc_EV_JEKYLL_GEM_ALPINE="jekyll -v 4.3.4"
export luc_EV_JEKYLL_GEM_ALPINE='sass-embedded --platform ruby'
export luc_EV_JEKYLL_GEM_UBUNTU="jekyll -v 4.3.4"
export luc_EV_JEKYLL_GEM_ROCKY="jekyll -v 4.3.4"
## Jekyll root folder
export luc_EV_JEKYLL_FOLDER_WKSPC="$HOME/wkspc/jekyll"
## used for naming convention
export luc_EV_JEKYLL_SUFFIX_SITE="site" # eg., test-site
export luc_EV_JEKYLL_PREFIX_THEME="theme" # eg., test-theme
##
export luc_EV_JEKYLL_FOLDER_NAME="jekyll"

# deny or allow library loading
return 0

# luc_EV_RUBY_PACKAGE_ROCKY="gcc openssl-devel redhat-rpm-config @development-tools"
# luc_EV_RUBY_PACKAGE_UBUNTU="zlib1g-dev"
# luc_EV_RUBY_PACKAGE_UBUNTU="ruby-dev libhttp-parser-dev
## luc_EV_JEKYLL_GEM_UBUNTU="jekyll=4.3.4+dfsg-1"
# gems   > gem install http_parser.rb -v '0.8.0'
# gems   > gem install http_parser.rb -v '0.6.0' --source 'https://rubygems.org/'
# gems   > gem install http_parser.rb -- --use-system-libraries
