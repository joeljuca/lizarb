class DevSystem::LogPanelTest < Liza::PanelTest

  test :subject_class do
    assert subject_class == DevSystem::LogPanel
  end

  test_methods_defined do
    on_self
    on_instance :call
  end

  test :settings do
    assert subject_class.log_level == :normal
    assert subject_class.log_color == :green
  end

  # test :call do
  #   todo "write this"
  # end

end
