#!/usr/bin/ruby

$LOAD_PATH.unshift File.dirname(__FILE__) + '/../lib'

require 'rubyrep'

exit RR::SyncRunner.run(ARGV)

