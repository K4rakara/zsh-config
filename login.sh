#!/bin/zsh

if [[ "$(cat /etc/os-release 2>/dev/null)" == *"archlinux"* ]]
then
    cat <<-EOF

     [36m      /\\
     [36m     /  \\
     [36m    /\\   \\
     [36m   /      \\
     [34m  /   ,,   \\
     [34m /   |  |  -\\
     [34m/_-''    ''-_\\[0m

EOF
else
  cat <<-EOF
     [34m     ___
         |[0m.. [34m|
         ([1;33m<> [0;34m)
        / [0;1m__[0;34m  \\
       ( [0;1m|## [0;34m) )
     [33;1m\\^^\\[0;1m|##[0;34m(/[33;1m^^/
      \\_/[0;34m____[33;1m\\_/[0m
    
EOF
fi

echo "Welcome to [34;1m${HOST}[0m, [1m${USER}[0m.";
echo;

