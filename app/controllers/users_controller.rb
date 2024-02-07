class UsersController < ApplicationController
  before_action :verify_session_users
  # before_action :set_user, only: %i[ show edit update destroy ]
  before_action :is_authenticated

  # GET /users or /users.json
  def index
    self.setUser
    render :index
  end

  def register
    @user = User.new if !@user
    render :register
  end

  # GET /users/new
  def setUser
    @user = User.new if !@user
  end

  # POST /users or /users.json
  def create
    @user = User.new(user_params)
    @user.password = user_params[:password]
    #Rails.cache.keys
    respond_to do |format|
      if @user && @user.valid?
        session[:users_list].push("#{@user.email};#{@user.name};#{@user.password}" )
        format.html { redirect_to users_path, notice: "Usuário foi criado com sucesso!." }
      else
        format.html { render :register, status: :unprocessable_entity }
      end
    end
  end


  private
  def verify_session_users
    unless session[:users_list]
      session[:users_list] = []
    end
  end

  def user_params
    params.require(:user).permit(:name, :email, :password)
  end

  def is_authenticated
    if session[:user_auth]
      redirect_to home_path
    end
  end
end
