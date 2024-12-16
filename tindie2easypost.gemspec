# frozen_string_literal: true

Gem::Specification.new do |spec|
  spec.name        = 'tindie2easypost'
  spec.version     = '0.2.0'
  spec.authors     = ['Spencer Owen']
  spec.email       = ['owenspencer@example.com']

  spec.summary     = 'Convert Tindie CSV files to EasyPost shipping format'
  spec.description = 'A utility script to transform Tindie order exports into EasyPost-compatible CSV files for shipping label generation.'
  spec.homepage    = 'https://github.com/spuder/tindie2easypost'
  
  # Specify which files should be included in the gem
  spec.files = Dir.glob(['lib/**/*.rb', 'bin/*', 'README.md'])
  
  # Specify the executable script
  spec.executables = ['tindie2easypost.rb']
  
  # Specify the location of the executable in the gem structure
  spec.bindir      = 'bin'

  # Specify Ruby version requirement
  spec.required_ruby_version = '>= 2.7.0'

  # Add runtime dependencies if any
  spec.add_runtime_dependency 'csv', '~> 3.2'

  # Optional development dependencies
  spec.add_development_dependency 'rake', '~> 13.0'
  spec.add_development_dependency 'minitest', '~> 5.14'

  spec.license     = 'MIT'
end
