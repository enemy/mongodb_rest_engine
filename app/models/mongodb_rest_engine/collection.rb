class MongodbRestEngine::Collection

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

  def all(selector = {}, opts = {})
    @collection.find(selector, opts)
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
    MongodbRestEngine::Document.build_from(
              @collection.find_one({:_id => BSON::ObjectId(id_as_string)})
            ) if BSON::ObjectId.legal? id_as_string
  end

end