#!/usr/bin/env ruby
require 'csv'
require 'yaml'
require 'bio'

raw       = File.join(File.dirname(__FILE__),'gene_list.csv')
name_file = File.join(File.dirname(__FILE__),'names.yml')
good_out   = File.join(File.dirname(__FILE__),'..','assembly','annotations.gff')
bad_out    = File.join(File.dirname(__FILE__),'..','assembly','bad.gff')

names = YAML.load(File.read(name_file))

gffs = CSV.read(raw).map do |line|
  id, start, stop, strand, gc, _, _, product, source = line
  name = names[id.to_i]
  source = source.split(" : ").last.gsub(',','').gsub('R124_','')

  attr = {'ID' => id, 'product' => product.gsub('%2C',',')}
  attr['Name'] = name if name

  Bio::GFF::GFF3::Record.new(source,nil,'gene',start,stop,nil,strand,nil,attr)
end


gffs.map! do |record|
  attributes = Hash[record.attributes]

  attributes['product'] = attributes['product'].
    gsub(/\(\sEC:([^)]*)\s\)/,'').
    gsub(/Predicted /,'').
    gsub(/\(\s([a-z]+RNA)\s\)/){ $1 }.
    strip

  record.attributes = attributes
  record
end

good = Array.new
bad  = Array.new
gffs.each do |record|
  attributes = Hash[record.attributes]

  case attributes['product']
  when /Uncharacterized|hypothetical protein|Protein of unknown|Domain of Unknown/
    attributes.delete('product') if attributes['Name']
    record.attributes = attributes
    good << record
  when /[a-z]+RNA/
    good << record
  else
    bad << record
  end

end

File.open(good_out,'w') do |out|
  out << "##gff-version 3\n"
  good.each do |gff|
    out << gff.to_s
  end
end

File.open(bad_out,'w') do |out|
  out << "##gff-version 3\n"
  bad.sort_by{|i| i.attributes['product']}.each do |gff|
    out << gff.to_s
  end
end
