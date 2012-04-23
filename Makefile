SCAFFOLD=assembly/scaffold.yml
SEQUENCE=assembly/sequence.fna
ANNTTION=assembly/sequence.fna
TEMPLATE=submission/template.sbt

TABLE=genome.tbl
FASTA=genome.fsa

genome.sqn: $(FASTA) $(TABLE) $(TEMPLATE)
	tbl2asn -p . -t $(TEMPLATE)

genome.gbf: $(FASTA) $(TABLE) $(TEMPLATE)
	tbl2asn -p . -V b -t $(TEMPLATE)

genome.log: $(FASTA) $(TABLE) $(TEMPLATE)
	tbl2asn -p . -V v -t $(TEMPLATE)
	mv errorsummary.val $@

$(FASTA): $(SCAFFOLD) $(SEQUENCE)
	genomer view fasta                                 \
		--identifier=PRJNA46289                          \
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
