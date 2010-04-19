require 'rubygems'
require 'mongoid'

module Navvy
  class Job
    include Mongoid::Document

    field :object,        :type => String
    field :method_name,   :type => Symbol
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
  end
end
require File.expand_path(File.dirname(__FILE__) + '/mongodb')
