define homeshick::profile {
  $data = hiera("homeshick::profile::${name}", false)

  if $data {
    exec { "install homeshick profile ${name}":
      command     => "/usr/bin/git clone https://github.com/andsens/homeshick.git ${data[home]}/.homesick/repos/homeshick",
      environment => ["HOME=${data[home]}"],
      user        => $data['user'],
      timeout     => 0,
      creates     => "${data[home]}/.homesick/repos/homeshick",
      logoutput   => 'on_failure',
      require     => [Package['git']]
    }

    exec { "link homeshick profile ${name}":
      command     => "${data[home]}/.homesick/repos/homeshick/bin/homeshick link --batch --quiet",
      environment => ["HOME=${data[home]}"],
      user        => $data['user'],
      logoutput   => 'on_failure',
      cwd         => $data['home'],
      refreshonly => true,
      require     => Exec["install homeshick profile ${name}"],
    }

    create_resources('castle', $data['castles'], {
      profile => $name,
      user    => $data['user'],
      home    => $data['home'],
    })
  }
}