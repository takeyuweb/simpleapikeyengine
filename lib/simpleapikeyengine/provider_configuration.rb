class SimpleApiKeyEngine::Configuration < Hash
  def method_missing(method, *params)
    if method.to_s =~ /^(.+)=$/
      self[$1.to_sym] = params.first
    else
      self[method.to_sym]
    end
  end
end
