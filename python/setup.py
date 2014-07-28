import os
from setuptools import setup, find_packages

setup_pth = os.path.dirname(__file__)
readme_pth = os.path.join(setup_pth, 'README.md')

setup(
    name='referer-parser',
    version="0.3.0",
    long_description=open(readme_pth).read(),
    packages=find_packages(),
    package_data={'referer_parser': ['data/referers.json', ]},
    include_package_data=True,
    zip_safe=False,
)
