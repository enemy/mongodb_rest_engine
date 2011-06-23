module ActionDispatch::Routing
  class Mapper
    def mongo_datastore_for(namespace_name, *resources)
      options = resources.extract_options!

      if options[:controllers] and options[:controllers][:mongodb]
        mongodb_controller = options[:controllers][:mongodb] 
      else
        mongodb_controller = "mongodb_rest_engine/mongodb"
      end

      scope "/#{namespace_name}" do
        get ':bucket/:collection', :controller => mongodb_controller, :action => "index"
        get ':bucket/:collection/:id', :controller => mongodb_controller, :action => "show"
        post ':bucket/:collection', :controller => mongodb_controller, :action => "create"
        put ':bucket/:collection/:id', :controller => mongodb_controller, :action => "update"
        delete ':bucket/:collection/:id', :controller => mongodb_controller, :action => "destroy"
      end
    end
  end
end