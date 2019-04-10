echo ">> Warning : Script designed to update and clean for image release"
echo ">> Update repositories"
sudo apt update && sudo apt upgrade -y
echo ">> Update other tooling"
bash <(curl https://get.parity.io -L); npm update -g
echo ">> Update local repositories"
cd /home/bobby/Tutorials
for i in */.git; do ( echo ">>> $i ";cd $i/..; git pull;); done;
cd 
echo ">> Cleaning"
sudo apt-get -y --purge autoremove; sudo apt-get -y clean; bleachbit -c --preset; rm .bash_history
echo ">> Update done "

