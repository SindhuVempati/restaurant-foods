#### Food Finder ####
#Launch this ruby file from the Terminal to get started


APP_ROOT = File.dirname(__FILE__)

#require "#{APP_ROOT}/lib/guide" #absolute path

## parallel ways for the line 7

#require File.join(APP_ROOT, 'lib', 'guide.rb')
#require File.join(APP_ROOT, 'lib', 'guide')

$:.unshift(File.join(APP_ROOT,'lib'))
require 'guide'


guide = Guide.new('restaurants.txt')
guide.launch!
