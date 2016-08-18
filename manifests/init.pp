class homeshick (
  $profiles = hiera_array('homeshick')
) inherits homeshick::params {
  ensure_packages('git')
  homeshick::profile { $profiles: }
}