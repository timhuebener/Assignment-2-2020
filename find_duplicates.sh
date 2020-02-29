#!/bin/bash  
echo "Script started"  

versions=(1.0 1.0.4 1.1.3) 
# versions=(1.0 1.0.4 1.1.3 1.10.1 1.11.2 1.12.2 1.2.1 1.2.5 1.3.1 1.4.1 1.5 1.6 1.6.3 1.7.1 1.8.2 2.0.0 2.1.0 2.1.4 2.2.3 3.1.1 3.3.1 1.0.1 1.1 1.1.3.1 1.10.2 1.11.3 1.12.3 1.2.2 1.2.6 1.3.2 1.4.2 1.5.0 1.6.0 1.6.4 1.7.2 1.8.3 2.0.1 2.1.1 2.2.0 2.2.4 3.2.0 3.4.0 1.0.2 1.1.1 1.1.4 1.11.0 1.12.0 1.12.4 1.2.3 1.3 1.4 1.4.3 1.5.1 1.6.1 1.7 1.8.0 1.9.0 2.0.2 2.1.2 2.2.1 3.0.0 3.2.1 1.0.3 1.1.2 1.10.0 1.11.1 1.12.1 1.2 1.2.4 1.3.0 1.4.0 1.4.4 1.5.2 1.6.2 1.7.0 1.8.1 1.9.1 2.0.3 2.1.3 2.2.2 3.1.0 3.3.0)
# sort the version numbers in order to have more readable logs
IFS=$'\n' versions=($(sort <<<"${versions[*]}")); unset IFS

# If output directory does not exists create it, otherwise clean it before creating the new output files
FILE=/usr/jsinspect-out
if [ -f "$FILE" ]; then
    rm -rf /usr/jsinspect-out/*
else
    mkdir /usr/jsinspect-out
fi

echo "Running jsinspect..."
# Create new output files with the output of jsinspect ran for jQuery sourcecode version pairs
for i in "${!versions[@]}"
do
    for j in "${versions[@]:$i+1}"
    do
        # echo "Running jsinspect for versions ${versions[${i}]} and ${j}"
        # TODO: should anything else be ignored?
        jsinspect -I -L -t 20 --ignore "build|test|dist|(intro|outro|min).js" ./${versions[${i}]} ./$j -r json > /usr/jsinspect-out/out-${versions[${i}]}-$j.json
    done
done
echo "Jsinspect done"

echo "Collecting character counts for jQuery repositories..."
declare -A repoCharCounts
regex="(intro|outro).js"
# Calculate the char counts in every jQuery repository
for i in "${versions[@]}"
do 
    # echo "Working with repo ${i}"
    charCount=0
    # TODO: not sure that we only have to iterate over the src files?? 
    # (maybe the .js files outside this folder or in other folders are also needed)
    # exclude intro, outro, min, build and test files and folders instead
    for f in /usr/jquery-data/$i/src/**/*.js
    do
        if [[ ! $f =~ $regex ]]
        then
            chars=$( wc -m <"$f" )
            echo "${f} ${chars}"
            let charCount=charCount+chars
        fi
    done
    echo "Char count for repo ${i} is ${charCount}"
    repoCharCounts[$i]=$charCount
    # echo "New item inserted to dict: ${repoCharCounts[$i]}"
done

echo "Process jsinspect output files and calculate similarities..."
cd ../process_outputs
for i in "${!versions[@]}"
do
    for j in "${versions[@]:$i+1}"
    do
        duplicate_char_count=$( npm start --silent out-${versions[${i}]}-$j.json $j )
        echo "Dupl char count: ${duplicate_char_count}"

        # Now we have the duplicate_char_count for versions i and j of jQuery 
        # and we have the character count for the whole repository of jQuery versions i and j
        # TODO: calculate the similarity measure -> duplicate_char_count/(char_count_all_repo_i + char_count_all_repo_i)
        # TODO: save the results into a matrix and write it into some output file that can be used for creating a hashmap

        # let divider=$repoCharCounts[$i]+$repoCharCounts[$j]
        # echo "DIVIDER ${divider}"
        # let similarity=duplicate_char_count/divider
        # echo "---- SIMILARITY: ${duplicate_char_count}"

    done
done

echo "Done"