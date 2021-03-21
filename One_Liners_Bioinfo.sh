# Obtain md5 checksums of FASTQ files:
ls *.fq | parallel md5sum {} > Checksums.txt

# Convert FASTQ to FASTA:
awk 'NR%4==1{print ">"substr($0,2)}NR%4==2{print $0}' in.fq > out.fa

# Split multi-FASTA file into individual FASTA files:
awk '/^>/ {tmp=substr($0,2) ".fa"}; {print >> tmp; close(tmp)}' in.fa

# Extract FASTA sequences from in.fa using IDs stored in ID.txt:
perl -ne 'if(/^>(\S+)/){$p=$i{$1}}$p?print:chomp;$i{$_}=1 if @ARGV' ID.txt in.fa

# Linearize multi-FASTA sequences:
awk '/^>/ {printf("%s%s\t",(N>0?"\n":""),$0);N++;next;} {printf("%s",$0);} END {printf("\n");}' in.fa

# Sequence length of every entry in a multifasta file:
awk '/^>/ {if (seqlen){print seqlen}; print ;seqlen=0;next;}{seqlen = seqlen + length($0)} END {print seqlen}' in.fa

# Convert two column file format to FASTA format:
awk '{print ">" $1,"\n" $2;}' in.txt

# Compute all occurrences and start-end positions of the motif TCTAWA in a FASTA file:
# One great option is to install SeqKit and run it as:

  seqkit locate --ignore-case --degenerate --pattern TCTAWA in.fa
# In the case above, we are asking seqkit to locate all the positions of the degenerate motif TCTAWA in a FASTA file (in.fa). In case we have multiple motifs to test, we can just assemble them in a FASTA format (motifs.fa file):

  seqkit locate --ignore-case --degenerate -f motifs.fa in.fa
  
# Run FASTQC on your FASTQ files:
# First install FASTQC (for example using brew):

  brew install fastqc
# Then simply run (if you want to do it in parallel 12 jobs at a time):

  find *.fq | parallel -j 12 "fastqc {} --outdir ."
# This will produce a FASTQC HTML report and a ZIP file containing all associated files.
