all: build

build: genome.sqn

genome.fsa:
	genomer view fasta                                 \
		--identifier=PRJNA46289                          \
		--organism='Pseudomonas fluorescens'             \
		--strain='R124'                                  \
		--gcode='11'                                     \
		--topology='circular'                            \
		--isolation-source='Orthoquartzite Cave Surface' \
		--collection-date='17-Oct-2007'                  \
		--completeness='Complete'                        \
		> genome.fsa

genome.tbl:
	genomer view table                                \
		--identifier=PRJNA46289                         \
		--reset_locus_numbering                         \
		--prefix='E1O_'                                 \
		--generate_encoded_features='gnl|BartonUAkron|' \
		> genome.tbl

genome.sqn: genome.fsa genome.tbl submission/template.sbt
	tbl2asn -p . -t submission/template.sbt

genome.gbf: genome.fsa genome.tbl submission/template.sbt
	tbl2asn -p . -V b -t submission/template.sbt

genome.log: genome.fsa genome.tbl submission/template.sbt
	tbl2asn -p . -V v -t submission/template.sbt
	mv errorsummary.val genome.log

clean:
	rm genome.*
