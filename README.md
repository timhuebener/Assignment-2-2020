# Assignment-2-2020

Template repository for the second assignment, containing a Docker project that clones the relevant version of jQuery, and sets up a working copy of JsInspect.

# Dockerfile

The docker file sets up a docker image where three things
are prepared:

- `JsInspect` is installed, such that you can run it from the
  command line.
- `Cloc` is installed.
- `bc` is installed (used for mathematical calculations)
- All versions of jQuery specified in `jquery_releases.csv` are
  cloned and downloaded to `/usr/jquery-data`.
- The manually created code clones are copied into the `/usr/manual-clones` folder.
- All the neccessary scripts are copied into the proper folders (`prep.py`, `find_duplicates.sh`, `seaborn_heatmap.py` and `get_loc.sh` into the `/usr/jquery-data`; the `process_outputs` nodejs project to the `/usr` directory).

When running the container a bash shell is opened such that you
can manually execute commands to run JsInspect and cloc, and execute the prepared scripts.

## Using this image

Build using `docker build -t 2imp25-assignment2 .`

Then run using
`docker run -it --rm -v "$PWD/out:/usr/jsinspect-out" 2imp25-assignment2`.
We again mount an out directory linked to the host file system
such that you can copy out files from the container.

When the container is running you can execute bash commands
as if it is a virtual machine.


# Run the manual clone test

In order to run JsInspect on the manually created code clones the following command can be used from the `usr/` directory (note: when the docker container is started the workdir is set to `/usr/jquery-data` so you may have to change directory):

`jsinspect -I -L -t 20 ./manual-clones/`

# Run jsinspect for every source code version pairs of the jQuery and get similarity matrix

In order to run the JsInspect for every two jQuery version the following command can be executed from the `/usr/jquery-data`:

`./find_duplicates.sh`

The following steps will be performed:

1. Run the `jsinspect` for every jQuery source code version pair and save the results into the proper JSON output files.
2. Calculate the **character count** for every version of the **jQuery source code repositories** (_char_count_version_i_).
3. Process the output files of the jsinspect and calculate the character count of the found duplicates for the jQuery source code version pair (_duplicate_char_count_).
4. Calculate the similarity between every jQuery source code version pair in the following way: _similarity_i_j = duplicate_char_count/(char_count_version_i + char_count_version_j)_
5. Create output files that will be used for the heatmap generation:

- print the character counts of jQuery repositories into the `jQuery_sizes_output.csv` file (the first line contains the list of sorted version numbers separated by space, after that the character counts of jQuery versions are listed in separate lines in the same order as they appear in the first row)
- print the matrix of similarities into the `similarities_output.csv` file (the similarity values are separated by comma)

# Get lines of code for every jQuery versions

Run the following command from the `/usr/jquery-data` directory:

`./get_loc.sh`

It will run the `cloc` Unix command with the proper parameters for every jQuery version and write the resulted lines of code into the `loc.csv` file, separated by new lines. (The order of the calculated lines of codes per jQuery version correspond to the order of the jQuery versions sorted numerically.)

# Heatmap

In order to generate the heatmap based on the resulted similarities the following command can be run from the `/usr` directory of the Docker container:

`python seaborn_heatmap.py`

This command will generate a `seaheat.png` image in the mounted `out` output directory.