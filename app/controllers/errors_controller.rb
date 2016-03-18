# class ErrorsController < ApplicationController
class ErrorsController < ActionController::Base
  def error404
    render action: "errors/error404", status: 404
  end
  def error500
    render action: "errors/error500", status: 500
  end
end
