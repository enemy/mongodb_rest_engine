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