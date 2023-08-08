class NetSystem::MysqlDbTest < NetSystem::DatabaseTest

  test :subject_class do
    assert_equality subject_class, NetSystem::MysqlDb
  end

  test :subject do
    assert_equality subject.client.class, NetSystem::MysqlClient
  end

  test :now do
    t = subject.now
    assert! t.is_a? Time
    assert_equality t.yday, Time.now.utc.yday
  end

  # test :call do
  #   todo "write this"
  # end

end
