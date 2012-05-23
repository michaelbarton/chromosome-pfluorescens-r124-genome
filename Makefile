SCAFFOLD=assembly/scaffold.yml
SEQUENCE=assembly/sequence.fna
ANNTTION=assembly/sequence.fna
TEMPLATE=submission/template.sbt

TABLE=genome.tbl
AGP=genome.agp

CONTIG=contig.fsa
GENOME=genome.fsa

GENOMESQN=genome.sqn
CONTIGSQN=contig.sqn

LOG=genome.val

all: $(AGP) $(GENOMESQN) $(CONTIGSQN) $(LOG)

$(LOG): $(GENOME) $(TABLE) $(TEMPLATE)
	tbl2asn -p . -M n -t $(TEMPLATE) -Z $@
	rm -f errorsummary.val

$(GENOMESQN): $(GENOME) $(TABLE) $(TEMPLATE)
	tbl2asn -p . -t $(TEMPLATE) -i $(GENOME) -c b

$(CONTIGSQN): $(CONTIG) $(TABLE) $(TEMPLATE)
	tbl2asn -p . -M n -t $(TEMPLATE) -i $(CONTIG)

$(AGP): $(SCAFFOLD) $(SEQUENCE)
	genomer view agp \
		| sed -R 's/specified/align_genus/' \
		| sed -R 's/internal/paired-ends/'   \
		> $@

$(GENOME): $(SCAFFOLD) $(SEQUENCE)
	genomer view fasta                                 \
		--identifier='PRJNA46289'                        \
		--organism='Pseudomonas fluorescens'             \
		--strain='R124'                                  \
		--gcode='11'                                     \
		--topology='circular'                            \
		--isolation-source='Orthoquartzite Cave Surface' \
		--collection-date='17-Oct-2007'                  \
		--completeness='Complete'                        \
		> $@

$(CONTIG): $(SCAFFOLD) $(SEQUENCE)
	genomer view fasta                                 \
		--contigs                                        \
		--organism='Pseudomonas fluorescens'             \
		--strain='R124'                                  \
		--gcode='11'                                     \
		--isolation-source='Orthoquartzite Cave Surface' \
		--collection-date='17-Oct-2007'                  \
		--completeness='Complete'                        \
		> $@

$(TABLE): $(SCAFFOLD) $(SEQUENCE) $(ANNTTION)
	genomer view table                                \
		--identifier=PRJNA46289                         \
		--reset_locus_numbering=52                      \
		--prefix='E1A_'                                 \
		--generate_encoded_features='gnl|BartonUAkron|' \
		> $@

clean:
	rm -f genome.* rm contig.*
