#!/usr/bin/env ruby
#
# refresh.rb
# (c) 2011, Alex Bevilacqua
#
# This script takes all yaml localization files in the current directory and
# re-orders them so that they appear in alphabetical order.
# It also takes the control (primary) localization file and injects any keys
# that may be missing from the derivative files
###############################################################################
require 'yaml'
$KCODE = 'UTF8' unless RUBY_VERSION >= '1.9'
require 'ya2yaml'

class Hash
  # Replacing the to_yaml function so it'll serialize hashes sorted (by their keys)
  #
  # Original function is in /usr/lib/ruby/1.8/yaml/rubytypes.rb
  def to_yaml( opts = {} )
    YAML::quick_emit( object_id, opts ) do |out|
      out.map( taguri, to_yaml_style ) do |map|
        # sort keys alphabetically
        sort.each do |k, v|
          map.add( k, v )
        end
      end
    end
  end
end

# The "control" file is the one we assume will always have the latest
# translatable fields that should be copied to all other translation files
CONTROL = "en.yml"
ctrl = YAML::load(File.open(CONTROL))

Dir["*.yml"].each do |lang|  
  data = YAML::load(File.open(lang))
  
  unless lang == CONTROL
    # Fill the current translation template with any keys that may be missing
    # from the control template
    # We assume that the YAML struture will always be:
    #   lang:
    #     entry_1: value
    #     entry_2: value
    # so we fetch the first hash value and work the it's children
    ctrl["#{ctrl.keys.first}"].each do |c|
      data["#{data.keys.first}"][c[0]] = c[1] unless data["#{data.keys.first}"].has_key?(c[0]) 
    end
  end
  
  # overwrite the original file with the sorted and refreshed translation files
  file = File.open(lang, 'w')    
  file.write(data.ya2yaml(:syck_compatible => true))
  file.close  
    
end
