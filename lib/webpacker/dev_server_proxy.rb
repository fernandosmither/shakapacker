require "rack/proxy"

class Webpacker::DevServerProxy < Shakapacker::DevServerProxy
  def initialize(app = nil, opts = {})
    # FIXME: This might not work because when I super, it would override @webpacker!

    @webpacker = opts.delete(:webpacker) || Webpacker.instance
    super
  end
end
