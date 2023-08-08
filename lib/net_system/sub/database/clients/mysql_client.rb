class NetSystem::MysqlClient < NetSystem::Client

  # https://www.mysql.com/
  # https://github.com/brianmario/mysql2
  def initialize hash={}
    t = Time.now
    hash = NetBox[:client].get(:mysql_hash) if hash.empty?
    @conn = Mysql2::Client.new(hash)
  ensure
    log "#{t.diff}s | Connecting to #{hash}"
  end

  attr_reader :conn

  def call sql, *args
    t = Time.now
    result = @conn.query sql, *args

    result
  ensure
    log "#{t.diff}s | #{sql} | #{args}"
  end

  def now
    call "SELECT UTC_TIMESTAMP()"
  end

end
