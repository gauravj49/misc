# pwd
cd /home/rad/users/gaurav/projects/misc

# Note: sudo for the creation of folders in the mounted points
############### For Users ###################

# 1) Christine Klement
# 1.1) For the first run for ATACseq_MUC001 sampels
# NOTE: The I7 indexes were reverse complimented before running the demultiplexing. The original_samplesheet.csv has original indexes.
# sudo bash scripts/perform_demultiplexing.sh /media/nas/raw/TUM_Nextseq/190808_NB501802_0188_AHKMYFBGXB /media/nas/fastq/Studies/AGRad_ATACseq_MUC001
inputDir="/home/rad/users/gaurav/projects/misc/input/190808_NB501802_0188_AHKMYFBGXB"
outputDir="/home/rad/users/gaurav/projects/misc/output/AGRad_ATACseq_MUC001"
sudo /usr/local/bin/bcl2fastq -R  ${inputDir} -p 12 --output-dir ${outputDir} --no-lane-splitting --use-bases-mask Y76,I8,n8

# Run fastqc
fastqcDir="${outputDir}/fastqc"; mkdir -p ${fastqcDir}
allFq=$(ls ${outputDir}/{5,6}*.gz)
parallel '\
fastqcDir="${outputDir}/fastqc"
f={} ;\
echo "${fastqcDir}/${f}" ;\
fastqc ${f} -o ${fastqcDir} -q ;\
' ::: ${allFq} 

# Run multiqc
multiqcDir="${outputDir}/multiqc"; mkdir -p ${multiqcDir}
multiqc -o ${multiqcDir} -n AGRad_ATACseq_MUC001 ${outputDir}
