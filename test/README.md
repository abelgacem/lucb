# Test
This folder contains code to test LUC

|name|type|description|note|
|-|-|-|-|
|`mock`|folder|set of CLI to mock|buildah|
|`srcm`|script|set of utility methods used by `launch.test`|-|
|`list`|folder|set of tests organized in folder|-|
|`launch.test`|script|launch the tests|
|`helper`|script|set of Bats helper functions|-|



sudo /Users/max/wkspc/git/bats-core/uninstall.sh /usr/local
# Install `bats`
## install the binaries
```shell
# via git
cd /tmp/
git clone https://github.com/bats-core/bats-core.git
cd bats-core
sudo ./install.sh /usr/local
```
## install the helper functions
```shell
# The first time
cd test
git submodule add https://github.com/bats-core/bats-support.git
git submodule add https://github.com/bats-core/bats-assert.git
# The other times - from the root repo folder 
git submodule update --init --remote
```

# Uninstall `bats`
```shell
# cd into folder bats-core
cd bats-core
sudo ./uninstall.sh /usr/local
```



# Howto test
- Install `Bats`
- launch the Bash script `launch.test`
