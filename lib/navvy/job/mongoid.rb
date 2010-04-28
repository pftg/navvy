require 'rubygems'
require 'mongoid'
require File.expand_path(File.dirname(__FILE__) + '/mongodb')

module Navvy
  class Job
    include Mongoid::Document

    field :object,        :type => String
    field :method_name,   :type => String
    field :arguments,     :type => String
    field :priority,      :type => Integer, :default => 0
    field :return,        :type => String
    field :exception,     :type => String
    field :parent_id,     :type => String
    field :created_at,    :type => Time
    field :run_at,        :type => Time
    field :started_at,    :type => Time
    field :completed_at,  :type => Time
    field :failed_at,     :type => Time

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
      where(
        :failed_at =>     nil,
        :completed_at =>  nil,
        :run_at =>        {'$lte' => Time.now}
      ).order_by(
        [
          [:priority, :desc],
          [:created_at, :asc]
        ]
      ).limit(
        limit
      )
    end

    ##
    # Check how many times the job has failed. Will try to find jobs with a
    # parent_id that's the same as self.id and count them
    #
    # @return [Integer] count the amount of times the job has failed

    def times_failed
      i = parent_id || id
      self.class.where(
        :failed_at => {'$ne' => nil},
        '$where' => "this._id == '#{i}' || this.parent_id == '#{i}'"
      ).count
    end
  end
end
