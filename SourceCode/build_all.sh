rm -rf build

config_list=`ls targets`
for config in $config_list
do
   ./build.sh -c $config 
done