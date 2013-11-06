module EasyAuth::Controllers::Authenticated
  extend ActiveSupport::Concern

  included do
    before_filter :attempt_to_authenticate
  end

  private

  def attempt_to_authenticate
    if account_not_signed_in?
      session[:requested_path] = request.method == 'GET' ? request.path :  request.referer
      stash_filtered_params
      respond_to do |format|
        format.html { redirect_to main_app.sign_in_url }
        format.json { render :json => {}, :status => 401 }
      end
    end
  end

  def stash_filtered_params
    filter_params(params, params_filter)
    session[:stashed_params] = params
  end

  def filter_params(hash, filter)
    hash.each do |k,v|
      if filter.include?(k) || filter.include?(k.to_sym)
        hash.delete(k)
      else
        filter_params(v, filter) if v.is_a?(Hash)
      end
    end
  end

  def params_filter
    # This method defines the param keys to be filtered before being stashed. It can be overwritten to filter
    # out additional keys. The filtered keys will not be stashed.
    # The method should return an array of strings or symbols.
    ['password', 'action', 'controller']
  end
end
