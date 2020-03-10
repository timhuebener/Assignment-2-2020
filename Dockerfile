FROM python:3.6-slim

RUN apt-get update && apt-get install -y curl

RUN curl -sL https://deb.nodesource.com/setup_13.x | bash - && apt-get install -y git nodejs cloc

RUN apt-get install -y bc

RUN pip install seaborn

WORKDIR /usr/manual-clones

COPY /manual-clones .

WORKDIR /usr/jquery-data

COPY prep.py .

COPY jquery_releases.csv .

RUN python prep.py

RUN rm -rf jquery_releases.csv

COPY find_duplicates.sh .

COPY get_loc.sh .

# Docker caches results, so if you want to add custom steps to this dockerfile
# (maybe you want to copy in more files) then consider adding these steps below here.
# Otherwise you will need to download all versions of jQuery everytime you add new 
# steps. 

WORKDIR /usr

COPY process_outputs process_outputs

COPY seaborn_heatmap.py seaborn_heatmap.py

COPY jsinspect jsinspect

RUN npm install -g ./jsinspect

WORKDIR /usr/process_outputs

RUN npm install

# Increase the amount of memory nodejs can allocate, this
# prevents JsInspect from running into the GC issues. 
ENV NODE_OPTIONS=--max-old-space-size=4000

WORKDIR /usr/jquery-data

# Open a bash prompt, such that you can execute commands 
# such as `cloc`. 
ENTRYPOINT ["bash"]