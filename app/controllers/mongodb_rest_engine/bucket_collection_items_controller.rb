class MongodbRestEngine::BucketCollectionItemsController < ApplicationController

  before_filter :load_collection

  before_filter :sanitaze_request, :only => [:create, :update]

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
    render :text => @collection.save(@document).to_json
  end

  def update
    render :text => @collection.update({:_id => BSON::ObjectId(params[:id])}, @document).to_json
  end

  def destroy
    success = (BSON::ObjectId.legal?(params[:id]) and @collection.find_one({:_id => BSON::ObjectId(params[:id])}) ?
              @collection.remove({:_id => BSON::ObjectId(params[:id])}).to_json : false)
    render :text => "#{success}"
  end
  
  private
  
  def load_collection
    connection = Mongo::Connection.from_uri(MongodbRestEngine.backend_uri,
                                            {:pool_size => MongodbRestEngine.pool_size,
                                             :timeout => MongodbRestEngine.timeout})
    db = connection.db(MongodbRestEngine.db_name)

    @collection = db.collection("#{params[:bucket]}##{params[:collection]}")
  end

  def sanitaze_request
    @document = JSON.parse(params[:document]).except("_id")
  end

end