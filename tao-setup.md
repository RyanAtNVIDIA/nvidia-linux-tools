# Setting up TAO Toolkit
## Step 1 - Installing TAO
From: https://docs.nvidia.com/tao/tao-toolkit/text/tao_toolkit_quick_start_guide.html

TAO Toolkit is a Python pip package that is hosted on the NVIDIA PyIndex. The package uses the docker restAPI under the hood to interact with the NGC Docker registry to pull and instantiate the underlying docker containers. You must have an NGC account and an API key associated with your account. See the Installation Prerequisites section for details on creating an NGC account and obtaining an API key.

Create a new virtualenv using virtualenvwrapper. From : https://python-guide-cn.readthedocs.io/en/latest/dev/virtualenvs.html
```
sudo apt intall python-pip
pip install virtualenv
sudo apt install virtualenv
virtualenv venv
source venv/bin/activate
deactivate
```
```
sudo apt install virtualenvwrapper
```

export WORKON_HOME=$HOME/.virtualenvs
export PROJECT_HOME=$HOME/Devel
source /usr/local/bin/virtualenvwrapper.sh
