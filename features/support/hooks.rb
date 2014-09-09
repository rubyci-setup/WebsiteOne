Before('@enable-custom-errors') do
  Features.enable(:custom_errors)
end

Before('@time-travel') do
  @default_tz = ENV['TZ']
  ENV['TZ'] = 'UTC'
  Delorean.time_travel_to(Time.parse('2014/02/01 09:15:00 UTC'))
end

Before('@time-travel-step') do
  @default_tz = ENV['TZ']
  ENV['TZ'] = 'UTC'
end

After('@time-travel , @time-travel-step') do
  Delorean.back_to_the_present
  ENV['TZ'] = @default_tz
end

Before('@omniauth') do
  OmniAuth.config.test_mode = true
  OmniAuth.config.mock_auth[:github] = {
      'provider' => 'github',
      'uid' => '12345678',
      'info' => {
          'email' => 'mock@email.com'
      }
  }
  OmniAuth.config.mock_auth[:gplus] = {
      'provider' => 'gplus',
      'uid' => '12345678',
      'info' => {
          'email' => 'mock@email.com'
      },
      'credentials' => {'token' => 'test_token'}
  }
end

Before('@omniauth-without-email') do
  OmniAuth.config.test_mode = true
  OmniAuth.config.mock_auth[:github] = {
      'provider' => 'github',
      'uid' => '12345678',
      'info' => {}
  }
  OmniAuth.config.mock_auth[:gplus] = {
      'provider' => 'gplus',
      'uid' => '12345678',
      'info' => {},
      'credentials' => {'token' => 'test_token'}
  }
end

After('@omniauth, @omniauth-with-email') do
  OmniAuth.config.test_mode = false
end

Before('@scrum_query') do
  VCR.insert_cassette(
    'scrums_controller/videos_by_query'
  )
end
After('@scrum_query') { VCR.eject_cassette }

Before('@github_query') do
  VCR.insert_cassette(
    'github_commit_count/websiteone_stats'
  )
end
After('@github_query') { VCR.eject_cassette }


Before('@poltergeist') do
  Capybara.javascript_driver = :poltergeist
end

Before('@tablet') do
  Capybara.register_driver :poltergeist do |app|
    Capybara::Poltergeist::Driver.new(app, window_size: [768, 768])
  end
end

Before('@smartphone') do
  Capybara.register_driver :poltergeist do |app|
    Capybara::Poltergeist::Driver.new(app, window_size: [640, 640])
  end
end

After('@poltergeist', '@tablet', '@smartphone') do
  Capybara.javascript_driver = :rack_test
end