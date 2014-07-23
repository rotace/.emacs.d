
#### define variable ####
$usr = 'vagrant'

#### default setting ####
Exec {
  path  => ['/usr/sbin','/usr/bin','/sbin','/bin'],
  group => 'root',
  user  => 'root',
}



