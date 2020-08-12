PYTHONPATH=/opt/slate-portal/venv/lib64/python27.zip:/opt/slate-portal/venv/lib64/python2.7:/opt/slate-portal/venv/lib64/python2.7/plat-linux2:/opt/slate-portal/venv/lib64/python2.7/lib-tk:/opt/slate-portal/venv/lib64/python2.7/lib-old:/opt/slate-portal/venv/lib64/python2.7/lib-dynload:/usr/lib64/python2.7:/usr/lib/python2.7:/opt/slate-portal/venv/lib/python2.7/site-packages

echo 'Creating portal Virtual Environment..'
source /opt/slate-portal/venv/bin/activate

echo 'Starting portal...'
python /opt/slate-portal/run_portal.py
