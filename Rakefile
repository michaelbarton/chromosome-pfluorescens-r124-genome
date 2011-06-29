task :gff do
  require 'fastercsv'
  require 'bio'

  IN  = 'annotation/gene_list.csv'
  OUT = 'annotation/gene_list.gff'

  File.open(OUT,'w') do |out|
    FasterCSV.open(IN,:headers => true).each_with_index do |row,i|

      record = Bio::GFF::GFF3::Record.new(
        row['Scaffold Name'].split(' : ').last.gsub('R124_',''), # Sequence ID
        nil,                                                     # Source
        'gene',                                                  # Feature Type
        row['Start Coord'].to_i,                                 # Start Position
        row['End Coord'].to_i,                                   # End Position
        nil,                                                     # Score
        row['Strand'],                                           # Strand
        nil,                                                     # Phase
        [['ID',row['Locus Tag']]]                                # Attributes
      )
      out.puts record

      record = Bio::GFF::GFF3::Record.new(
        row['Scaffold Name'].split(' : ').last.gsub('R124_',''), # Sequence ID
        nil,                                                     # Source
        'mRNA',                                                  # Feature Type
        row['Start Coord'].to_i,                                 # Start Position
        row['End Coord'].to_i,                                   # End Position
        nil,                                                     # Score
        row['Strand'],                                           # Strand
        nil,                                                     # Phase
        [['Parent',row['Locus Tag']],['ID',"mrna#{i}"]]          # Attributes
      )
      out.puts record

      record = Bio::GFF::GFF3::Record.new(
        row['Scaffold Name'].split(' : ').last.gsub('R124_',''), # Sequence ID
        nil,                                                     # Source
        'CDS',                                                   # Feature Type
        row['Start Coord'].to_i,                                 # Start Position
        row['End Coord'].to_i,                                   # End Position
        nil,                                                     # Score
        row['Strand'],                                           # Strand
        nil,                                                     # Phase
        [['Parent',"mrna#{i}"],
         ['ID',"cds#{i}"],
         ['product','hypotheical protein']]                 # Attributes
      )
      out.puts record
    end
  end
end

task :draft do
  require 'bio'
  files = %W|scaffolds contigs pcr_sequences insilico_reassembly|
  sequences = files.inject(Hash.new) do |hash,file|
    Bio::FlatFile.open("raw_sequence/#{file}.fna").each do |entry|
      hash[entry.definition] = entry
    end
    hash
  end
  output = Array.new
  YAML.load(File.read('assembly/genome.scaffold.yml')).each do |entry|
    if entry["sequence"]
      output << sequences[entry["sequence"]["source"]]
      if entry["sequence"]["inserts"]
        entry["sequence"]["inserts"].each do |insert|
          output << sequences[insert["source"]]
        end
      end
    end
  end
  File.open("assembly/draft.fna",'w') do |out|
    output.sort_by{|i| i.definition}.uniq.each{|i| out.print i}
  end
end
