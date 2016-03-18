class ApplicationController < ActionController::Base

  # CSRF対策（不正な場合はSessionをクリア）
  # TODO: 設定を有効にしてもAjaxが動くように
  # protect_from_forgery

  # SSL証明書の検証をしない
  OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE

  # ControllerとViewの両方で使うメソッドを指定
  helper_method :current_user

  ## ログインチェック
  # @return [User] ユーザー情報
  def login_required

    if session[:uid].blank?
      # セッション情報が無い場合はログインページへリダイレクト
      redirect_to signin_path and return
    end

    # ユーザー情報取得
    @current_user = User.find_by(uid: session[:uid])

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
    @current_user ||= User.find_by(uid: session[:uid]) if session[:uid]
  end

  # 404エラー
  # rescue_from AbstractController::ActionNotFound, with: :error_404 unless Rails.env.development?
  # rescue_from ActionController::RoutingError, with: :error_404 unless Rails.env.development?

  # 500エラー
  rescue_from Exception, with: :error_505 unless Rails.env.development?

  def error_404
    logger.info "Rendering 404 with exception: #{e.message}" if e
    render template: 'errors/error_404', status: 404, content_type: 'text/html'
  end
  def error_500
    logger.info "Rendering 500 with exception: #{e.message}" if e
    render template: 'errors/error_404', status: 404, content_type: 'text/html'
  end

end
