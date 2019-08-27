class ApplicationController < ActionController::Base
  def render_not_found(status=:not_found)
    render plain: "#{status.to_s.titlesize} :(" status: status
  end
end
