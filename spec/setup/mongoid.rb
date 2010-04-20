require File.expand_path(File.dirname(__FILE__) + '/../../lib/navvy/job/mongoid')
Mongoid.database = Mongo::Connection.new.db('navvy_test')
