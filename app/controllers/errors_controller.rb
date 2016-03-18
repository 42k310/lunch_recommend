# class ErrorsController < ApplicationController
class ErrorsController < ActionController::Base
  def error_404
    render action: "errors/error_404", status: 404
  end
  def error_500
    render action: "errors/error_500", status: 500
  end
end
