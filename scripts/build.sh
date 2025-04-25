#!/bin/sh

docs="
Usage: \n\
  bash $0 [options] \n\
  Options: \n\
    -i IN_FOLDER : source yaml folder\n\
    -o OUT_FOLDER: destination yaml folder\n\
    -t TAG       : image tag\n\
Example: \n\
  bash $0 -i /foo/bar/source -o /foo/bar/deploy -r abcdzz1.azurecr.io -t staging-12 \n\
"

usage() {
    echo "$docs" >&2
    exit 1
}
if [ $# -eq 0 ]; then usage; fi


check() {
    opt=$1
    arg=$2
    if [ -z $arg ]
    then
        echo "ERROR: -$opt expects an corresponding argument" >&2
        usage
    fi
}

input_dir="$PWD/base"
output_dir="$PWD/deploy"

## 循环解析脚本的所有positional parameters
while getopts ior:t: opt
do
    case $opt in
    i)
		input_dir=$OPTARG
        ;;
    o)
        output_dir=$OPTARG
        ;;
    r)
        check r $OPTARG
        reg=$OPTARG
        ;;
    t)
        check t $OPTARG
        tag=$OPTARG
        ;;
    :)
        echo "ERROR: -$OPTARG expects an corresponding argument" >&2
        usage
        ;;
    \?) 
        echo "ERROR: unkown option -$OPTARG" >&2
        usage
        ;;
    esac
done

## 如果用户没有提供-N选项
if [ ! $reg ] 
then
    echo ERROR: option -r is required >&2
    usage
fi
## 如果用户没有提供-N选项
if [ ! $tag ] 
then
    echo ERROR: option -t is required >&2
    usage
fi


indir="$PWD/base"
echo "Build yaml files"
echo "    From: $input_dir"
echo "      To: $output_dir"
echo "    Repo: $reg"
echo "     Tag: $tag"
for file in "$input_dir"/*.yaml; do
  outfile="$output_dir/$(basename $file)"
  sed -e "s/{image_reg}/$reg/g" -e "s/{image_tag}/$tag/g" $file > $outfile
done
