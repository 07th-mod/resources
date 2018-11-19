import os, shutil, glob

for zip in glob.glob('./*.zip'):
    os.remove(zip)

for seven in glob.glob('./*.7z'):
    os.remove(seven)

shutil.rmtree('./temp')

for py in glob.glob('./*.py'):
    os.remove(py)