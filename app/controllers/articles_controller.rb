class ArticlesController < ApplicationController
  before_action :authenticate_user!, except: [:show, :index]
  before_action :set_article, only: [:show, :edit, :update, :destroy]

  def index
    @articles = Article.all
    authorize @articles
  end
  def show
    @article = Article.find(params[:id])
    authorize @article
  end
  def new
    @article = Article.new
    authorize @article
  end

  def create
    authorize @article
    @article = Article.new(article_params)
    @article.user = current_user
    if @article.save
      redirect_to @article
    else
      render :new
    end
  end

  def edit
    authorize @article
    @article = Article.find(params[:id])
  end

  def update
    @article = Article.find(params[:id])
    authorize @article

    if @article.update(article_params)
      redirect_to @article
    else
      render :edit
    end
  end

  def destroy
    @article = Article.find(params[:id])
    authorize @article
    @article.destroy

    redirect_to root_path
  end

  private
    def article_params
      params.require(:article).permit(:title, :body, :status)
    end

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  private

  def user_not_authorized
    flash[:warning] = "You need to be authorized to perform this action."
    redirect_to(request.referrer || root_path)
  end

end
