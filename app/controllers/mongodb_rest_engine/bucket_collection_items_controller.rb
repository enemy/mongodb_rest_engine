class MongodbRestEngine::BucketCollectionItemsController < ApplicationController

  before_filter :load_collection
  
  def index
    keyz = []
    @collection.find().each do |key|
      keyz << key
    end
    
    render :text => keyz.to_json
  end
  
  def show
    render :text => @collection.find_one({:_id => BSON::ObjectId(params[:id])}).to_json
  end

  def create
    render :text => @collection.save(JSON.parse(params[:document])).to_json
  end

  def update
    render :text => @collection.update({:_id => BSON::ObjectId(params[:id])}, 
                                        JSON.parse(params[:document])).to_json
  end

  def destroy
    render :text => @collection.remove({:_id => BSON::ObjectId(params[:id])}).to_json
  end
  
  private
  
  def load_collection
    connection = Mongo::Connection.from_uri(MongodbRestEngine.backend_uri,
                                            {:pool_size => MongodbRestEngine.pool_size,
                                             :timeout => MongodbRestEngine.timeout})
    db = connection.db(MongodbRestEngine.db_name)

    @collection = db.collection("#{params[:bucket]}##{params[:collection]}")
  end

end