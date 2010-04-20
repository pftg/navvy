require 'rubygems'
require 'mongo_mapper'

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
  end
end

require File.expand_path(File.dirname(__FILE__) + '/mongodb')
