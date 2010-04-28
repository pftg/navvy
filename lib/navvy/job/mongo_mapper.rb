require 'rubygems'
require 'mongo_mapper'
require File.expand_path(File.dirname(__FILE__) + '/mongodb')

module Navvy
  class Job
    include MongoMapper::Document

    key :object,        String
    key :method_name,   Symbol
    key :arguments,     String
    key :priority,      Integer, :default => 0
    key :return,        String
    key :exception,     String
    key :parent_id,     ObjectId
    key :created_at,    Time
    key :run_at,        Time
    key :started_at,    Time
    key :completed_at,  Time
    key :failed_at,     Time

    ##
    # Find the next available jobs in the queue. This will not include failed
    # jobs (where :failed_at is not nil) and jobs that should run in the future
    # (where :run_at is greater than the current time).
    #
    # @param [Integer] limit the limit of jobs to be fetched. Defaults to
    # Navvy::Job.limit
    #
    # @return [array, nil] the next available jobs in an array or nil if no
    # jobs were found.

    def self.next(limit = self.limit)
      all(
        :failed_at =>     nil,
        :completed_at =>  nil,
        :run_at =>        {'$lte' => Time.now},
        :order =>         'priority desc, created_at asc',
        :limit =>         limit
      )
    end

    ##
    # Check how many times the job has failed. Will try to find jobs with a
    # parent_id that's the same as self.id and count them
    #
    # @return [Integer] count the amount of times the job has failed

    def times_failed
      i = parent_id || id
      self.class.count(
        :failed_at => {'$ne' => nil},
        '$where' => "this._id == '#{i}' || this.parent_id == '#{i}'"
      )
    end
  end
end
