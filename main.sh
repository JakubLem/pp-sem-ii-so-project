#!/bin/sh

# getargs() {
#     echo $@
# }

helpview() {
    echo "RAAAAA"
    echo "RRRRAAAAAAAAA"
}

getwords() {
    words=""
    file="data.txt"
    lines=`cat $file`
    for line in $lines; do
        words="${words} $line"
    done
    echo "$words"
}

main() {
    args=$1
    words=$(getwords)
    # args=$(getargs)

    echo "file"
    for WORD in ${words}; do
        echo ${WORD};
    done

    echo "args"
    for arg in ${args}; do
        echo ${arg};
    done

}


if [ "$1" != "-h" ]; then
    main $@
else
    helpview
fi


# $args=$@

