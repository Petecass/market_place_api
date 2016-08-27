# ApiConstraints is responsible for routing the API
# request to the correct version
class ApiConstraints
  def initialize(options)
    @verison = options[:version]
    @default = options[:default]
  end

  def matches?(req)
    @default || req.headers['Accept'].include?("application/vnd.marketplace.v#{@version}")
  end
end
