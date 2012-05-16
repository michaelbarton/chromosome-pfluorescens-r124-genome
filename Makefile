SCAFFOLD=assembly/scaffold.yml
SEQUENCE=assembly/sequence.fna
ANNTTION=assembly/sequence.fna
TEMPLATE=submission/template.sbt

TABLE=genome.tbl
CONTIGS=genome.contigs
FASTA=genome.fsa
AGP=genome.agp
SQN=genome.sqn
LOG=genome.val

all: $(AGP) $(SQN) $(LOG)

$(LOG): $(FASTA) $(TABLE) $(TEMPLATE)
	tbl2asn -p . -M n -t $(TEMPLATE) -Z $@
	rm -f errorsummary.val

$(SQN): $(FASTA) $(TABLE) $(TEMPLATE)
	tbl2asn -p . -t $(TEMPLATE)

$(AGP): $(SCAFFOLD) $(SEQUENCE)
	genomer view agp > $@

$(FASTA): $(SCAFFOLD) $(SEQUENCE)
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

$(CONTIGS): $(SCAFFOLD) $(SEQUENCE)
	genomer view fasta                                 \
		--contigs                                        \
		--organism='Pseudomonas fluorescens'             \
		--strain='R124'                                  \
		--gcode='11'                                     \
		--topology='circular'                            \
		--isolation-source='Orthoquartzite Cave Surface' \
		--collection-date='17-Oct-2007'                  \
		--completeness='Complete'                        \
		> $@

$(TABLE): $(SCAFFOLD) $(SEQUENCE) $(ANNTTION)
	genomer view table                                \
		--identifier=PRJNA46289                         \
		--reset_locus_numbering                         \
		--prefix='E1O_'                                 \
		--generate_encoded_features='gnl|BartonUAkron|' \
		> $@

clean:
	rm genome.*
