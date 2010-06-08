#this overrides paginating_find and patches all existing calls to for paginating_find and redirects to will_paginate
module PaginatingFind

  def self.included(base)
    base.extend(ClassMethods)
    base.class_eval do
      class << self
        alias_method_chain :find, :pagination
      end
    end
  end

  module ClassMethods

    def find_with_pagination(*args)
      options = if args.respond_to?(:extract_options!)
        args.extract_options!
      else
        extract_options_from_args!(args)
      end
      #
      page_options = options.delete(:page) || (args.delete(:page) ? 1 : nil)
      if page_options
        #paginating_find expected :page to be a hash... will_paginate expects :page to be an integer
        options[:per_page] = page_options[:size] || per_page
        if page_options.is_a? Hash
          options[:page] =  page_options[:current]
        else
          options[:page] = page_options.to_i
        end
        cached_scoped_methods = self.current_scoped_methods
        if cached_scoped_methods
          self.with_scope(cached_scoped_methods) do
            paginate(*(args << options))
          end
        else
          #pass onto will_paginate
          paginate(*(args << options))
        end  
      else
        # The :page option was not specified, so invoke the
        # usual AR::Base#find method
        find_without_pagination(*(args << options))
      end

    end
    
  end
  
end