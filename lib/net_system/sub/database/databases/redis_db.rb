class NetSystem::RedisDb < NetSystem::Database
  set_client :redis

  def now
    array = client.now
    Time.at array[0]
  end

end
