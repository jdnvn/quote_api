class HighlightsController < ApplicationController
  def index
    highlights = Highlight.includes(:book).order('highlights.created_at DESC').order('highlights.highlighted_at DESC')
    render json: highlights, status: :ok
  end

  def show
    @highlight = Highlight.find_by(id: params[:id])

    if highlight
      render json: highlight, status: :ok
    else
      render json: { error: "Could not find that highlight anywhere..." }, status: :not_found
    end
  end

  def create
    result = Highlights::Create.new(attributes: params).call

    if result.success?
      render json: result.value, status: :created
    else
      render json: result.error, status: :unprocessable_entity
    end
  end

  def update
    highlight = Highlight.find_by(id: params.dig(:params, :id))
    return render json: "No highlight with that id", status: :not_found unless highlight

    result = Highlights::Update.new(highlight: highlight, attributes: params["params"]).call

    if result.success?
      render json: result.value, status: :ok
    else
      render json: result.error, status: :unprocessable_entity
    end
  end

  def destroy
    Highlight.find_by(id: params[:id]).destroy!

    render status: :no_content
  end

  def ocr
    result = Highlights::Ocr.new(bytes: params['bytes']).call

    if result.success?
      render json: { text: result.value }, status: :ok
    else
      render json: { error: result.error }, status: :unprocessable_entity
    end
  end
end
