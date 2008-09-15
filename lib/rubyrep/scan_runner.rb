$LOAD_PATH.unshift File.dirname(__FILE__) + '/../lib'

module RR
  # This class implements the functionality of the rrscan.rb command.
  class ScanRunner < BaseRunner
    # Creates the correct scan class.
    # Parameters as defined under BaseRunner#create_processor
    def create_processor(session, left_table, right_table)
      TableScanHelper.scan_class(session).new session, left_table, right_table
    end
  end
end


