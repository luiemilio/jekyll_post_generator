#!/usr/bin/env ruby
require 'json'

class Jekyll
  def initialize(config_file)
    config = File.read(config_file)
    @fields = JSON.parse(config)["fields"]
    @filetype = JSON.parse(config)["filetype"]
    @date = Time.now
    @values = {}
  end

  attr_reader :fields, :values, :date, :filetype

  def get_values
    fields.each do |field|
      if field == "date"
        values["date"] = date
      else
        puts "#{field}?"
        field == "tags" ? values[field] = [gets.chomp] : values[field] = gets.chomp
      end
    end
  end

  def convert_date
    date.strftime("%Y-%m-%d")
  end

  def convert_title_to_filename
    invalid_chars = '#%&{}\<>*?/$!\'":@'
    converted_title = values["title"].split("").map do |char|
      next if invalid_chars.include?(char)
      char == " " ? "_" : char
    end.join
    convert_date+"-"+converted_title+".#{filetype}"
  end

  def create_file
    new_file = File.new(convert_title_to_filename, 'w')
    fields.each do |field|
      if field == "tags"
        new_file.puts(field+": "+"[#{values[field].join(",")}]")
      elsif field == "title"
        new_file.puts(field+": "+"\"#{values[field]}\"")
      else
        new_file.puts(field+": "+"#{values[field]}")
      end
    end
    new_file.close
  end
end

j = Jekyll.new("config.json")
j.get_values
j.create_file
