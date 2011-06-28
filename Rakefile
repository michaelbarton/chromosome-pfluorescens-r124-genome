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

task :validate => ['validate:database','validate:compare']
namespace :validate do

  task :environment do
    require 'bio'
    require 'fastercsv'
    mkdir 'validate' unless File.exists? 'validate'
    @db = 'validate/db.yml'
  end

  task :database => :environment do
    re = /(\d+)\s(\d+)\sgene.\s+locus_tag\s(R124_\d+)/m
    genome = Bio::FlatFile.auto('out/R124.genome.fsa').first.seq

    original = Bio::FlatFile.auto('annotation/genes.fna').inject(Hash.new) do |h,s|
      h[s.definition.split[1]] = s.seq
      h
    end

    list = 'annotation/gene_list.csv'
    sources = FasterCSV.open(list,:headers => true).inject(Hash.new) do |hash,row|
      hash[row['Locus Tag']] = row['Scaffold Name'].split(' : ').last.gsub('R124_','')
      hash
    end

    db = Hash.new{|hash,key| hash[key] = Hash.new}
    File.read('out/R124.genome.tbl').scan(re) do |entry|

      start,stop,name = *entry
      start = start.to_i - 1
      stop  = stop.to_i - 1

      if start > stop
        start,stop = stop,start
        relocated_seq = genome[start..stop]
        relocated_seq = Bio::Sequence::NA.new(relocated_seq).reverse_complement.upcase
      else
        relocated_seq = genome[start..stop]
      end

      original_seq  = original[name]

      db[name][:source] = sources[name]
      db[name][:relocated] = {
        :start     => start,
        :stop      => stop,
        :sequence  => relocated_seq.to_s
      }
      db[name][:original] = {
        :sequence  => original_seq.to_s
      }
    end
    File.open(@db,'w'){|out| out.print YAML.dump(db)}

  end

  task :compare => :environment do
    db = YAML.load(File.read(@db))
    db.each do |name,data|
      unless data[:original][:sequence] == data[:relocated][:sequence]
        puts name
      end
    end
  end

end


