module ActionDispatch::Routing
  class Mapper
    def mongo_datastore_for(namespace_name)
      scope "/#{namespace_name}" do
        get ':collection', :controller => "mongodb_rest_engine/mongodb", :action => "index"
        get ':collection/:id', :controller => "mongodb_rest_engine/mongodb", :action => "show"
        post ':collection', :controller => "mongodb_rest_engine/mongodb", :action => "create"
        put ':collection/:id', :controller => "mongodb_rest_engine/mongodb", :action => "update"
        delete ':collection/:id', :controller => "mongodb_rest_engine/mongodb", :action => "destroy"
      end
    end
  end
end