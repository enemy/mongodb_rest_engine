module ActionDispatch::Routing
  class Mapper
    def mongo_datastore_for(namespace_name, *resources)
      options = resources.extract_options!

      if options[:controllers] and options[:controllers][:bucket_collection_items]
        bucket_collection_items_controller = options[:controllers][:bucket_collection_items]
      else
        bucket_collection_items_controller = "mongodb_rest_engine/bucket_collection_items"
      end

      scope "/#{namespace_name}/:bucket/:collection", :constraints => {:bucket => /\w+/, :collection => /\w+/} do
        get '/', :controller => bucket_collection_items_controller, :action => "index"
        get ':id', :controller => bucket_collection_items_controller, :action => "show"
        post '/', :controller => bucket_collection_items_controller, :action => "create"
        put ':id', :controller => bucket_collection_items_controller, :action => "update"
        delete ':id', :controller => bucket_collection_items_controller, :action => "destroy"
      end
    end
  end
end