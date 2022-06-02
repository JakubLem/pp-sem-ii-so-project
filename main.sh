#!/bin/sh


helpview() {
    echo "RAAAAA"
    echo "RRRRAAAAAAAAA"
    echo "basz bi lajk"
}


lower() {
    echo "$1" | tr '[:upper:]' '[:lower:]'
}


getwords() {
    words=""
    file="data.txt"
    # file="/usr/share/dict/words"
    lines=`cat $file`
    for line in $lines; do
        words="${words} $(lower "$line")"
    done
    echo "$words"
}


get_point_by_letter() {
    echo 1
}


generate_result() {
    correct=""
    invalid=""
    for user_word in ${user_words}; do
        temp_checker=false
        for aval_word in ${avaliable_words}; do
            if [ "$user_word" = "$aval_word" ]; then
                temp_checker=true
            fi
        done
        if [ "$temp_checker" = true ] ; then
            correct="${correct} $user_word"
        else
            invalid="${invalid} $user_word"
        fi
    done
    points=0
    echo "Correct words:"
    for cw in ${correct}; do
        for l in $(echo $cw | sed -e 's/\(.\)/\1\n/g'); do
            points=$(( $points + $(get_point_by_letter "$l") ))
        done
    done
    echo $points
}


with_args() {
    for arg in ${args}; do
        user_words="${user_words} $(lower "$arg")"
    done
}


from_keyboard() {
    read -p "Write numbers of words : " count
    for i in $(seq 1 $count); do 
        read -p "Write $i word " temp;
        user_words="${user_words} $(lower "$temp")"
    done
}


main() {
    avaliable_words=$(getwords)
    for WORD in ${avaliable_words}; do
        echo ${WORD};
    done
    checker=false
    for arg in ${args}; do
        checker=true
    done
    if [ "$checker" = true ] ; then
        with_args
    else
        from_keyboard
    fi
    generate_result
}


if [ "$1" != "-h" ]; then
    args=""
    for arg; do
        args="${args} $(lower "$arg")"
    done
    main $args
else
    helpview
fi
