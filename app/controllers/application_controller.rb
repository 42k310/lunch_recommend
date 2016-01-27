class ApplicationController < ActionController::Base

  # CSRF対策（不正な場合はSessionをクリア）
  protect_from_forgery

  # SSL証明書の検証をしない
  OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE

  # ControllerとViewの両方で使うメソッドを指定
  helper_method :current_user

  ## ログインチェック
  # @return [User] ユーザー情報
  def login_required

    if session[:user_id].blank?
      # セッション情報が無い場合はログインページへリダイレクト
      redirect_to signin_path and return
    end

    # ユーザー情報取得
    @current_user = User.find_by(id: session[:user_id])

    if @current_user.blank?
      # ユーザー情報が取得できなかった場合はログインページへリダイレクト
      redirect_to signin_path and return
    end

    # ログインユーザー情報を返却
    @current_user

  end

  private

  ## ユーザー情報取得
  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

end
