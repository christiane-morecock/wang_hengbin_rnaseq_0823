#!/bin/sh
#$ -cwd
#$ -e ./logs/
#$ -o ./logs/
#$ -l mem_free=2G
#$ -pe smp 6
#trimmomatic
java -Xmx20G -jar /vcu_gpfs2/home/morecockcm/bin/trimmomatic-0.39/trimmomatic-0.39.jar PE -threads 16 -trimlog /vcu_gpfs2/home/mccbnfolab/Christiane/wang_hengbin/wang_hengbin_rnaseq_0823/output/trimmed/OVCAR3FCU6_trimming.log /vcu_gpfs2/home/mccbnfolab/Christiane/wang_hengbin/wang_hengbin_rnaseq_0823/raw_data/OVCAR3FCU6_1.fq.gz /vcu_gpfs2/home/mccbnfolab/Christiane/wang_hengbin/wang_hengbin_rnaseq_0823/raw_data/OVCAR3FCU6_2.fq.gz -baseout /vcu_gpfs2/home/mccbnfolab/Christiane/wang_hengbin/wang_hengbin_rnaseq_0823/output/trimmed/OVCAR3FCU6_trimmed.fastq.gz ILLUMINACLIP:/vcu_gpfs2/home/morecockcm/bin/trimmomatic-0.39/adapters/TruSeq3-PE.fa:2:30:10
#alignment
/vcu_gpfs2/home/mccbnfolab/RNA-seq-pipeline/Alignment_tools/STAR-2.7.9a/bin/Linux_x86_64/STAR --runThreadN 16  --genomeDir /vcu_gpfs2/home/mccbnfolab/Christiane/rnaseq_auto_pipeline/genome_indexes/human/hg38/ref/ --readFilesIn /vcu_gpfs2/home/mccbnfolab/Christiane/wang_hengbin/wang_hengbin_rnaseq_0823/output/trimmed/OVCAR3FCU6_trimmed_1P.fastq.gz  /vcu_gpfs2/home/mccbnfolab/Christiane/wang_hengbin/wang_hengbin_rnaseq_0823/output/trimmed/OVCAR3FCU6_trimmed_2P.fastq.gz --readFilesCommand zcat --outFileNamePrefix /vcu_gpfs2/home/mccbnfolab/Christiane/wang_hengbin/wang_hengbin_rnaseq_0823/output/aligned/OVCAR3FCU6 --outSAMtype BAM SortedByCoordinate
#featureCounts
/vcu_gpfs2/home/mccbnfolab/RNA-seq-pipeline/FeatureCounts/subread-2.0.2-Linux-x86_64/bin/featureCounts -T 16 -F GTF -t exon -g gene_id -p --countReadPairs -a /vcu_gpfs2/home/mccbnfolab/Christiane/rnaseq_auto_pipeline/genome_indexes/human/hg38/Homo_sapiens.GRCh38.108.gtf -o /vcu_gpfs2/home/mccbnfolab/Christiane/wang_hengbin/wang_hengbin_rnaseq_0823/output/counts/OVCAR3FCU6.txt /vcu_gpfs2/home/mccbnfolab/Christiane/wang_hengbin/wang_hengbin_rnaseq_0823/output/aligned/OVCAR3FCU6Aligned.sortedByCoord.out.bam
#qualimap bamqc
/vcu_gpfs2/home/mccbnfolab/TycK/tools_kmt/qualimap_v2.2.1/qualimap bamqc -bam /vcu_gpfs2/home/mccbnfolab/Christiane/wang_hengbin/wang_hengbin_rnaseq_0823/output/aligned/OVCAR3FCU6Aligned.sortedByCoord.out.bam -outdir /vcu_gpfs2/home/mccbnfolab/Christiane/wang_hengbin/wang_hengbin_rnaseq_0823/output/qualimap -gd HUMAN -nt 12 -c -outfile OVCAR3FCU6_bamqc.pdf -outformat PDF:HTML --java-mem-size=2G
