
boxlist=$(vagrant box list)
echo $boxlist
echo '///////////////////////////////////////////'
if [[ $boxlist != *"mybase"* ]]; then
  vagrant destroy -f

  vagrant up base

  bash scripts/make_base_image.sh
fi



vagrant up