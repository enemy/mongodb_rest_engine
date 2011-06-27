class Document
  
  def initialize(hash)
    @hash = hash
  end

  def as_json(opts = {})
    @hash
  end
  
  
  def self.build_from(mongo_document)
    mongo_document["id"] = mongo_document["_id"].to_s
    sanitized_document = mongo_document.except("_id")
    
    new(sanitized_document)
  end
  
end



class Collection
  
  def initialize(mongo_collection)
    @collection = mongo_collection
  end
  
  def self.find(collection_name)
    connection = Mongo::Connection.from_uri(MongodbRestEngine.backend_uri,
                                            {:pool_size => MongodbRestEngine.pool_size,
                                             :timeout => MongodbRestEngine.timeout})
    
    db = connection.db(MongodbRestEngine.db_name)
    new db.collection(collection_name)
  end
  
  def save(document_hash)
    object_id = @collection.save(document_hash)
    
    find_document(object_id.to_s)
  end
  
  def all
    @collection.find()
  end
  
  def update(id, document_hash)
    @collection.update({:_id => BSON::ObjectId(id)}, document_hash)    
    find_document(id)
  end
  
  def destroy(id)
    document = find_document(id)
    @collection.remove({:_id => BSON::ObjectId(id)}) if document

    document
  end
  
  def find_document(id_as_string)
    Document.build_from(@collection.find_one({:_id => BSON::ObjectId(id_as_string)}))
  end
  
end



class MongodbRestEngine::BucketCollectionItemsController < ApplicationController

  before_filter :load_collection

  before_filter :sanitize_request, :only => [:create, :update]

  def index
    documents = []
    @collection.all.each do |document|
      documents << Document.build_from(document)
    end
    
    render :json => documents
  end

  def show
    document = @collection.find_document(params[:id])
    
    render :json => document
  end

  def create
    document = @collection.save(@document_hash)
    
    render :json => document
  end

  def update
    document = @collection.update(params[:id], @document_hash)
    render :json => document
  end

  def destroy
    document = @collection.destroy(params[:id])

    render :json => document
  end
  
  private
  
  def load_collection
    @collection = Collection.find("#{params[:bucket]}_#{params[:collection]}")
  end

  def sanitize_request
    body = request.body.read
    
    parsed_body = JSON.parse(body)
    parsed_body[params[:collection].singularize]
    
    @document_hash = parsed_body[params[:collection].singularize].except("id", "_id")
  end

end