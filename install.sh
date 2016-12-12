#!/bin/bash

# -------------------
# set up vm and access it

cd /path/to/repo
vagrant up
vagrant ssh

# -------------------
# prep vm with scikit and python

sudo apt-get update
wget https://repo.continuum.io/miniconda/Miniconda2-latest-Linux-x86_64.sh
bash Miniconda2-latest-Linux-x86_64.sh -b
miniconda2/bin/conda install -y scikit-learn
sudo apt-get install -y python-pip python-dev
sudo pip install --upgrade pip
sudo pip install Cython nose numpy pandas
sudo apt-get install python-scipy

cd /vagrant/scikit-learn
make
python setup.py build
sudo python setup.py install

# -------------------
# prep vm with r

cd ~
sudo sh -c 'echo "deb http://cran.rstudio.com/bin/linux/ubuntu trusty/" >> /etc/apt/sources.list'
gpg --keyserver keyserver.ubuntu.com --recv-key E084DAB9
gpg -a --export E084DAB9 | sudo apt-key add -
sudo apt-get update

sudo apt-get -y install r-base-core=3.3.2-1trusty0
sudo apt-get -y --force-yes install r-doc-html=3.3.2-1trusty0
sudo apt-get -y install r-base-dev=3.3.2-1trusty0

sudo apt-get install -y libgdal-dev
sudo apt-get install -y libproj-dev
sudo apt-get install -y libcurl4-openssl-dev

sudo Rscript -e 'install.packages("devtools", repos="http://cran.us.r-project.org", dependencies=TRUE)'
sudo Rscript -e 'install.packages("rgdal", repos="http://cran.us.r-project.org", dependencies=TRUE)'
sudo Rscript -e 'install.packages("stargazer", repos="http://cran.us.r-project.org", dependencies=TRUE)'
sudo Rscript -e 'install.packages("sp", repos="http://cran.us.r-project.org", dependencies=TRUE)'
sudo Rscript -e 'install.packages("MatchIt", repos="http://cran.us.r-project.org", dependencies=TRUE)'
sudo Rscript -e 'install.packages("rpart.plot", repos="http://cran.us.r-project.org", dependencies=TRUE)'
sudo Rscript -e 'install.packages("matrixStats", repos="http://cran.us.r-project.org", dependencies=TRUE)'
sudo Rscript -e 'install.packages("ggplot2", repos="http://cran.us.r-project.org", dependencies=TRUE)'


# -------------------
# prep for geoML.R script

sudo apt-get install -y git

active_dir=$(date +%Y%m%d_%s)
cd /vagrant
mkdir -p run/$active_dir
rm -rf run/$active_dir
git clone https://github.com/itpir/geoML.git run/$active_dir

# -------------------
# run

# Rscript run/$active_dir/geoML.R
