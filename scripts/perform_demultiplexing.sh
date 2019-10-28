# pwd
jobdir="/home/rad/users/gaurav/projects/misc"
cd ${jobdir}

# Get the user files and directories
rInDir=${1}                     # remote input  directory: "/media/nas/raw/TUM_Nextseq/190808_NB501802_0188_AHKMYFBGXB"
rOpDir=${2}                     # remote output directory: "/media/nas/fastq/Studies/AGRad_ATACseq_MUC001"
numThreads=${3:-"12"}           # -p [ --processing-threads ] number of threads used for processing demultiplexed data
jobdir=${4:-"/home/rad/users/gaurav/projects/misc"}
baseMask=${5:-""}               # Y76,I8,n8

# Get the system variables
bcltofastq=${5:-"$(which bcl2fastq)"}   # /usr/local/bin/bcl2fastq`

# Print Arguments
echo "- Initial arguments:"
echo -e "\t- Remote input  directory: ${rInDir}"
echo -e "\t- Remote output directory: ${rOpDir}"
echo -e "\t- Number of threads used : ${numThreads}"

# Define and create the relevant directories
echo -e "\n- Define and create the relevant directories..."
lInDir="${jobdir}/input/$(basename ${rInDir})"  # local  input  directory: "/home/rad/users/gaurav/projects/misc/input/190808_NB501802_0188_AHKMYFBGXB"
lOpDir="${jobdir}/output/$(basename ${rOpDir})" # local  output directory: "/home/rad/users/gaurav/projects/misc/output/ATACseq_MUC001"
echo -e "\t- Local input  directory: ${lInDir}"
echo -e "\t- Local output directory: ${lOpDir}"
sudo mkdir -p ${rInDir} ${rOpDir} ${lInDir} ${lOpDir}

# Copy the data from the remote directory to the local input directory
echo -e "\n- Copying the data from the remote directory to the local input directory..."
echo -e "- rsync -arvP ${rInDir}/* ${lInDir}"
rsync -arvP ${rInDir}/* ${lInDir}

# Run the demultiplxing
echo -e "\n- Running demultiplexing using bcl2fastq"
echo " eval ${bcl2fastq} -R ${lInDir} -p ${numThreads} --output-dir ${lOpDir} --no-lane-splitting --use-bases-mask ${baseMask}"
# eval ${bcltofastq} -R ${lInDir} -p ${numThreads} --output-dir ${lOpDir} --no-lane-splitting
eval ${bcltofastq} -R ${lInDir} -p ${numThreads} --output-dir ${lOpDir} --no-lane-splitting --use-bases-mask ${baseMask}

# Copy the data back to the remote output directory from the local output directory
echo -e "\n- Copying the data back to the remote output directory from the local output directory..."
echo -e "- rsync -arvP ${lOpDir}/* ${rOpDir}"
rsync -arvP ${lOpDir}/* ${rOpDir}

# Cleanup
echo "- Cleaning up the local folders"
echo -e "\t- Please run the following command after inspection..."
echo -e "\t  rm -rf ${lInDir} ${lOpDir}"
# rm -rf ${lInDir} ${lOpDir}

# /usr/local/bin/bcl2fastq -R /home/rad/users/gaurav/projects/misc/input/190808_NB501802_0188_AHKMYFBGXB -p 12 --output-dir /home/rad/users/gaurav/projects/misc/output/AGRad_ATACseq_MUC001 --no-lane-splitting --use-bases-mask Y76,I6n,nnnnnnnn