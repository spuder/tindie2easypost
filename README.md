# Tindie2EasyPost CSV Converter

## Overview

This Ruby script converts CSV files exported from Tindie into a format compatible with EasyPost shipping labels. It helps streamline the process of preparing shipping information for small businesses and online sellers.

## Features

- Converts Tindie order CSV to EasyPost-compatible CSV
- Command-line interface for easy use
- Flexible from-address configuration
- Simple and straightforward conversion process

## Prerequisites

- Ruby (version 2.7 or higher recommended)
- Basic command-line knowledge

## Installation

1. Clone this repository:
   ```bash
   git clone https://github.com/yourusername/tindie2easypost.git
   cd tindie2easypost
   ```

2. Ensure you have Ruby installed:
   ```bash
   ruby --version
   ```

## Usage

### Basic Usage

```bash
ruby tindie2easypost.rb -i input_tindie_orders.csv -o output_easypost_orders.csv -f 'Your Name,Your Company,Your Phone,Your Email,Your Street,Unit/Suite,Your City,Your State,Your Zip,Your Country'
```


### Command-Line Arguments

- `-i` or `--input`: Path to the input Tindie CSV file (required)
- `-o` or `--output`: Path for the output EasyPost CSV file (required)
- `-f` or `--from`: Sender's address details, comma-separated in this order:
  1. Name
  2. Company
  3. Phone
  4. Email
  5. Street Address
  6. Street Address Line 2 (optional)
  7. City
  8. State
  9. Zip/Postal Code
  10. Country
- `-p` or `--package`: Package dimensions and weight, comma-separated (LENGTH,WIDTH,HEIGHT,WEIGHT)
- `-d` or `--predefined`: Predefined package type

Note: You must use either `-p` or `-d`, but not both.

### Example

```bash
ruby tindie2easypost.rb -i december_orders.csv -o easypost_shipping.csv -f 'John Doe,Acme Widgets,555-123-4567,john@example.com,123 Business St,Suite 100,Anytown,CA,90210,USA'
```

With package dimensions
```bash
ruby tindie2easypost.rb -i december_orders.csv -o easypost_shipping.csv -f 'John Doe,Acme Widgets,555-123-4567,john@example.com,123 Business St,Suite 100,Anytown,CA,90210,USA' -p 10,8,6,16
```

With predefined package type
```bash
ruby tindie2easypost.rb -i december_orders.csv -o easypost_shipping.csv -f 'John Doe,Acme Widgets,555-123-4567,john@example.com,123 Business St,Suite 100,Anytown,CA,90210,USA' -d "SmallFlatRateBox"
```

## Limitations

- Parcel details (weight, dimensions) are not automatically populated
- Carrier information is not automatically filled
- Assumes a consistent sender address for all orders
- Assumes user wants `USPS GroundAdvantage` Service

## Customization

If you need to add parcel details or carrier information, you can modify the script directly in the conversion method.

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## License

Distributed under the MIT License. See `LICENSE` for more information.
