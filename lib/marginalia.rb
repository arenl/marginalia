require 'marginalia/railtie'
require 'marginalia/comment'

module Marginalia
  mattr_accessor :application_name

  module ActiveRecordInstrumentation
    def self.included(instrumented_class)
      Marginalia::Comment.components = [:application, :controller, :action]
      instrumented_class.class_eval do
        if defined? :exec_query
          alias_method :exec_query_without_marginalia, :exec_query
          alias_method :exec_query, :exec_query_with_marginalia
        end
      end
    end

    def exec_query_with_marginalia(sql, name = 'SQL', binds = [])
      exec_query_without_marginalia "#{sql} /*#{Marginalia::Comment.to_s}*/", name, binds
    end
  end
end
