# Extend default list of trusted proxies with generic private and cloudflare proxy list

# Cloudflare proxies list
# config/cloudflare_ips.yml fetches every time you build an image. Check Dockerfile l54, l55
cloudflare_ips = File.read('config/cloudflare_ips.yml').split(/\R+/)
extend_proxies = cloudflare_ips.map do |proxy|
  puts "attempting to ade proxy: #{proxy.inspect}"
  next if proxy.match? /222400/
  puts "confirmed attempting to ade proxy: #{proxy.inspect}"
  IPAddr.new(proxy)
end

Rails.application.config.action_dispatch.trusted_proxies = ActionDispatch::RemoteIp::TRUSTED_PROXIES + extend_proxies
