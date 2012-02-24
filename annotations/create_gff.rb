#!/usr/bin/env ruby
require 'csv'
require 'yaml'
require 'bio'

raw       = File.join(File.dirname(__FILE__),'gene_list.csv')
name_file = File.join(File.dirname(__FILE__),'names.yml')
output    = File.join(File.dirname(__FILE__),'..','assembly','annotations.gff')

names = YAML.load(File.read(name_file))

gffs = CSV.read(raw).map do |line|
  id, start, stop, strand, gc, _, _, product, source = line
  name = names[id.to_i]
  source = source.split(" : ").last.gsub(',','').gsub('R124_','')

  attr = {'ID' => id, 'product' => product}
  attr['Name'] = name if name

  Bio::GFF::GFF3::Record.new(source,nil,'gene',start,stop,nil,strand,nil,attr)
end

File.open(output,'w') do |out|
  out << "##gff-version 3\n"
  gffs.each do |gff|
    out << gff.to_s
  end
end
