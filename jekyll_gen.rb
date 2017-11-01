class Jekyll
  def initialize(config_file)
    @fields = File.open(config_file) {|f| f.readline}
    @fields_array = fields.chomp.split(",")
    @values = {}
  end

  attr_reader :fields, :fields_array, :values

  def get_values
    fields_array.each do |field|
      next if field == "layout"
      if field == "date"
        values["date"] = Time.now
      else
        puts "#{field}?"
        field == "tags" ? values[field] = [gets.chomp] : values[field] = gets.chomp
      end
    end
  end

  def convert_date
    values["date"].strftime("%Y-%m-%d")
  end

  def convert_title_to_filename
    invalid_chars = '#%&{}\<>*?/$!\'":@'
    converted_title = values["title"].split("").map do |char|
      next if invalid_chars.include?(char)
      char == " " ? "_" : char
    end.join
    convert_date+"-"+converted_title+".txt"
  end

  def create_file
    new_file = File.new(convert_title_to_filename, 'w')
    fields_array.each do |field|
      if field == "layout"
        new_file.puts("layout: post")
      elsif field == "tags"
        new_file.puts(field+": "+"[#{values[field].join(",")}]")
      else
        new_file.puts(field+": "+"#{values[field]}")
      end
    end
    new_file.close
  end
end

j = Jekyll.new("config")
j.get_values
j.create_file
