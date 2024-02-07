require 'bcrypt'

class SessionController < ApplicationController
  before_action :set_user, only: %i[ auth ]

  def auth
    if user_params["email"].empty? || user_params["password"].empty?
      @errors = "Email ou Senha estão vazios"
      render template: "users/index", status: :unprocessable_entity
    else
      return if session[:user_auth]

      users = session[:users_list]
      user = user_exists?(users)

      if user && @user.password == user[:password]
        session[:user_auth] = SecureRandom.base64(32)
        session[:user] = user
        redirect_to home_path
      else
        @errors = "Email ou Senha estão inválidos!!"
        render template: "users/index", status: :unprocessable_entity
      end
    end
  end

  def logout
    if session[:user_auth]
      session.delete(:user_auth)
      session.delete(:user)
    end
    redirect_to users_path
  end

  private
  def user_exists? users
    users = transform_to_object(users)
    return false if users.empty?
    users.each do |user|
      if user["email"].casecmp?(@user.email)
        return user
      end
    end
  end

  def transform_to_object users_text
    users = []
    users_text.each do |user|
      user_info = user.split(";")
      users.push(User.new(email: user_info[0], name: user_info[1], password: user_info[2]))
    end
    users
  end

  def set_user
    @user = User.new(user_params)
    @user.password = user_params[:password]
  end

  def user_params
    params.require(:user).permit(:email, :password)
  end
end