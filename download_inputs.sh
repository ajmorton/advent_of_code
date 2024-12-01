#! /bin/bash

# Always run from the script dir
script_dirname=$(dirname "$0")
pushd "$script_dirname" > /dev/null || exit 1
trap 'popd > /dev/null' 0 1 

if [ -z "${AOC_SESSION_COOKIE}" ] ; then
    if [ -f ".aoc_session_cookie" ] ; then
        echo "Loading session cookie from file"
        AOC_SESSION_COOKIE=$(cat .aoc_session_cookie)
        export AOC_SESSION_COOKIE
    else
        echo "No session cookie found. Please set with \`export AOC_SESSION_COOKIE=<your_cookie_here>\`"
        echo "The cookie can be fetched by logging into to AoC and (on FireFox) right clicking any page" 
        echo "and hitting 'Inspect'. Then in the 'Storage' tab take the value of the cookie names 'session'"
        exit 1
    fi
fi

function download_for_year() {
    year=$1
    path_to_input_folder=$2

    
    if [ ! -d "${path_to_input_folder}" ] ; then
        echo "Error. Folder ${path_to_input_folder} does not exist."
        exit 1
    fi

    for day_num in $(seq -w 1 25); do

        # Check that the puzzle has been released.
        # Use the EST timezone as puzzles release at midnight EST.
        export TZ=EST
        today=$(date +%Y-%m-%d)
        puzzle_release_date="${year}-12-${day_num}"

        if [[ "$today" < "$puzzle_release_date" ]]; then
            echo "${year} Day ${day_num} not released yet! Currently it is $(date)"
            return
        fi
        export TZ=


        input_file=${path_to_input_folder}/day${day_num}.txt
        if [ ! -f "${input_file}" ] ; then
            echo "Missing ${input_file}. Downloading.."
            # AoC doesn't use leading zeroes for the day number. Strip them
            url_day_num=$((10#$day_num))
            input_file_url="https://adventofcode.com/${year}/day/${url_day_num}/input"

            curl "${input_file_url}" -H "cookie: session=${AOC_SESSION_COOKIE}" -o "${input_file}" 2>/dev/null
        fi
    done
}

download_for_year "2024" "2024-pypy/input"
download_for_year "2023" "2023-nim/input"
download_for_year "2022" "2022-crystal/input"
download_for_year "2021" "2021-zig/input"
download_for_year "2020" "2020-python/input"
download_for_year "2018" "2018-rust/input"
download_for_year "2016" "2016-haskell/input"
download_for_year "2015" "2015-cpp/input"
