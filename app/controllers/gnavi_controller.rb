class GnaviController < ApplicationController

  # 要ログイン
  before_filter :login_required

end
