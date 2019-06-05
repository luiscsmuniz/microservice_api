class Rack::Attack
  self.cache.store = ActiveSupport::Cache::MemoryStore.new 

  throttle('api/ip', limit: 60, period: 1.minute) do |req|
    if req.path == '/api/tasks' && req.get?
      req.ip
    end
  end 


  self.throttled_response = lambda do |env|
    now = env['rack.attack.throttle_data']['api/ip'][:epoch_time]
    period = env['rack.attack.throttle_data']['api/ip'][:period]
    body = {
      error: 'Acesso bloqueado! Aguarde alguns segundos para realizar novas requisições.'
  }.to_json

    [ 429,  # status
      {
        'Content-Type' => 'application/json; charset=utf-8',
        'Date' => Time.now,
        'Retry-After' => 60,
        'X-RateLimit-Limit' => 60,
        'X-RateLimit-Reset' => Time.at(now + (period - now.to_i % period)).to_s,
        'X-RateLimit-Remaining' => 1
      },   # headers
      [body]
    ] # body
  end
end
