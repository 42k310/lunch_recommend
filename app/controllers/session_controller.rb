class SessionsController < ApplicationController

  def callback

    # auth = request.env['omniauth.auth']
    #
    # # auth情報を元にユーザをDB登録
    # # sessionにユーザIDを保持
    # binding.pry  # デバッグ用

    redirect_to root_path

  end

  def destroy
    reset_session
    redirect_to root_path
  end

  def failure
    redirect_to root_path
  end
end