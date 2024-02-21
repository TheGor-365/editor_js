class ArticlesController < ApplicationController
  before_action :set_article, only: %i[ show edit update destroy ]

  def index
    @articles = Article.all
  end

  def show
  end

  def new
    @article = Article.new
  end

  def edit
  end

  def create
    @article = Article.new(article_params)
    @article.save ? (redirect_to article_url(@article)) : (render :new)
  end

  def update
    @article.update(article_params) ? (redirect_to article_url(@article)) : (render :edit)
  end

  def destroy
    @article.destroy
    redirect_to articles_url
  end

  def upload_image
    image = params[:image]

    if image.nil?
      render json: { success: 0, error: 'No image found in request' }
      return
    end

    uploaded_image   = ArticleImage.create!(image: image)
    stored_image_url = rails_blob_url(uploaded_image.image)

    render json: { success: 1, file: { url: stored_image_url } }
  rescue StandardError => e
    render json: { success: 0, error: e.message }
  end

  private

  def set_article
    @article = Article.find(params[:id])
  end

  def article_params
    params.require(:article).permit(:title, :content)
  end
end
