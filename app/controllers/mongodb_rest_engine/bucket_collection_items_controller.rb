class MongodbRestEngine::BucketCollectionItemsController < ApplicationController

  before_filter :load_collection

  before_filter :sanitize_request, :only => [:create, :update]

  def index
    documents = []
    begin
      filter_param = JSON(params[:filter]) if params[:filter]
    rescue JSON::ParserError
      render :text => 'Malformed parameter "filter"', :status => 400
      return
    end

    @collection.all(filter_param).each do |document|
      documents << MongodbRestEngine::Document.build_from(document)
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
    @collection = MongodbRestEngine::Collection.find("#{params[:bucket]}.#{params[:collection]}")
  end

  def sanitize_request
    body = request.body.read
    
    begin
      parsed_body = JSON(body)
    rescue JSON::ParserError
      render :text => "Malformed JSON", :status => 400
      return
    end

    @document_hash = parsed_body.except("id", "_id")
  end

end