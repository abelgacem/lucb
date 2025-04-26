

# manage objects
## list objects
|||||
|-|-|-|-|
|docker|[container]|[ls, list ps]|[OPTIONS]
|docker|image[s]|[ls, list]|[OPTIONS] I1 [I2...]
||
|buildah|[containers]|[ls, list ps]|[OPTIONS]


## list objects property
||||||
|-|-|-|-|-|
|docker|inspect|  |[OPTIONS]| NAME\|ID [NAME\|ID...]
|docker|inspect|  --type image|[OPTIONS]| NAME\|ID [NAME\|ID...]
|docker|inspect|  --type container|[OPTIONS] | NAME\|ID [NAME\|ID...]
||
|buildah|inspect| |[OPTIONS]| NAME\|ID [NAME\|ID...]
|buildah|inspect| --type image                     |[OPTIONS]| NAME\|ID
|buildah|inspect| --type container                 |[OPTIONS]| NAME\|ID
|buildah| inspect| --format '{{.OCIv1.Config.Env}}'|[OPTIONS]| NAME\|ID
## delete objects
||||||
|-|-|-|-|-|
|docker| [container]|   [rm, remove]|  [OPTIONS]| C1 [C2...]
||
|buildah|            |  [rm, delete]|  [OPTIONS]| C1 [C2...]
|buildah|| prune|        [OPTIONS]


## set container's properties
||||||
|-|-|-|-|-|
|docker| run| --label com.example.foo=bar| ubuntu bash
|docker| run| --label os.shell=/bin/bash| ubuntu bash
||
|buildah| config| [OPTIONS]| |CONTAINER
|buildah| config| --author='Jane Austen' --workingdir='/etc/mycontainers' |[OPTIONS]| CONTAINER
|buildah| config| --env foo=bar          --env PATH=$PATH                 |[OPTIONS]| CONTAINER
|buildah| config| --entrypoint '[ "/entrypoint.sh", "dev" ]'              |[OPTIONS]| CONTAINER
|buildah| config| --label "maintainer=yourname@example.com"              |[OPTIONS]| CONTAINER

## set image's properties



## manage image

### Configure before commit

- docker commit --change "LABEL key=value" container_id new-image-name
- docker image inspect   --format='{{json .Config.Labels}}' myimage

### create 1 container from 1 image
**Args**
- $CONTAINER
- $IMAGE
- $OPTIONS

**Check**
- the image exists                 (get the $ImageId)
- the container name is compliant (define the $ContainerName)

**CLI**
- `docker  create  --name CONTAINER  [OPTIONS] IMAGE [COMMAND] [ARG...]` 
- `docker run      [OPTIONS]                   IMAGE  [COMMAND] [ARG...]`
- `docker run      --name test -d    [OPTIONS] $IMAGE tail -f /dev/null`
- `buildah from    --name CONTAINER  [OPTIONS] IMAGE`
- `$CLI    $ACTION --name $CONTAINER $OPTIONS  $IMAGE`
  
### create 1 image from 1 container
**Args**
- $CONTAINER
- $IMAGE

**Check**
- the container exists        (get the $ContainerId)
- the image name is compliant (define the $ImageName)

**CLI**
- `buildah commit [OPTIONS] CONTAINER   IMAGE`
- `docker  commit [OPTIONS] CONTAINER  [REPOSITORY[:TAG]]`
- `$CLI    commit $CONTAINER $IMAGE`

### enter 1 image
**Args**
- $IMAGE

**Check the args**
- the image exists (get the $ImageId)

**Define**
- a random temporary container name

**CLI**
- Docker
  - `$CLI    run -it --rm  --name  $CONTAINER $IMAGE $SHELL -l`
- Buildah  
  - create 1 temporary container from the image
  - enter the container
  - delete the container

```
buildah run -t   -v ~/wkspc/git/luc-bash:/tmp/luc  $(buildah from --name toto 63) /bin/sh -l
```

## manage container
**create container**
- docker [container] run    [OPTIONS] IMAGE [COMMAND] [ARG...]
- docker [container] create [OPTIONS] IMAGE [COMMAND] [ARG...]
- buildah            from   [OPTIONS] 

**play CLI in container**
- docker [container] exec [OPTIONS] CONTAINER COMMAND [ARG...] (need a running container)
- buildah            run  [OPTIONS] CONTAINER COMMAND [ARG...]

**copy file to/from container**
- buildah add
- buildah copy

**enter 1 container**
**Args**
- $CONTAINER

**Check**
- the container exists        (get the $ContainerId)

**CLI**
- Docker
  - running container
    - `docker exec [OPTIONS] CONTAINER COMMAND [ARG...]`
    - `docker exec -it       CONTAINER $HELL -l`
  - not running container
    - create 1 temporary image
    - enter the image
    - delete the image
- Buildah  
  - `buildah run [OPTIONS] CONTAINER    [COMMAND] [ARG...]`
  - `buildah run -t        $ContainerId $SHELL -l`




# Naming Convention
- temporary containers are named `temp-xxxxx (a 5 hexa digits string)`
- temporary images are named `tempxxxxx (5 hexa digits string)`

## Why naming convention
conventions are used in code. for example
  - when removing temporary containers or images



# Todo
add label to 1 image
- docker commit  --change "LABEL key=value" container_id new-image-name

- buildah config --label "maintainer=yourname@example.com" "$container"
- buildah commit "$container" your-image:latest

LABEL org.opencontainers.image.title="My Image"
LABEL org.opencontainers.image.description="Description of the image"
LABEL org.opencontainers.image.version="1.0.0"
LABEL org.opencontainers.image.licenses="MIT"


View labels
- buildah inspect image_name | jq '.OCIv1.Labels'
- docker inspect image_name | jq '.[0].Config.Labels'

## config
```
buildah config --label "${lLABEL_KEY_SHELL}=${lIMAGE_BASE_SHELL}" ${lCONTAINER_TEMPORARY_NAME}
buildah config --label "${lLABEL_KEY_BASE}=${lIMAGE_BASE_FULLNAME}" ${lCONTAINER_TEMPORARY_NAME}
buildah config --label "${lLABEL_KEY_SHELL}=${lIMAGE_BASE_SHELL}"   \
               --label "${lLABEL_KEY_BASE}=${lIMAGE_BASE_FULLNAME}" \
               ${lCONTAINER_TEMPORARY_NAME}
```

