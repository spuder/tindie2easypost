#!/usr/bin/env ruby

require 'csv'
require 'optparse'

class Tindie2EasyPost
  def initialize(input_file, output_file, from_address)
    @input_file = input_file
    @output_file = output_file
    @from_address = from_address
  end

  def convert
    # Read Tindie CSV
    tindie_data = CSV.read(@input_file, headers: true)

    # Prepare EasyPost CSV headers
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

    # Write EasyPost CSV
    CSV.open(@output_file, 'w') do |csv|
      csv << easypost_headers

      # Predefined from address values
      from_address_values = [
        @from_address[:name],                       # from_address.name
        @from_address[:company],                    # from_address.company
        @from_address[:phone],                      # from_address.phone
        @from_address[:email],                      # from_address.email
        @from_address[:street1],                    # from_address.street1
        @from_address[:street2] || '',              # from_address.street2
        @from_address[:city],                       # from_address.city
        @from_address[:state],                      # from_address.state
        @from_address[:zip],                        # from_address.zip
        @from_address[:country],                    # from_address.country
      ]

      tindie_data.each do |row|
        # Map Tindie data to EasyPost format
        easypost_row = [
          # To Address
          "#{row['First Name']} #{row['Last Name']}",  # to_address.name
          row['Company'],                             # to_address.company
          row['Phone'],                               # to_address.phone
          row['Email'],                               # to_address.email
          row['Street'],                              # to_address.street1
          '',                                         # to_address.street2 (empty if not in Tindie)
          row['City'],                                # to_address.city
          row['State/Province'],                      # to_address.state
          row['Postal/Zip Code'],                     # to_address.zip
          row['Country'],                             # to_address.country

          # From Address (using predefined values)
          *from_address_values,

          # Parcel details (you'll need to customize these)
          '',  # parcel.length
          '',  # parcel.width
          '',  # parcel.height
          '',  # parcel.weight
          '',  # parcel.predefined_package
          '',  # carrier
          row['Shipping Method']  # service
        ]

        csv << easypost_row
      end
    end

    puts "Conversion complete. Output saved to #{@output_file}"
  end
end

# Command-line argument parsing
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
      name: from_details[0],
      company: from_details[1],
      phone: from_details[2],
      email: from_details[3],
      street1: from_details[4],
      street2: from_details[5],
      city: from_details[6],
      state: from_details[7],
      zip: from_details[8],
      country: from_details[9]
    }
  end
end.parse!

# Validate required arguments
unless options[:input] && options[:output] && options[:from_address]
  puts "Error: Missing required arguments"
  puts "Usage: ruby tindie2easypost.rb -i input.csv -o output.csv -f 'Your Name,Your Company,Phone,Email,Street1,Street2,City,State,Zip,Country'"
  exit 1
end

# Run conversion
converter = Tindie2EasyPost.new(
  options[:input], 
  options[:output], 
  options[:from_address]
)
converter.convert
