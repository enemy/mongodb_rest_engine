class MongodbRestEngine::BucketCollectionItemsController < ApplicationController

  before_filter :load_collection

  before_filter :sanitize_request, :only => [:create, :update]

  def index
    documents = []
    begin
      query_param = JSON(params[:query]) if params[:query]
      sort_param = JSON(params[:sort]) if params[:sort]
      fields_param = JSON(params[:fields]) if params[:fields]
      fields_param.delete("_id") if fields_param # ^__^
      fields_param["_id"] = fields_param.delete("id") if fields_param and fields_param["id"] # ^__^;
    rescue JSON::ParserError
      render :text => 'Malformed parameter(s)', :status => 400
      return
    end

    opts = {:limit => params[:limit].to_i, :sort => sort_param, :fields => fields_param, :skip => params[:skip].to_i}

    @collection.all(query_param, opts).each do |document|
      documents << MongodbRestEngine::Document.build_from(document)
    end

    render :json => documents, :callback => params[:callback]
  end

  def show
    document = @collection.find_document(params[:id])

    render :json => document, :callback => params[:callback]
  end

  def create
    document = @collection.save(@document_hash)

    render :json => document, :callback => params[:callback]
  end

  def update
    document = @collection.update(params[:id], @document_hash)

    render :json => document, :callback => params[:callback]
  end

  def destroy
    document = @collection.destroy(params[:id])

    render :json => document, :callback => params[:callback]
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