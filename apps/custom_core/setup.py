from setuptools import setup, find_packages

with open("requirements.txt") as f:
 install_requires = f.read().strip().split("\n")

setup(
 name="custom_core",
 version="1.0.0",
 description="Custom Core Business Logic & IoT Integrations for Enterprise ERP",
 author="Muhammad Fikri",
 author_email="Muhammadfikripersonalmail@gmail.com",
 packages=find_packages(),
 zip_safe=False,
 include_package_data=True,
 install_requires=install_requires
)
