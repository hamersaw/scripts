add_element() {
    # find parent element
    validate_id "$1"
    parent_id "$1"
    find_element "$parentid" 

    # add element to parent
    local index=$(( "${1##*.}" ))
    local childcount=$(wc -l "$element" | awk '{print $1}')
    if [ "$index" -le "0" ]; then
        echo "invalid index" && exit 1 # TODO better error msg
    elif [ "$index" -gt "$childcount" ]; then
        echo "$2 $3" >> "$element"
    else
        sed -i "$index i $2 $3" "$element"
    fi

    # create element
    touch "$datadir/$2"
}

find_element() {
	element="$gatefile"

    # if id is empty -> element is the gatefile
    if [ -z "$1" ]; then
        return 0
    fi

	# parse id
	IFS='.'
	read -a array <<< "$1"

	local level=0
	while [ "$level" -lt "${#array[@]}" ]; do
		# check if child exists
		local index=$(( ${array[$level]} ))
		local childcount=$(wc -l "$element" | awk '{print $1}')
		if [ "$index" -le "0" ] || [ "$index" -gt "$childcount" ]; then
            echo "invalid index" && exit 1 # TODO - better error msg
		else
			element="$datadir/$(head -n $index "$element" \
                | tail -n 1 | awk '{print $1}')"
		fi

		local level=$(( $level + 1 ))
	done
}

id_level() {
    local periodarray="${1//[^\.]}"
    idlevel="${#periodarray}"
}

move_element() {
    # find src parent element and index
    validate_id "$1"
    parent_id "$1"
    find_element "$parentid" 

    srcindex="${1##*.}"
    srcparent="$element"
    line=$(head -n $srcindex "$srcparent" | tail -n 1)

    # find dst parent element and index
    validate_id "$2"
    parent_id "$2"
    find_element "$parentid" 

    dstindex="${2##*.}"
    dstparent="$element"
    if [ "$dstindex" -le "1" ]; then
        echo "invalid index" && exit 1 # TODO - better error msg
    fi

    # TODO - ensure elements are at same level

    # check for cyclic dependency
    find_element "$1"
    if [[ "$element" == "$dstparent" ]]; then
        echo "move results in a cyclic relationship" && exit 1
    fi

    # remove element from src parent
    sed -i "$srcindex d" "$srcparent"

    # add element to dst parent
    childcount=$(wc -l "$dstparent" | awk '{print $1}')
    if [ "$dstindex" -gt "$childcount" ]; then
        echo "$line" >> "$dstparent"
    else
        sed -i "$dstindex i $line" "$dstparent"
    fi
}

parent_id() {
    if [[ "$1" == *"."* ]]; then
        parentid=${1%.*}
    else
        parentid=""
    fi
}

print_element() {
    # ensure element exists
    validate_id "$1"
    find_element "$1" 

    # find parent element
    parent_id "$1"
    find_element "$parentid" 

    # call recursive print
    local index=$(( "${1##*.}" ))
    [[ ! -z "$parentid" ]] && parentid="$parentid."
    print_recurse "$idlevel" "$parentid" "$index" "$element"
}

print_recurse() {
    # print this element
    local title=$(head -n $3 "$4" | tail -n 1 \
        | awk '{$1=""; print substr($0,2)}')
    echo "$2$3 - $title"

    # if element is leaf -> return
    if [ "$(( $1 + 1 ))" -ge "${#levels[@]}" ]; then
        return
    fi

    # print all children
    local uuid=$(head -n $3 "$4" | tail -n 1 | awk '{print $1}')
 
    local count=1
    while read line; do
        print_recurse $(( $1 + 1 )) "    $2$3." \
            "$count" "$datadir/$uuid"
        local count=$(( count + 1 ))
    done <"$datadir/$uuid"
}

remove_element() {
    # find element to remove
    validate_id "$1"
    find_element "$1"

    # ensure element has no children
    id_level "$1"
    childcount=$(wc -l "$element" | awk '{print $1}')
    if [ "$(( $idlevel + 1 ))" -le "${#levels[@]}" ] \
            && [ "$childcount" -gt "0" ]; then
        echo "unable to remove element with children" && exit 1
    fi

    # remove element
    rm "$element"

    # find parent element
    parent_id "$1"
    find_element "$parentid" 

    # remove element from parent
    local index="${1##*.}"
    sed -i "$index d" "$element"
}

validate_id() {
    # validate regex
    if [[ ! "$1" =~ ^[0-9]+(\.[0-9]+)*$ ]]; then
        echo "invalid id '$1'" && exit 1
    fi

    # validate id level
    id_level "$1"
    if [ "$(( $idlevel + 1 ))" -gt "${#levels[@]}" ]; then
        echo "id restricted to '${#levels[@]}' levels" && exit 1
    fi
}
