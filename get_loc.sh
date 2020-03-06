#!/bin/bash  
echo "LOC counter script started"  

versions=(1.0 1.0.1 1.0.2 1.0.3 1.0.4 1.1 1.1.1 1.1.2 1.1.3 1.1.3.1 1.1.4 1.2 1.2.1 1.2.2 1.2.3 1.2.4 1.2.5 1.2.6 1.3 1.3.0 1.3.1 1.3.2 1.4 1.4.0 1.4.1 1.4.2 1.4.3 1.4.4 1.5 1.5.0 1.5.1 1.5.2 1.6 1.6.0 1.6.1 1.6.2 1.6.3 1.6.4 1.7 1.7.0 1.7.1 1.7.2 1.8.0 1.8.1 1.8.2 1.8.3 1.9.0 1.9.1 1.10.0 1.10.1 1.10.2 1.11.0 1.11.1 1.11.2 1.11.3 1.12.0 1.12.1 1.12.2 1.12.3 1.12.4 2.0.0 2.0.1 2.0.2 2.0.3 2.1.0 2.1.1 2.1.2 2.1.3 2.1.4 2.2.0 2.2.1 2.2.2 2.2.3 2.2.4 3.0.0 3.1.0 3.1.1 3.2.0 3.2.1 3.3.0 3.3.1 3.4.0)

# If loc.csv already exists remove it (otherwise the new results would be appended to the file)
FILE=/usr/jsinspect-out/loc.csv
if [ -d "$FILE" ]; then
    rm -rf $FILE
fi

echo "Calculating lines of code for every jQuery version..."
# Create new output files with the output of jsinspect run for jQuery source code version pairs
for i in "${versions[@]}"
do
  cloc --include-ext=js --quiet --csv $i | grep -o 'SUM,.*' | awk -F, '{sum=0; for(i=2;i<=NF;i++) {((sum+=$i));} print sum}' >> /usr/jsinspect-out/loc.csv
done

echo "Done"