class NetSystem::SqliteDb < NetSystem::Database
  set_client :sqlite

  def now
    array = client.now
    Time.parse array[1][0]
  end

end
