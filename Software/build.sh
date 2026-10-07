clear
rm -rf build

build_ut=false
output_directory="build"

# Prints usage of the script.
print_usage() {
  printf "Usage: 
  -c <config>
  -t build unit tests
  "
}

# Creates output directory with name of used configuration.
configure_output_directory() {
	mkdir -p $output_directory
	cd $output_directory
	mkdir -p $config
	cd $config
}

# Parses the input flags.
while getopts 'c:t' flag; do
  case "${flag}" in
    c) config=${OPTARG};;
    t) build_ut='true' ;;
    *) print_usage
       exit 1 ;;
  esac
done

if [ "$config" = "" ]; then
	echo "No config provided."
	echo "Possible targets:"
	ls targets
	print_usage
	exit 1
fi

configure_output_directory

cmake ../.. \
	-DCMAKE_BUILD_TYPE=Debug \
	-DCONFIG=$config\ 	
make all -j8

if [ "$build_ut" = true ]; then
	# Run tests with enabled coverage.
	ctest \
	 && lcov -c -d . -o code_coverage.info \
	 && genhtml code_coverage.info --output-directory coverage
	cd ..
fi