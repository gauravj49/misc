# pwd
cd /home/rad/users/gaurav/projects/misc

# Note: sudo for the creation of folders in the mounted points
############### For Users ###################

# 1) Christine Klement
# 1.1) For the first run for ATACseq_MUC001 sampels

# Reverse compliment
ipython
old_chars = "ACGT"
rep_chars = "TGCA"
repreg    = str.maketrans(old_chars,rep_chars)
dnastr    = ['TCGCCTTA','CTAGTACG','TTCTGCCT','GCTCAGGA','AGGAGTCC','CATGCCTA','GTAGAGAG','CCTCTCTG','AGCGTAGC','CAGCCTCG','TGCCTCTT','TCCTCTAC','ATCACGAC','ACAGTGGT','CAGATCCA','TGTGACCA','GAAACCCA','CCCAACCT']
revcomp   = [d.translate(repreg)[::-1] for d in dnastr]

# NOTE: The I7 indexes were reverse complimented before running the demultiplexing. The original_samplesheet.csv has original indexes.
sudo bash scripts/perform_demultiplexing.sh /media/nas/raw/TUM_Nextseq/190808_NB501802_0188_AHKMYFBGXB /media/nas/fastq/Studies/AGRad_ATACseq_MUC001_2 24 /media/rad/SSD1/atac_temp/christine/AGRad_ATACseq_MUC001/demultiplexing "Y76,I8,n8"

# inputDir="/media/rad/SSD1/atac_temp/christine/AGRad_ATACseq_MUC001/demultiplexing/input/190808_NB501802_0188_AHKMYFBGXB"
# outputDir="/media/rad/SSD1/atac_temp/christine/AGRad_ATACseq_MUC001/demultiplexing/output/AGRad_ATACseq_MUC001"
# sudo /usr/local/bin/bcl2fastq -R  ${inputDir} -p 12 --output-dir ${outputDir} --no-lane-splitting --use-bases-mask Y76,I8,n8

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

# 1.2) Test for ChIPseq antibodies
# sudo bash scripts/perform_demultiplexing.sh /media/nas/raw/TUM_Nextseq/191023_NB501802_0215_AHC27TBGXC /media/nas/fastq/Studies/AGRad_ChiPseq_AntibodyTest_1 24 /media/rad/HDD1/temp_chip/AGRad_ChiPseq_AntibodyTest_1/demultiplexing "Y61,I6,Y101"
inputDir="/media/rad/HDD1/temp_chip/AGRad_ChiPseq_AntibodyTest_1/demultiplexing/input/191023_NB501802_0215_AHC27TBGXC"
outputDir="/media/rad/HDD1/temp_chip/AGRad_ChiPseq_AntibodyTest_1/demultiplexing/output/AGRad_ChiPseq_AntibodyTest_1"
sudo /usr/local/bin/bcl2fastq -R  ${inputDir} -p 12 --output-dir ${outputDir} --no-lane-splitting --use-bases-mask Y61,I6,Y101