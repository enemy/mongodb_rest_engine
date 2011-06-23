class MongodbRestEngine::MongodbController < ApplicationController

  before_filter :init_collection
  
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
  
  def init_collection
    # WORKSFORME: refactor this

    if ENV['MONGOLAB_URI']
      connection = Mongo::Connection.from_uri(ENV['MONGOLAB_URI'], {:pool_size => 5, :timeout => 5})
      db = connection.db(ENV['MONGOLAB_URI'].split("/").last)
    elsif ENV['MONGOHQ_URL']
      connection = Mongo::Connection.from_uri(ENV['MONGOHQ_URL'], {:pool_size => 5, :timeout => 5})
      db = connection.db(ENV['MONGOHQ_URL'].split("/").last)
    else
      db = Mongo::Connection.new.db('db') # configure db name?
    end

    @collection = db.collection("#{params[:bucket]}_#{params[:collection]}")
  end

end