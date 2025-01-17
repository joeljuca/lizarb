class WebSystem::RequestPanelTest < Liza::PanelTest

  test :settings do
    assert_equality subject_class.log_level, 0
  end

  #

  test :call! do
    subject = WebBox[:request]
    env = {}
    env["PATH_INFO"] = "/foo/bar/baz"
    subject.call! env
    assert false
  rescue => e
    assert_equality e.class, WebSystem::SimpleRouterRequest::RequestNotFound
    assert_equality e.cause.class, Liza::ConstNotFound
  end

  test :call do
    subject = WebBox[:request]
    env = {}
    env["PATH_INFO"] = "/foo/bar/baz"
    status, headers, body = subject.call env
    assert_equality status, 500
    assert_equality body.first, "Server Error 500 - WebSystem::SimpleRouterRequest::RequestNotFound - WebSystem::SimpleRouterRequest::RequestNotFound"
  end

  #

  test :_prepare do
    subject = WebBox[:request]
    env = {}
    env["PATH_INFO"]   = "/foo/bar/baz"
    subject._prepare env
    assert_equality env, {
      "PATH_INFO"=>"/foo/bar/baz",
      "LIZA_PATH"=>"/foo/bar/baz",
      "LIZA_FORMAT"=>"html",
      "LIZA_SEGMENTS"=>["foo", "bar", "baz"]
    }

    env = {}
    env["PATH_INFO"]   = "/"
    subject._prepare env
    assert_equality env, {
      "PATH_INFO"=>"/",
      "LIZA_PATH"=>"/",
      "LIZA_FORMAT"=>"html",
      "LIZA_SEGMENTS"=>[]
    }
  end

end
