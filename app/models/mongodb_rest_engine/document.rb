class MongodbRestEngine::Document

  def initialize(hash)
    @hash = hash
  end

  def as_json(opts = {})
    @hash
  end


  def self.build_from(mongo_document)
    nil unless mongo_document
    mongo_document["id"] = mongo_document["_id"].to_s if mongo_document["_id"]
    sanitized_document = mongo_document.except("_id")

    new(sanitized_document)
  end

end