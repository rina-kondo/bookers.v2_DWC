class BooksController < ApplicationController
  before_action :is_matching_login_user, only: [:edit, :update, :destroy]

  def new
    @newbook = Book.new
  end

  def create
    @newbook = Book.new(book_params)
    @newbook.user_id = current_user.id
    if @newbook.save
      # _userPrfに使用
      @userprf = @newbook.user
      redirect_to book_path(@newbook), notice: 'You have created book successfully.'
    else
      @books = Book.all
      # _userPrfに使用
      @book = current_user.books.find_by(params[:user_id])
      @userprf = @book.user
      render :index
    end
  end

  def index
    @books = Book.all
    # _userPrfに使用
    @userprf = current_user
    # _bookNewに使用
    @newbook = Book.new
  end

  def show
    @book = Book.find(params[:id])
    # _userPrfに使用
    @userprf = @book.user
    # _bookNewに使用
    @newbook = Book.new
  end

  def edit
    @book = Book.find(params[:id])
  end

  def update
    @book = Book.find(params[:id])

    if @book.update(book_params)
      # _bookNewに使用
      @newbook = Book.new
      # _userPrfに使用
      @userprf = @book.user
      redirect_to book_path(@book), notice: 'You have updated book successfully.'
    else
      render :edit
    end
  end

  def destroy
    book = Book.find(params[:id])
    book.destroy
    redirect_to books_path
  end


  private

  def book_params
    params.require(:book).permit(:title, :body)
  end

  def is_matching_login_user
    book = Book.find(params[:id])
    unless book.user_id == current_user.id
      redirect_to books_path
    end
  end


end
