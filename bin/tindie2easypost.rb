#!/usr/bin/env ruby

require 'csv'
require 'optparse'

class Tindie2EasyPost
  def initialize(input_file, output_file, from_address, package_params)
    @input_file = input_file
    @output_file = output_file
    @from_address = from_address
    @package_params = package_params
  end

  def convert
    tindie_data = CSV.read(@input_file, headers: true)

    easypost_headers = [
      'to_address.name', 'to_address.company', 'to_address.phone', 'to_address.email',
      'to_address.street1', 'to_address.street2', 'to_address.city', 'to_address.state', 
      'to_address.zip', 'to_address.country',
      'from_address.name', 'from_address.company', 'from_address.phone', 'from_address.email',
      'from_address.street1', 'from_address.street2', 'from_address.city', 'from_address.state', 
      'from_address.zip', 'from_address.country',
      'parcel.length', 'parcel.width', 'parcel.height', 'parcel.weight', 
      'parcel.predefined_package', 'carrier', 'service'
    ]

    CSV.open(@output_file, 'w') do |csv|
      csv << easypost_headers

      from_address_values = [
        @from_address[:name], @from_address[:company], @from_address[:phone], @from_address[:email],
        @from_address[:street1], @from_address[:street2] || '', @from_address[:city], @from_address[:state],
        @from_address[:zip], @from_address[:country],
      ]

      tindie_data.each do |row|
        easypost_row = [
          "#{row['First Name']} #{row['Last Name']}", row['Company'], row['Phone'], row['Email'],
          row['Street'], '', row['City'], row['State/Province'], row['Postal/Zip Code'], row['Country'],
          *from_address_values,
          @package_params[:length], @package_params[:width], @package_params[:height], @package_params[:weight],
          @package_params[:predefined_package],
          'USPS', 'GroundAdvantage'
        ]

        csv << easypost_row
      end
    end

    puts "Conversion complete. Output saved to #{@output_file}"
  end
end

options = {}
OptionParser.new do |opts|
  opts.banner = "Usage: tindie2easypost.rb [options]"

  opts.on("-i", "--input INPUT", "Input Tindie CSV file") do |input|
    options[:input] = input
  end

  opts.on("-o", "--output OUTPUT", "Output EasyPost CSV file") do |output|
    options[:output] = output
  end

  opts.on("-f", "--from NAME,COMPANY,PHONE,EMAIL,STREET1,STREET2,CITY,STATE,ZIP,COUNTRY", Array, "From Address Details") do |from_details|
    options[:from_address] = {
      name: from_details[0], company: from_details[1], phone: from_details[2], email: from_details[3],
      street1: from_details[4], street2: from_details[5], city: from_details[6], state: from_details[7],
      zip: from_details[8], country: from_details[9]
    }
  end

  opts.on("-p", "--package LENGTH,WIDTH,HEIGHT,WEIGHT", Array, "Package dimensions and weight") do |package|
    options[:package_params] = {
      length: package[0], width: package[1], height: package[2], weight: package[3],
      predefined_package: ''
    }
  end

  opts.on("-d", "--predefined PACKAGE", "Predefined package type") do |predefined|
    options[:package_params] = {
      length: '', width: '', height: '', weight: '',
      predefined_package: predefined
    }
  end
end.parse!

unless options[:input] && options[:output] && options[:from_address] && (options[:package_params])
  puts "Error: Missing required arguments"
  puts "Usage: ruby tindie2easypost.rb -i input.csv -o output.csv -f 'Name,Company,Phone,Email,Street1,Street2,City,State,Zip,Country' (-p LENGTH,WIDTH,HEIGHT,WEIGHT | -d PREDEFINED_PACKAGE)"
  exit 1
end

converter = Tindie2EasyPost.new(
  options[:input], 
  options[:output], 
  options[:from_address],
  options[:package_params]
)
converter.convert
