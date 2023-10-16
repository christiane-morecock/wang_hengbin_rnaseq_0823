#Alignment
#!/bin/sh
#$ -cwd
#$ -V
#$ -N trim_script_maker
#$ -e ./logs
#$ -o ./logs
###########################################################
#### Edit the following variables ####
MERGED_DIR=$(pwd)/raw_data/
GEN_DIR=/vcu_gpfs2/home/mccbnfolab/Christiane/rnaseq_auto_pipeline/genome_indexes/human/hg38/ref/
GTF_FILE=/vcu_gpfs2/home/mccbnfolab/Christiane/rnaseq_auto_pipeline/genome_indexes/human/hg38/Homo_sapiens.GRCh38.108.gtf
# Species input is MOUSE or HUMAN
SPECIES=HUMAN
FWDSUFFIX=_1.fq.gz
RVSUFFIX=_2.fq.gz
##########################################################
# Stable variables 
SH_DIR=$(pwd)/align_sh
ALIGN_DIR=$(pwd)/output/aligned
COUNTS_DIR=$(pwd)/output/counts
TRIM_DIR=$(pwd)/output/trimmed
FASTQC_POST=$(pwd)/output/fastqc_post
QUALI_DIR=$(pwd)/output/qualimap

##########################################################
if [ ! -d "$OUTPUT_DIR" ]; then
mkdir -p  $SH_DIR $TRIM_DIR $ALIGN_DIR $FASTQC_POST $COUNTS_DIR $QUALI_DIR ${SH_DIR}/logs
fi

write_file(){
	echo "#!/bin/sh" > $3
	echo "#$ -cwd" >> $3
	echo "#$ -e ./logs/" >> $3
	echo "#$ -o ./logs/" >> $3
	echo "#$ -l mem_free=2G" >> $3
	echo "#$ -pe smp 6" >> $3
	echo "##################################"
	
	echo "source /vcu_gpfs2/home/mccbnfolab/enable_pyenv.sh"
	
	echo "#trimmomatic" >> $3
	echo "java -Xmx20G -jar /vcu_gpfs2/home/morecockcm/bin/trimmomatic-0.39/trimmomatic-0.39.jar PE -threads 16 -trimlog $TRIM_DIR/${2}_trimming.log ${1}/${2}${FWDSUFFIX} ${1}/${2}${RVSUFFIX} -baseout $TRIM_DIR/${2}_trimmed.fastq.gz ILLUMINACLIP:/vcu_gpfs2/home/morecockcm/bin/trimmomatic-0.39/adapters/TruSeq3-PE.fa:2:30:10" >> $3


	echo "#alignment" >> $3
	echo "/vcu_gpfs2/home/mccbnfolab/RNA-seq-pipeline/Alignment_tools/STAR-2.7.9a/bin/Linux_x86_64/STAR --runThreadN 16  --genomeDir ${GEN_DIR} --readFilesIn ${TRIM_DIR}/${2}_trimmed_1P.fastq.gz  ${TRIM_DIR}/${2}_trimmed_2P.fastq.gz --readFilesCommand zcat --outFileNamePrefix ${ALIGN_DIR}/${2} --outSAMtype BAM SortedByCoordinate" >> $3

	echo "#featureCounts" >> $3
	echo "/vcu_gpfs2/home/mccbnfolab/RNA-seq-pipeline/FeatureCounts/subread-2.0.2-Linux-x86_64/bin/featureCounts -T 16 -F GTF -t exon -g gene_id -p --countReadPairs -a ${GTF_FILE} -o ${COUNTS_DIR}/${2}.txt ${ALIGN_DIR}/${2}Aligned.sortedByCoord.out.bam" >> $3

	echo "#qualimap bamqc" >> $3
	echo "/vcu_gpfs2/home/mccbnfolab/TycK/tools_kmt/qualimap_v2.2.1/qualimap bamqc -bam ${ALIGN_DIR}/${2}Aligned.sortedByCoord.out.bam -outdir $QUALI_DIR -gd $SPECIES -nt 12 -c -outfile ${2}_bamqc.pdf -outformat PDF:HTML --java-mem-size=2G" >> $3
}

for file in `ls ${MERGED_DIR}/*${FWDSUFFIX}`; \
    do dname=$(dirname ${file}); name=$(basename ${file} ${FWDSUFFIX}); \
    # echo ${dname}/${name}
    write_file ${dname} ${name} ${SH_DIR}/${name}.sh
done
