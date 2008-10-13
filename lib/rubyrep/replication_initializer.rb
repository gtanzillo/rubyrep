$LOAD_PATH.unshift File.dirname(__FILE__) + '/..'

require 'rubyrep'

module RR

  # Ensures all preconditions are met to start with replication
  class ReplicationInitializer

    # The active Session
    attr_accessor :session

    # Creates a new RepInititializer for the given Session
    def initialize(session)
      self.session = session
    end

    # Returns the options for the given table.
    # If table is +nil+, returns general options.
    def options(table = nil)
      if table
        session.configuration.options_for_table table
      else
        session.configuration.options
      end
    end

    # Creates a trigger logging all table changes
    # * database: either :+left+ or :+right+
    # * table: name of the table
    def create_trigger(database, table)
      options = self.options(table)

      params = {
        :trigger_name => "#{options[:rep_prefix]}_#{table}",
        :table => table,
        :keys => session.send(database).primary_key_names(table),
        :log_table => "#{options[:rep_prefix]}_change_log",
        :activity_table => "#{options[:rep_prefix]}_active",
        :key_sep => options[:key_sep],
        :exclude_rubyrep_activity => true,
      }

      session.send(database).create_replication_trigger params
    end

    # Returns +true+ if the replication trigger for the given table exists.
    # * database: either :+left+ or :+right+
    # * table: name of the table
    def trigger_exists?(database, table)
      trigger_name = "#{options(table)[:rep_prefix]}_#{table}"
      session.send(database).replication_trigger_exists? trigger_name, table
    end

    # Drops the replication trigger of the named table.
    # * database: either :+left+ or :+right+
    # * table: name of the table
    def drop_trigger(database, table)
      trigger_name = "#{options(table)[:rep_prefix]}_#{table}"
      session.send(database).drop_replication_trigger trigger_name, table
    end
  end

end
