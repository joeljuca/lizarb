class DevSystem::HtmlFormatterGeneratorTest < DevSystem::FormatterGeneratorTest

  test :subject_class do
    assert subject_class == DevSystem::HtmlFormatterGenerator
  end

  test :settings do
    assert_equality subject_class.log_level, 0
  end

  test :format do
    source, expectation = <<-HTML_1, <<-HTML_2
<!DOCTYPE html>
<html>
<head>
<title>Beauty</title>
</head>
<body>
<header>
<nav>
<a>
<span></span>
</a>
</nav>
</header>
</body>
</html>
HTML_1
<!DOCTYPE html>
<html>
  <head>
    <title>Beauty</title>
  </head>
  <body>
    <header>
      <nav>
        <a>
          <span></span>
        </a>
      </nav>
    </header>
  </body>
</html>
HTML_2
    expectation = expectation.strip

    output = subject_class.format source
    assert_equality output, expectation
  end

end
