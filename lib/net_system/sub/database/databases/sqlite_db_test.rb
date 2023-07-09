class NetSystem::SqliteDbTest < NetSystem::DatabaseTest

  test :subject_class do
    assert subject_class == NetSystem::SqliteDb
  end

  test :subject do
    assert subject.client.class == NetSystem::SqliteClient
  end

  test :now do
    t = subject.now
    assert! t.is_a? Time
    assert t.yday == Time.now.yday
  end

  # test :call do
  #   todo "write this"
  # end

end
