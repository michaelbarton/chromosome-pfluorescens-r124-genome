SCAFFOLD=assembly/scaffold.yml
SEQUENCE=assembly/sequence.fna
ANNTTION=assembly/annotations.gff
TEMPLATE=submission/template.sbt
COMMENTS=submission/migs.tab

TABLE=genome.tbl
AGP=genome.agp
GFF=genome.gff
GBF=genome.gbf
MAP=genome.map

CONTIG=contig.fsa
GENOME=genome.fsa

GENOMESQN=genome.sqn
CONTIGSQN=contig.sqn

LOG=genome.val

all: $(AGP) $(GENOMESQN) $(CONTIGSQN) $(LOG) $(GFF) $(GBF) $(MAP)

$(GBF): $(GENOME) $(TABLE) $(TEMPLATE)
	tbl2asn -p . -t $(TEMPLATE) -w $(COMMENTS) -V b

$(LOG): $(GENOME) $(TABLE) $(TEMPLATE)
	tbl2asn -p . -M n -t $(TEMPLATE) -Z $@
	rm -f errorsummary.val

$(GENOMESQN): $(GENOME) $(TABLE) $(TEMPLATE)
	tbl2asn -p . -t $(TEMPLATE) -w $(COMMENTS) -i $(GENOME) -c b

$(CONTIGSQN): $(CONTIG) $(TABLE) $(TEMPLATE)
	tbl2asn -p . -M n -t $(TEMPLATE) -w $(COMMENTS) -i $(CONTIG)

$(MAP): $(SCAFFOLD) $(SEQUENCE) $(ANNTTION)
	genomer view mapping					\
		--reset_locus_numbering=52                      \
		--prefix='I1A_'                                 \
		> $@

$(GFF): $(SCAFFOLD) $(SEQUENCE) $(ANNTTION)
	genomer view gff					\
		--reset_locus_numbering=52                      \
		--prefix='I1A_'                                 \
		> $@

$(AGP): $(SCAFFOLD) $(SEQUENCE)
	genomer view agp 	                 \
		| sed 's/specified/align_genus/' \
		| sed 's/internal/paired-ends/'  \
		> $@

$(GENOME): $(SCAFFOLD) $(SEQUENCE)
	genomer view fasta 	                                 \
		--identifier='PRJNA68653'                        \
		--organism='Pseudomonas fluorescens'             \
		--strain='R124'                                  \
		--gcode='11'                                     \
		--topology='circular'                            \
		--isolation-source='Orthoquartzite Cave Surface' \
		--collection-date='17-Oct-2007'                  \
		--completeness='Complete'                        \
		> $@

$(CONTIG): $(SCAFFOLD) $(SEQUENCE)
	genomer view fasta					 \
		--contigs                                        \
		--organism='Pseudomonas fluorescens'             \
		--strain='R124'                                  \
		--gcode='11'                                     \
		--isolation-source='Orthoquartzite Cave Surface' \
		--collection-date='17-Oct-2007'                  \
		--completeness='Complete'                        \
		> $@

$(TABLE): $(SCAFFOLD) $(SEQUENCE) $(ANNTTION)
	genomer view table					\
		--identifier=PRJNA68653                         \
		--reset_locus_numbering=52                      \
		--prefix='I1A_'                                 \
		--generate_encoded_features='gnl|BartonUAkron|' \
		> $@

clean:
	rm -f genome.* rm contig.*
