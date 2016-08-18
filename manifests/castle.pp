define homeshick::castle ($profile, $user, $home, $url, $upstream = '') {
  exec { "castle ${title}":
    command     => "${home}/.homesick/repos/homeshick/bin/homeshick clone -b ${url}",
    environment => ["HOME=${home}"],
    user        => $user,
    logoutput   => 'on_failure',
    cwd         => $home,
    creates     => "${home}/.homesick/repos/${name}",
    notify      => Exec["link homeshick profile ${profile}"],
  }

  if $upstream {
    exec { "castle-upstream ${title}":
      command     => "/usr/bin/git remote set-url --push origin ${upstream}",
      environment => ["HOME=${home}"],
      user        => $user,
      logoutput   => 'on_failure',
      cwd         => "${home}/.homesick/repos/${name}",
      unless      => "/usr/bin/git remote -v | grep -e ^origin | grep '(push)' | grep '${upstream}'",
      require     => [Package['git'], Exec["castle ${title}"]],
    }
  }
}