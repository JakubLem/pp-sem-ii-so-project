#!/bin/bash


helpview() {
    echo ""
    echo "NAME:"
    echo "  Scrabble"
    echo ""
    echo "DESCRIPTION:"
    echo ""
    echo "Scrabble minigame in console :)"
    echo "A console game where the user can enter a few words when invoking a command or enter them while running a script. At the end the game will write how many points the user will have and at the end he will be able to view the points in the results table stored in the results.txt file."

    echo ""
    echo "Sample execution:"
    echo "bash scrabble.sh word1 word2 word3 ... "
    echo ""
    echo "Options during execution:"
    echo "-h"
    echo "      Help info"
    echo ""
    echo "-options [ignoreinvalid, hideinvalid]"
    echo "      ignoreinvalid"
    echo "          This option will cause that results for words that were not accepted by the dictionary will not be displayed."
    echo "      hideinvalid"
    echo "          This option will prevent words not accepted by the dictionary from appearing in the summary at all."
    echo ""
    echo ""
    echo ""
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


get_point_by_single_arr() {
    letters=$1
    letter=$2
    this_point=$3
    letter_checker=false
    for l in ${letters}; do
        # echo $l $letter
        if [ "$l" = "$letter" ]; then
            letter_checker=true
        fi
    done
    if [ "$letter_checker" = true ] ; then
        echo $this_point
    else
        echo 0
    fi
}


get_point_by_letter() {
    letter=$1
    point=0
    one_p="e a i o n r t l s u"
    two_p="d g"
    three_p="b c m p"
    four_p="f h v w y"
    five_p="k"
    eight_p="j x"
    ten_p="o z"
    x=$(get_point_by_single_arr "$one_p" "$letter" "1")
    point=$(( $point + $x ))
    x=$(get_point_by_single_arr "$two_p" "$letter" "2")
    point=$(( $point + $x ))
    x=$(get_point_by_single_arr "$three_p" "$letter" "3")
    point=$(( $point + $x ))
    x=$(get_point_by_single_arr "$four_p" "$letter" "4")
    point=$(( $point + $x ))
    x=$(get_point_by_single_arr "$five_p" "$letter" "5")
    point=$(( $point + $x ))
    x=$(get_point_by_single_arr "$eight_p" "$letter" "8")
    point=$(( $point + $x ))
    x=$(get_point_by_single_arr "$ten_p" "$letter" "10")
    echo $point
}


generate_result() {
    correct=""
    invalid=""
    points=0
    for user_word in ${user_words}; do
        uw_points=0
        for l in $(echo $user_word | sed -e 's/\(.\)/\1\n/g'); do
            uw_points=$(( $uw_points + $(get_point_by_letter "$l") ))
        done
        temp_checker=false
        for aval_word in ${avaliable_words}; do
            if [ "$user_word" = "$aval_word" ]; then
                temp_checker=true
            fi
        done
        if [ "$temp_checker" = true ] ; then
            points=$(( $points + $uw_points ))
            correct="${correct} $user_word"
            echo "$user_word | $valid_word_message | $uw_points" 
        else
            if [ "$settings_hide_invalid" = false ] ; then
                if [ "$settings_ignore_invalid" = true ] ; then
                    echo "$user_word| $invalid_word_message | X"
                else
                    echo "$user_word | $invalid_word_message | $uw_points" 
                fi
            fi
        fi
    done
    echo "Full score: $points"
    echo "$USER $points" >> results.txt
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

    if [ "$debug" = true ] ; then
        echo "=================================="
        echo "Your words:"
        for arg in ${args}; do
            echo $arg
        done
        echo "=================================="
        echo "Availiable words:"
        for WORD in ${avaliable_words}; do
            echo ${WORD};
        done
        echo "=================================="
    fi
    
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


args=""
for arg; do
    args="${args} $(lower "$arg")"
done

# settings
debug=true
settings_ignore_invalid=false
settings_hide_invalid=false
invalid_word_message="INVALID"
valid_word_message="VALID"


if [ "$1" != "-h" ]; then
    if [ "$1" = "-options" ]; then
        delete="-options"
        args=("${args[@]/"-options"}")
        if [ "$2" = "ignoreinvalid" ]; then
            args=("${args[@]/"ignoreinvalid"}")
            settings_ignore_invalid=true
            echo "[Settings]::Results of invalid words will be hidden"
        else
            if [ "$2" = "hideinvalid" ]; then
                args=("${args[@]/"hideinvalid"}")
                settings_hide_invalid=true
                echo "[Settings]::Invalid words will be hidden"
            else
                echo "zle" # TODO boom
            fi
        fi
    fi
    main $args
else
    helpview
fi
