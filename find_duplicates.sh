#!/bin/bash  
echo "Script started"  

# Sorted list of versions
# Created with the following commands:
# $ v="1.0\n1.0.4\n1.1.3\n1.10.1\n1.11.2\n1.12.2\n1.2.1\n1.2.5\n1.3.1\n1.4.1\n1.5\n1.6\n1.6.3\n1.7.1\n1.8.2\n2.0.0\n2.1.0\n2.1.4\n2.2.3\n3.1.1\n3.3.1\n1.0.1\n1.1\n1.1.3.1\n1.10.2\n1.11.3\n1.12.3\n1.2.2\n1.2.6\n1.3.2\n1.4.2\n1.5.0\n1.6.0\n1.6.4\n1.7.2\n1.8.3\n2.0.1\n2.1.1\n2.2.0\n2.2.4\n3.2.0\n3.4.0\n1.0.2\n1.1.1\n1.1.4\n1.11.0\n1.12.0\n1.12.4\n1.2.3\n1.3\n1.4\n1.4.3\n1.5.1\n1.6.1\n1.7\n1.8.0\n1.9.0\n2.0.2\n2.1.2\n2.2.1\n3.0.0\n3.2.1\n1.0.3\n1.1.2\n1.10.0\n1.11.1\n1.12.1\n1.2\n1.2.4\n1.3.0\n1.4.0\n1.4.4\n1.5.2\n1.6.2\n1.7.0\n1.8.1\n1.9.1\n2.0.3\n2.1.3\n2.2.2\n3.1.0\n3.3.0"
# $ printf $v | sort --version-sort
# Then the received output was processed in VSCode so that every new line was converted to space character and the values were put into an array
versions=(1.0 1.0.1 1.0.2 1.0.3 1.0.4 1.1)
# TODO: run for all versions
# versions=(1.0 1.0.1 1.0.2 1.0.3 1.0.4 1.1 1.1.1 1.1.2 1.1.3 1.1.3.1 1.1.4 1.2 1.2.1 1.2.2 1.2.3 1.2.4 1.2.5 1.2.6 1.3 1.3.0 1.3.1 1.3.2 1.4 1.4.0 1.4.1 1.4.2 1.4.3 1.4.4 1.5 1.5.0 1.5.1 1.5.2 1.6 1.6.0 1.6.1 1.6.2 1.6.3 1.6.4 1.7 1.7.0 1.7.1 1.7.2 1.8.0 1.8.1 1.8.2 1.8.3 1.9.0 1.9.1 1.10.0 1.10.1 1.10.2 1.11.0 1.11.1 1.11.2 1.11.3 1.12.0 1.12.1 1.12.2 1.12.3 1.12.4 2.0.0 2.0.1 2.0.2 2.0.3 2.1.0 2.1.1 2.1.2 2.1.3 2.1.4 2.2.0 2.2.1 2.2.2 2.2.3 2.2.4 3.0.0 3.1.0 3.1.1 3.2.0 3.2.1 3.3.0 3.3.1 3.4.0)

# If output directory does not exists create it, otherwise clean it before creating the new output files
FILE=/usr/jsinspect-out
if [ -d "$FILE" ]; then
    rm -rf $FILE/*
else
    mkdir $FILE
fi

echo "Running jsinspect..."
# Create new output files with the output of jsinspect run for jQuery source code version pairs
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

echo "Collecting character counts of jQuery repositories..."
# Print the character counts of jQuery repositories into the jQuery_sizes_output.csv file
# The first line contains the list of sorted versions, separated by space
# After that the character counts of jQuery versions are listed in the same order as they appear in the first row
echo ${versions[*]} >> /usr/jsinspect-out/jQuery_sizes_output.csv
declare -A repoCharCounts
regex="(intro|outro|min).js"
# Calculate the char counts in every jQuery repository
for i in "${versions[@]}"
do 
    # echo "Working with repo ${i}"
    charCount=0
    # TODO: this regex includes /dist, /test and /build directories, that won't affect the char count calculation but
    # it gives a "wc: 'standard input': Is a directory" during the next processing step
    # Something like this should work: find ./3.0.0 -regex '^((?!build|test|dist).)*.js$' 
    for f in $( find ./$i \( -path '*/build' -o -path '*/test' -o -path '*/dist' \) -prune -o -name '*.js' )
    do
        if [[ ! $f =~ $regex ]]
        then
            chars=$( wc -m <"$f" )
            let charCount=charCount+chars
        fi
    done
    echo "Char count for repo ${i} is ${charCount}"
    repoCharCounts[$i]=$charCount
    echo ${charCount} >> /usr/jsinspect-out/jQuery_sizes_output.csv
    # echo "New item inserted to dict: ${repoCharCounts[$i]}"
done

declare -A matrix
echo "Process jsinspect output files and calculate similarities..."
cd ../process_outputs
for i in "${!versions[@]}"
do
    for j in "${!versions[@]}"
    do
        if [[ $j -gt $i ]]
        then
            duplicate_char_count=$( npm start --silent out-${versions[${i}]}-${versions[${j}]}.json )
            echo "Dupl char count: ${duplicate_char_count}"

            # Now we have the duplicate_char_count for versions i and j of jQuery 
            # and we have the character count for the whole repository of jQuery versions i and j
            # calculate the similarity measure -> duplicate_char_count/(char_count_all_repo_i + char_count_all_repo_i)
            let divider=${repoCharCounts[${versions[${i}]}]}+${repoCharCounts[${versions[${j}]}]}
            echo "DIVIDER ${divider}"
            similarity=$( bc <<< "scale=4; $duplicate_char_count/$divider" )
            echo "---- SIMILARITY between ${versions[${i}]} and ${versions[${j}]}: ${similarity}"

            matrix[$i,$j]=$similarity
            matrix[$j,$i]=$similarity
        elif [[ $i -eq $j ]]
        then
            matrix[$i,$j]=1
        fi
    done
done

# Print the matrix of similarities into the similarities_output.csv file
# The first line contains the list of sorted versions, separated by space
# After that the similarity matrix between the versions is created (the rows and columns correspont to the versions
# in the same order as they appear in the first row)
echo ${versions[*]} >> /usr/jsinspect-out/similarities_output.csv
for((i=0; i<${#versions[@]}; i++))
do
    matrix_row=""
    for((j=0; j<${#versions[@]}; j++))
    do
        matrix_row="${matrix_row} ${matrix[$i,$j]}"
    done
    echo $matrix_row >> /usr/jsinspect-out/similarities_output.csv
done

echo "Done"