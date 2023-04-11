class UsersController < ApplicationController
  before_action :is_matching_login_user, only: [:edit, :update]

  def index
    @users = User.all
    # _userPrfに使用
    @userprf = current_user
    # _bookNewに使用
    @newbook = Book.new
  end

  def show
    @userprf = User.find(params[:id])
    @books = @userprf.books.all
    # _bookNewに使用
    @newbook = Book.new
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      # _bookNewに使用
      @newbook = Book.new
      redirect_to user_path(@user), notice: 'You have updated user successfully.'
    else
      render :edit
    end
  end

  private
  def user_params
    params.require(:user).permit(:name, :profile_image, :introduction)
  end

  def is_matching_login_user
    user = User.find(params[:id])
    unless user.id == current_user.id
      redirect_to user_path(current_user)
    end
  end

end
