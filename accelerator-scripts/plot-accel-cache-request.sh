SCRIPT_DIR=$(pwd)
#cd $1
zgrep "Plot" $1 > temp2
cat temp2 | awk -F':' '{print $1 "\t" $2 "\t" $3 "\t" $4 "\t" $5}' > temp3
python ${SCRIPT_DIR}/plot-accel-cache-request.py 
