# Assignment-2-2020

Template repository for the second assignment, containing a Docker project that clones the relevant version of jQuery, and sets up a working copy of JsInspect.

# Dockerfile

The docker file sets up a docker image where three things
are prepared:

- JsInspect is installed, such that you can run it from the
  command line.
- Cloc is installed.
- All versions of jQuery specified in `jquery_releases.csv` are
  cloned and downloaded to `/usr/jquery-data`.

When running the container a bash shell is opened such that you
can manually execute commands to run JsInspect and cloc.

## Using this image

Build using `docker build -t 2imp25-assignment2 .`

Then run using
`docker run -it --rm -v "$PWD/out:/usr/jsinspect-out" 2imp25-assignment2`.
We again mount an out directory linked to the host file system
such that you can copy out files from the container.

When the container is running you can execute bash commands
as if it is a virtual machine.

# Suggestions

This repository does not contain all files and steps needed to
run the analysis for assignment 2. To analyze the capability of
JsInspect to detect various clones you could for instance
consider expanding the `Dockerfile` to copy in the manually
constructed clones to a directory `/usr/manual-clones`. Such
that you can then run JsInspect on those files.

# Run the manual clone test

`jsinspect -I -L -t 20 ./manual-clones/`

# Run jsinspect for every source code version pairs of the jQuery

`./find_duplicates.sh`

The following steps will be performed:

1. Run the `jsinspect` for every jQuery source code version pair and save the results into the proper JSON output files.
2. Calculate the **character count** for every version of the **jQuery source code repositories** (_char_count_version_i_).
3. Process the output files of the jsinspect and calculate the character count of the found duplicates for the jQuery source code version pair (_duplicate_char_count_).
4. Calculate the similarity between every jQuery source code version pair in the following way: _similarity_i_j = duplicate_char_count/(char_count_version_i + char_count_version_j)_
5. Create output files that will be used for the heatmap generation:

- print the character counts of jQuery repositories into the `jQuery_sizes_output.csv` file (the first line contains the list of sorted version numbers separated by space, after that the character counts of jQuery versions are listed in separate lines in the same order as they appear in the first row)
- print the matrix of similarities into the `similarities_output.csv` file (the first line contains the list of sorted version numbers separated by space, after that the similarity matrix between the versions is printed, the rows and columns correspond to the versions in the same order as they appear in the first row)

# Get lines of code for every jQuery versions

`./get_loc.sh`

It will run the `cloc` Unix command with the proper parameters for every jQuery version and write the resulted lines of code into the `loc.csv` file, separated by new lines. (The order of the calculated lines of codes per jQuery version correspond to the order of the jQuery versions sorted numerically.)
