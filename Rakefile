task :gff do
  require 'fastercsv'
  require 'bio'

  IN  = 'annotation/gene_list.csv'
  OUT = 'annotation/gene_list.gff'

  File.open(OUT,'w') do |out|
    FasterCSV.open(IN,:headers => true).each do |row|

      record = Bio::GFF::GFF3::Record.new(
        row['Scaffold Name'].split(' : ').last.gsub('R124_',''), # Sequence ID
        nil,                                                     # Source
        'CDS',                                                   # Feature Type
        row['Start Coord'].to_i,                                 # Start Position
        row['End Coord'].to_i,                                   # End Position
        nil,                                                     # Score
        row['Strand'],                                           # Strand
        nil,                                                     # Phase
        [['ID',row['Locus Tag']]]                                 # Attributes
      )
      out.puts record
    end
  end
end
