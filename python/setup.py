import os
from setuptools import setup, find_packages

setup_pth = os.path.dirname(__file__)
readme_pth = os.path.join(setup_pth, 'README.md')

setup(
    name='referer-parser',
    version="0.3.1",
    long_description=open(readme_pth).read(),
    packages=find_packages(),
    include_package_data=True,
    package_data={'referer_parser': ['data/referers.json']},
    zip_safe=False,
)
